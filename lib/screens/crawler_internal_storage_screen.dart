import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// ignore: depend_on_referenced_packages, library_prefixes
import 'package:path/path.dart' as pathLib;
import 'package:path_provider/path_provider.dart';
import 'package:personal_power_cloud/widgets/action_bar.dart';
import 'package:personal_power_cloud/widgets/action_buttons.dart';
import 'package:personal_power_cloud/theme/decorations.dart';
import 'package:personal_power_cloud/widgets/custom_popup.dart';
import 'package:personal_power_cloud/widgets/move_file.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:personal_power_cloud/utils/file_storage.dart';
import 'package:personal_power_cloud/utils/file_system_service.dart';
import 'package:personal_power_cloud/screens/logout_screen.dart';
import 'package:personal_power_cloud/screens/recovery_screen.dart';
import 'package:personal_power_cloud/screens/remote_access_screen.dart';
import 'package:personal_power_cloud/screens/storage_screen.dart';
import 'package:personal_power_cloud/screens/trash_screen.dart';
import 'package:personal_power_cloud/widgets/file_item.dart';
import 'package:personal_power_cloud/widgets/icon_button.dart';
import 'package:personal_power_cloud/widgets/navigation_buttons.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:personal_power_cloud/theme/pallete.dart';
import 'package:personal_power_cloud/utils/screen_utils.dart';
import 'package:personal_power_cloud/widgets/search_bar.dart' as custom;

// width: MediaQuery.of(context).size.width * 0.9, // 90% da largura da tela
// height: MediaQuery.of(context).size.height * 0.06, // 6% da altura da tela

class CrawlerInternalStorageScreen extends StatefulWidget {
  final String initialPath;
  final String rootPath;
  final String rootDrive;
  final List<String> navigationHistory;

  const CrawlerInternalStorageScreen({
    super.key,
    this.initialPath = '',
    this.rootPath = '',
    this.rootDrive = '',
    this.navigationHistory = const [],
  });

  @override
  // ignore: library_private_types_in_public_api
  CrawlerInternalStorageScreenState createState() => CrawlerInternalStorageScreenState();
}

class CrawlerInternalStorageScreenState extends State<CrawlerInternalStorageScreen> {
  bool isSelectAllPressed = false;
  bool isButton1Pressed = false;
  bool isButton2Pressed = false;
  bool isBottomActionBarVisible = false;
  bool activatedByCopy = false;
  bool activatedByMove = false;
  List<FileSystemEntity> fileList = [];
  List<FileSystemEntity> drives = [];
  List<FileSystemEntity> synchronizedFolders = [];
  List<String> navigationHistory = [];
  String searchQuery = '';
  String currentPath = '';
  String ultimo = '';
  Map<String, bool> syncState = {};
  Map<String, bool> encryptState = {};
  Set<FileSystemEntity> selectedFiles = {};
  Set<FileSystemEntity> trashFilesList = {};

  void showCustomPopup({
    required BuildContext context,
    required String title,
    required String message,
    required List<Widget> actions,
    double? width,
    // double? height,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false, // Impede o fechamento ao clicar fora
      builder: (context) => CustomPopup(
        title: title,
        message: message,
        actions: actions,
        width: width,
        // height: height,
      ),
    );
  }

  get file => null;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
    
      showCustomPopup(
        context: context,
        title: 'Permission',
        message: 'Allow Personal Power Cloud to access photos, media and files on your device?',
        width: MediaQuery.of(context).size.width * 0.9, // Define a largura
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              SizedBox(
                width: MediaQuery.of(context).size.width * 0.319,
                height: MediaQuery.of(context).size.height * 0.06,
                child: TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Pallete.firstButtonColor,
                    foregroundColor: Pallete.bottomTextColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      side: const BorderSide(color: Pallete.borderColor, width: 1),
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop(); // Fecha o popup
                  },
                  child: const Text(
                    'Allow',
                    style: TextStyle(
                      fontSize: 25.0,
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 16.0),

              SizedBox(
                width: MediaQuery.of(context).size.width * 0.319,
                height: MediaQuery.of(context).size.height * 0.06,
                child: ElevatedButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Pallete.secondButtonColor,
                    foregroundColor: Pallete.bottomTextColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      side: const BorderSide(color: Pallete.borderColor, width: 1),
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                    // Outra ação
                  },
                  child: const Text(
                    'Deny',
                    style: TextStyle(
                      fontSize: 25.0,
                    ),
                  ),
                ),
              ),
            ],
          ),

        ],

      );

      if (!kIsWeb){
        if (Platform.isAndroid) {
          if (widget.initialPath.isEmpty) {
            _requestPermissionsAndLoadFiles();
          } else {
            loadFiles(widget.initialPath);
          }
        }
        if(Platform.isWindows){
          if (widget.initialPath.isEmpty) {
            getDrives();
          } else {
            loadFiles(widget.initialPath);
          }
        }
      } else {
        if (widget.initialPath.isEmpty) {
          getDrives();
        } else {
          loadFiles(widget.initialPath);
        }
      }
      loadStates();
    });
  }

  Future<void> loadStates() async {
    final prefs = await SharedPreferences.getInstance();
    final syncStateString = prefs.getString('syncState');
    final encryptStateString = prefs.getString('encryptState');
    if (syncStateString != null) {
      final syncStateMap = Map<String, bool>.from(jsonDecode(syncStateString));
      setState(() {
        syncState = syncStateMap.map((path, isSync) => MapEntry(path, isSync));
      });
    }
    if (encryptStateString != null) {
      final encryptStateMap = Map<String, bool>.from(jsonDecode(encryptStateString));
      setState(() {
        encryptState = encryptStateMap.map((path, isEncrypt) => MapEntry(path, isEncrypt));
      });
    }
  }

  Future<void> saveStates() async {
    final prefs = await SharedPreferences.getInstance();
    final syncStateMap = syncState.map((file, isSync) => MapEntry(file, isSync));
    final encryptStateMap = encryptState.map((file, isEncrypt) => MapEntry(file, isEncrypt));
    await prefs.setString('syncState', jsonEncode(syncStateMap));
    await prefs.setString('encryptState', jsonEncode(encryptStateMap));
  }

  @override
  void dispose() {
    saveStates();
    super.dispose();
  }

  Future<void> _requestPermissionsAndLoadFiles() async {
    if (await Permission.storage.request().isGranted) {
      _loadAndroidExternalFiles();
    } else if (await Permission.manageExternalStorage.request().isGranted) {
      _loadAndroidExternalFiles();
    } else {
      // Handle the case where permission is not granted
      if (await Permission.storage.isPermanentlyDenied || await Permission.manageExternalStorage.isPermanentlyDenied) {
        openAppSettings();
      }
    }
  }
  
  Future<void> requestPermissions() async {
    // Solicitar permissão de leitura e gravação no armazenamento
    PermissionStatus status = await Permission.storage.request();

    if (status.isGranted) {
      // Se a permissão for concedida, chama a função para listar os arquivos
      _loadAndroidExternalFiles();  // Carregar arquivos após a permissão
    } else {
      if (kDebugMode) {
        print("Permissão negada. Tentando abrir configurações...");
      }
      openStoragePermissionSettings();
    }
  }

  Future<void> openStoragePermissionSettings() async {
    // Solicita permissão para acesso total ao armazenamento (apenas Android 10+)
    await Permission.manageExternalStorage.request();
  }

  // ignore: non_constant_identifier_names
  Future<void> bkp_loadAndroidExternalFiles() async {
    try {
      // Obtendo o diretório de armazenamento externo
      final externalDirectory = await getExternalStorageDirectory();
      
      // Obtendo o diretório interno do aplicativo
      final internalDirectory = await getApplicationDocumentsDirectory();

      // Verificar se conseguimos acessar o diretório externo
      if (externalDirectory != null) {
        if (kDebugMode) {
          print("Diretório externo: ${externalDirectory.path}");
        }

        setState(() {
          currentPath = internalDirectory.path;

          fileList = [];

          // Listando arquivos no diretório externo
          fileList.addAll(Directory(externalDirectory.path).listSync());

          // Listando arquivos no diretório interno
          fileList.addAll(Directory(internalDirectory.path).listSync());

          // Carregar os estados (se necessário)
          loadStates();
          saveStates();
        });

      } else {
        if (kDebugMode) {
          print("Não foi possível acessar o diretório externo.");
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print("Erro ao acessar os diretórios: $e");
      }
    }
  }

  Future<bool> _hasPermission(Directory directory) async {
    try {
      // final List<FileSystemEntity> files = await directory.list().toList();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> _loadAndroidExternalFiles() async {
    try {
      final directory = Directory('/storage/emulated/0/');
      currentPath = directory.path;
      if (directory.existsSync() && await _hasPermission(directory)) {
        loadFiles(directory.path);
      } else {
        final externalDirectory = await getExternalStorageDirectory();
        if (externalDirectory != null) {
          loadFiles(externalDirectory.path);
        } else {
          final downloadsDirectory = await getDownloadsDirectory();
          if (downloadsDirectory != null) {
            loadFiles(downloadsDirectory.path);
          }
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print("Erro ao acessar os diretórios: $e");
      }
    }
  }

  void main() {
    // Chama a função para solicitar permissões antes de acessar os arquivos
    requestPermissions();
  }

  Future<void> loadFilesAndroid(String path) async {
    try {
      final directory = Directory(path);
      if (kDebugMode) {
        print(directory);
      }
      final List<FileSystemEntity> files = await directory.list().toList();
      setState(() {
        fileList = files;
        currentPath = path;
      });
      if (kDebugMode) {
        print('Files loaded: ${fileList.length}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Erro ao carregar arquivos: $e');
      }
    }
  }

  Future<void> loadFiles(String path) async {
    try {
      if(Platform.isAndroid){
        bool isTopLevel = path == '/storage/emulated/0/' || path.isEmpty;
        if (path.isNotEmpty || isTopLevel) {
          navigationHistory.add(path);
        } else {
          //saveStates();
          Navigator.of(context).pop();
        }
        loadFilesAndroid(path);
        return;
      }
      bool isTopLevel = (path == widget.rootPath || widget.rootPath == pathLib.join(path, '')) || path.isEmpty;
      if (path.isNotEmpty && path.contains('\\') || isTopLevel) {
        navigationHistory.add(path);
      } else {
        saveStates();
        Navigator.of(context).pop();
      }
      final searchPath = path.isNotEmpty ? path : widget.rootPath;
      final files = await FileSystemService.getFiles(searchPath);
      setState(() {
        fileList = files;
        loadStates();
        // _updateSyncAndEncryptStates();
      });
      if (kDebugMode) {
        print('Files loaded: ${fileList.length}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Erro ao carregar arquivos: $e');
      }
    }
  }

  Future<void> getDrives() async {
    try {
      if (!kIsWeb && (Platform.isWindows || Platform.isMacOS || Platform.isLinux)) {
        // Executa apenas em plataformas desktop
        final result = await Process.run('wmic', ['logicaldisk', 'get', 'name']);
        final output = result.stdout.toString().trim();
        final lines = output
            .split('\n')
            .skip(1)
            .where((line) => line.trim().isNotEmpty)
            .toList();
        final directories = lines.map((line) {
          final drive = line.trim() + ("\\");
          return Directory(drive);
        }).toList();

        setState(() {
          fileList = directories;
          drives = directories;
          loadStates();
        });
      } else {
        if (kDebugMode) {
          print('Platform does not support Process.run or is running on the web.');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error: $e');
      }
    }
  }

  void toggleSelectAll() {
    setState(() {
      if (isSelectAllPressed) {
        selectedFiles.clear();
        isButton1Pressed = false;
        isButton2Pressed = false;
      } else {
        selectedFiles.addAll(fileList);
      }
      isSelectAllPressed = !isSelectAllPressed;
    });
  }

  void toggleFileSelection(FileSystemEntity file) {
    setState(() {
      if (selectedFiles.contains(file)) {
        selectedFiles.remove(file);
        if (selectedFiles.isEmpty) {
          isButton1Pressed = false;
          isButton2Pressed = false;
        }
      } else {
        selectedFiles.add(file);
      }
    });
  }

  void toggleSyncState(dynamic file, bool shouldUpdate) {
    setState(() {
      syncState[file.path] = !isFolderMarked(file.path, syncState);
      if (shouldUpdate) {
        for (var selectedFile in selectedFiles) {
          syncState[selectedFile.path] = syncState[file.path] ?? false;
        }
      }
    });
  }

  void toggleEncryptState(dynamic file, bool shouldUpdate) {
    setState(() {
      encryptState[file.path] = !isFolderMarked(file.path, encryptState);
      if (shouldUpdate) {
        for (var selectedFile in selectedFiles) {
          encryptState[selectedFile.path] = encryptState[file.path] ?? false;
        }
      }
      if (kDebugMode) {
        print('Encrypt state for ${file.path}: ${encryptState[file.path]}');
      }
    });
  }

  List<FileSystemEntity> _getFilteredFileList() {
    if (searchQuery.isEmpty) {
      return fileList;
    }
    return fileList.where((file) {
      final fileName = pathLib.basename(file.path).toLowerCase();
      final query = searchQuery.toLowerCase();
      return fileName.contains(query);
    }).toList();
  }

  void _toggleActionBarVisibility() {
    setState(() {
      isBottomActionBarVisible = !isBottomActionBarVisible;
    });
  }

  void _toggleActivatedByCopy() {
    setState(() {
      activatedByCopy = !activatedByCopy;
    });
  }

  void _toggleActivatedByMove() {
    setState(() {
      activatedByMove = !activatedByMove;
    });
  }

  Future<bool> _onWillPop(BuildContext context) async {
    SystemNavigator.pop(); // Fecha o aplicativo
    return false; // Retorne false para evitar que a tela atual seja removida da pilha
  }

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () => _onWillPop(context), // Vincula o método _onWillPop
      child: Scaffold(
        backgroundColor: Pallete.backgroundColor,
        body: SafeArea( // Garante que o conteúdo não fique atrás da barra de status
          child: Center(
              child: Column(
                children: [

                  // SizedBox(height: getHeight(context, 0.046)),

                  const custom.SearchBar(), // Apenas insere o widget.

                  // SizedBox(height: getHeight(context, 0.02)),

                  buildNavigationBar(context, 'crawler'),

                  // SizedBox(height: getHeight(context, 0.02)),

                  buildActionBar(
                    context,
                    isSelectAllPressed,
                    toggleSelectAll,
                    activatedByCopy,
                    activatedByMove,
                    fileList,
                    buildActionButtons(
                      context,
                      isBottomActionBarVisible,
                      activatedByCopy,
                      activatedByMove,
                      selectedFiles.toList(),
                      isButton1Pressed,
                      isButton2Pressed,
                      _toggleActionBarVisibility,
                      _toggleActivatedByCopy,
                      _toggleActivatedByMove,
                      toggleSyncState,
                      toggleEncryptState,
                      saveStates,
                      deleteFiles,
                    ),
                  ),

                  // SizedBox(height: getHeight(context, 0.02)),

                  Expanded(
                    child: _buildFileList(),
                  ),

                  isBottomActionBarVisible
                      ? buildNavigationBar(context, 'crawler')
                      : const SizedBox.shrink(),
                ],
              ),
            ),
          ),

        bottomNavigationBar: buildBottomNavigationBar(
          context,
          ultimo,
          'crawler',
          navigateBack,
          resetFileList,
        ),

      ),
    );
  }

  toggleActivatedByCopy() {
    setState(() {
      activatedByCopy = !activatedByCopy;
    });
  }

  toggleActivatedByMove() {
    setState(() {
      activatedByMove = !activatedByMove;
    });
  }

  void deleteFiles() {
    showCustomPopup(
      context: context,
      title: 'Delete',
      message: 'Are you sending the selected files to the Trash?',
      width: MediaQuery.of(context).size.width * 0.9, // Define a largura
      // height: MediaQuery.of(context).size.height * 0.4, // Define a altura
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.2,
              height: MediaQuery.of(context).size.height * 0.06,
              child: TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Pallete.firstButtonColor,
                  foregroundColor: Pallete.bottomTextColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    side: const BorderSide(color: Pallete.borderColor, width: 1),
                  ),
                ),
                onPressed: () {
                  moveToTrash(selectedFiles);
                  Navigator.of(context).pop();
                },
                child: const Text(
                  'Yes',
                  style: TextStyle(
                    fontSize: 25.0,
                  ),
                ),
              ),
            ),

            const SizedBox(width: 16.0),

            SizedBox(
              width: MediaQuery.of(context).size.width * 0.2,
              height: MediaQuery.of(context).size.height * 0.06,
              child: ElevatedButton(
                style: TextButton.styleFrom(
                  backgroundColor: Pallete.secondButtonColor,
                  foregroundColor: Pallete.bottomTextColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    side: const BorderSide(color: Pallete.borderColor, width: 1),
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                  // Outra ação
                },
                child: const Text(
                  'No',
                  style: TextStyle(
                    fontSize: 25.0,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    ); 
  }

  moveToTrash(selectedFilesForTrash) {
    trashFilesList.addAll(selectedFilesForTrash);
    fileList.removeWhere((file) => selectedFilesForTrash.contains(file));
    fileList = fileList.where((file) => !selectedFilesForTrash.contains(file)).toList();
    adicionarArquivosDaLixeira();
    setState(() {
      trashFilesList = trashFilesList;
      fileList = fileList;
    });
  }

  Future<void> adicionarArquivosDaLixeira() async {
    final trashFolderPath = await getTrashFolderPath();

    if (kDebugMode) {
      print('trashFolderPath $trashFolderPath');
    }
    appTrashFilesList.addAll(trashFilesList);
    if (kDebugMode) {
      print('appTrashFilesList $appTrashFilesList');
    }

    // Definindo o targetPath com fallback para getDefaultTrashPath
    final targetPath = trashFolderPath?.isNotEmpty == true ? trashFolderPath : await getDefaultTrashPath();

    if (kDebugMode) {
      print('targetPath $targetPath');
    }

    // Verificando e criando o diretório de destino, se necessário
    if (!Directory(targetPath!).existsSync()) {
      Directory(targetPath).createSync(recursive: true);
      if (kDebugMode) {
        print('Diretório de destino criado: $targetPath');
      }
    }

    // Movendo arquivos ou diretórios
    for (var originalFile in trashFilesList) {
      if (originalFile is File || originalFile is Directory) {
        // await moveFile(originalFile, targetPath);
        try {
          await moveFile(originalFile, targetPath);
          if (kDebugMode) {
            print('Arquivo/diretório movido: ${originalFile.path}');
          }
        } catch (e) {
          if (kDebugMode) {
            print('Erro ao mover o arquivo: $e');
          }
        }
      }
    }
  }

  Future<String> getDefaultTrashPath() async {
    if (Platform.isAndroid) {
      // Diretório padrão para o Android
      final directory = await getExternalStorageDirectory();
      return '${directory!.path}/AppTrash';
    } else if (Platform.isIOS) {
      // Diretório padrão para o iOS
      final directory = await getApplicationDocumentsDirectory();
      return '${directory.path}/AppTrash';
    } else if (Platform.isWindows) {
      // Diretório padrão para o Windows
      final directory = await getApplicationDocumentsDirectory();
      return '${directory.path}\\AppTrash';
    } else if (Platform.isMacOS || Platform.isLinux) {
      // Diretório padrão para macOS e Linux
      final directory = Directory.systemTemp;
      return '${directory.path}/AppTrash';
    } else {
      throw UnsupportedError('Plataforma não suportada');
    }
  }

  void navigateBack() {
    if (navigationHistory.isNotEmpty) {
      setState(() {
        currentPath = navigationHistory.removeLast();
        loadFiles(currentPath);
      });
    } else {
      if(Platform.isWindows){
        getDrives();
      } else {
        _requestPermissionsAndLoadFiles();
      }
    }
  }

  void resetFileList() async {
    if (kDebugMode) {
      print('Resetting file list');
    }
    if (navigationHistory.isNotEmpty) {
      final pathParts = navigationHistory.last.split('\\');
      pathParts.removeLast();
      ultimo = pathParts.join('\\');
    }
    final previousPath = navigationHistory.isNotEmpty && ultimo != widget.initialPath ? ultimo : widget.rootPath;
    setState(() {
      currentPath = previousPath;
      fileList.clear();
      selectedFiles.clear();
      syncState.clear();
      encryptState.clear();
      searchQuery = '';
    });
    if(Platform.isAndroid){
      if (navigationHistory.isNotEmpty && ultimo != widget.initialPath && ultimo.isNotEmpty){
        loadFilesAndroid(previousPath);
      } else {
        _requestPermissionsAndLoadFiles();
      }
    }
    else if (navigationHistory.isNotEmpty && ultimo != widget.initialPath && ultimo.isNotEmpty && ultimo + ('\\') != widget.initialPath) {
      loadFiles(ultimo);
    } else {
      getDrives();
    }
  }

  Future<List<FileSystemEntity>> getNewFiles(String path) async {
    final directoryPath = path;
    final directory = Directory(directoryPath);
    if (!directory.existsSync()) {
      return [];
    }
    final allFiles = await directory.list().toList();
    final newFiles = allFiles.where((file) => !fileList.contains(file)).toList();
    return newFiles;
  }

  void resetTheFileList(String path) async {
    List<FileSystemEntity> newFiles = await getNewFiles(path);
    setState(() {
      for (var file in newFiles) {
        if (!fileList.contains(file)) {
          fileList.add(file);
        }
      }
    });
  }

  Widget _buildFileList() {
    _getFilteredFileList();
    if (kDebugMode) {
      print(fileList.length);
    }
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.9, 
      height: MediaQuery.of(context).size.height * 0.06,  
      child: ListView.builder(
        itemCount: fileList.length,
        itemBuilder: (context, index) {
          if (kDebugMode) {
            print(fileList[index]);
          }
          final file = fileList[index];
          final baseName = pathLib.basename(file.path);
          final isSelected = selectedFiles.contains(file);
          final isSynced = (syncState[file.path] ?? false) || (syncState[baseName] ?? false) || isFolderMarked(pathLib.dirname(file.path), syncState);
          final isEncrypted = (encryptState[file.path] ?? false) || (encryptState[baseName] ?? false) || isFolderMarked(pathLib.dirname(file.path), encryptState);
          return FileItemWidget(
            file: file,
            isSelected: isSelected,
            onTap: () => toggleFileSelection(file),
            isButton1Pressed: isButton1Pressed,
            isButton2Pressed: isButton2Pressed,
            syncState: syncState,
            encryptState: encryptState,
            synchronizedFolders: synchronizedFolders,
            isSynced: isSynced,
            isEncrypted: isEncrypted,
          );
        },
      ),
    );
  }

  bool isFolderMarked(String folderPath, Map<String, bool> stateMap) {
    String currentPath = folderPath;
    while (currentPath.isNotEmpty) {
      if (stateMap[currentPath] == true) {
        return true;
      }
      currentPath = pathLib.dirname(currentPath);
      String parentPath = pathLib.dirname(currentPath);
      if (parentPath == currentPath) {
        break;
      }
    }
    return false;
  }

}

Widget buildNavigationBar(BuildContext context, String selectedScreen) {
  if (kDebugMode) {
    print('selectedScreen $selectedScreen');
  }
  return Container(
    width: getWidth(context, 0.9),
    height: getHeight(context, 0.06),
    decoration: boxDecoration(),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [buildIconButton('assets/images/internal_storage_blue.png',
        () {
          if (selectedScreen != 'crawler') {navigateToScreen(const CrawlerInternalStorageScreen(),context);}
        },
          true,
          selectedScreen == 'crawler'),
        ...buildNavigationButtons(context, selectedScreen),
      ],
    ),
  );
}

Widget buildBottomNavIconButton(
  BuildContext context, 
  String iconPath, 
  VoidCallback onPressed, 
  VoidCallback callback,
) {
  return IconButton(
    icon: Image.asset(iconPath),
    iconSize: 36,
    onPressed: () {
      if (iconPath == 'assets/images/crawler_blue.png') {
        callback();
        if (kDebugMode) {
          print('Button 1 pressed');
        }
      } else {
        onPressed();
      }
    },
  );
}

List<Widget> buildBottomNavButtons(
  BuildContext context, 
  String currentPath, 
  String currentScreen, 
  void Function() ? navigateBack, 
  dynamic Function() ? resetTheFileList,
) {

  void callback() {
    if (resetTheFileList != null) {
      resetTheFileList();
    }
  }

  if (kDebugMode) {
    print('currentPath $currentPath currentScreen $currentScreen');
  }

  return [
    buildBottomNavIconButton(
      context,
      currentScreen == 'crawler'
        ? 'assets/images/crawler_blue.png'
        : 'assets/images/crawler_white.png', 
      () {
          if (resetTheFileList != null) {
            resetTheFileList();
          }

          if (navigateBack != null) {
            navigateBack();
          }

          if (kDebugMode) {
            print('Botão crawler pressionado');
          }
      }, 
      () {
        if (resetTheFileList != null) resetTheFileList();
      }

    ),

    buildBottomNavIconButton(
      context,
      currentScreen == 'storage'
        ? 'assets/images/storage_blue.png'
        : 'assets/images/storage_white.png',
      () {
        if (kDebugMode) {
          print('Botão storage pressionado');
        }
        navigateToScreen(
          const StorageScreen(),
          context
        );
      },
      callback
    ),

    buildBottomNavIconButton(
      context,
      currentScreen == 'recovery'
        ? 'assets/images/recovery_blue.png'
        : 'assets/images/recovery_white.png',
      () {
        if (kDebugMode) {
          print('Botão recovery pressionado');
        }
        navigateToScreen(
          const RecoveryScreen(),
          context
        );
      },
      callback
    ),

    buildBottomNavIconButton(
      context,
      currentScreen == 'remote'
        ? 'assets/images/remote_access_blue.png'
        : 'assets/images/remote_access_white.png',
      () {
        if (kDebugMode) {
          print('Botão remote pressionado');
        }
        navigateToScreen(
          const RemoteAccessScreen(),
          context
        );
      },
      callback
    ),

    buildBottomNavIconButton(
      context,
      currentScreen == 'trash'
        ? 'assets/images/trash_blue.png'
        : 'assets/images/trash_white.png',
      () {
        if (kDebugMode) {
          print('Botão trash pressionado');
        }
        navigateToScreen(
          const TrashScreen(), 
          context
        );
      },
      callback
    ),

    buildBottomNavIconButton(
      context,
      currentScreen == 'logout'
        ? 'assets/images/logout_blue.png'
        : 'assets/images/logout_white.png',
      () {
        if (kDebugMode) {
          print('Botão logout pressionado');
        }
        navigateToScreen(
          const LogoutScreen(), 
          context
        );
      },
      callback
    ),

  ];
}

Widget buildBottomNavigationBar(
  BuildContext context, 
  String currentPath, 
  String currentScreen, 
  void Function() ? navigateBack, 
  dynamic Function() ? resetFileList,
) {
  double screenHeight = MediaQuery.of(context).size.height;
  double navBarHeight = screenHeight * 0.06;
  return Container(
    decoration: BoxDecoration(
      border: Border.all(
        color: Pallete.borderColor, 
        width: 1,
      ),
    ),
    child: Container(
      color: Pallete.firstButtonColor,
      height: navBarHeight,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ...buildBottomNavButtons(
            context,
            currentPath,
            currentScreen,
            navigateBack,
            resetFileList
          ),
        ],
      ),
    ),
  );
}

void toggleActionBarVisibility(void Function() callback) {
  callback();
}

void toggleActivatedByCopy(void Function() callback) {
  callback();
}

void toggleActivatedByMove(void Function() callback) {
  callback();
}

void toggleSyncState(void Function() callback) {
  callback();
}