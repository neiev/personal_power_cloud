import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:path_provider/path_provider.dart';
import 'package:personal_power_cloud/providers/auth_provider.dart';
import 'package:personal_power_cloud/utils/file_storage.dart';
import 'package:personal_power_cloud/widgets/action_bar.dart';
import 'package:personal_power_cloud/widgets/action_buttons.dart';
import 'package:personal_power_cloud/theme/pallete.dart';
import 'package:personal_power_cloud/utils/screen_utils.dart';
import 'package:personal_power_cloud/widgets/file_item.dart';
import 'package:personal_power_cloud/widgets/move_file.dart';
import 'package:personal_power_cloud/widgets/navigation_buttons.dart';
import 'package:provider/provider.dart';
import 'package:personal_power_cloud/screens/crawler_internal_storage_screen.dart';
import 'package:personal_power_cloud/screens/crawler_ppc_screen.dart';
import 'package:personal_power_cloud/utils/action_bar_functions.dart';
// ignore: depend_on_referenced_packages, library_prefixes
import 'package:path/path.dart' as pathLib;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:personal_power_cloud/providers/storage_provider.dart';

class CrawlerGoogleDriveScreen extends StatefulWidget {
  const CrawlerGoogleDriveScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CrawlerGoogleDriveScreenState createState() => _CrawlerGoogleDriveScreenState();
}

class _CrawlerGoogleDriveScreenState extends State<CrawlerGoogleDriveScreen>{
  bool activatedByMove = false;
  bool isSelectAllPressed = false;
  bool activatedByCopy = false;
  bool isBottomActionBarVisible = false;
  bool isButtonEncryptPressed = false;
  bool isButtonSyncPressed = false;
  Set<dynamic> selectedFiles = {};
  Map<String, bool> syncState = {};
  Map<String, bool> encryptState = {};
  String searchQuery = '';
  List<dynamic> fileList = [];
  bool isButton1Pressed = false;
  bool isButton2Pressed = false;
  List<dynamic> synchronizedFolders = [];
  Set<dynamic> trashFilesList = {};
  dynamic authClient = '';

  @override
  void initState() {
    super.initState();
    connectAndListFiles();
    loadStates();
  }

  Future<void> connectAndListFiles() async {
    try {
      authClient = Provider.of<AuthProvider>(context, listen: false).authClient;
      if (authClient == null) {
        if (kDebugMode) {
          print('Erro: Cliente não autenticado.');
        }
        return;
      }

      final driveApi = drive.DriveApi(authClient);
      // Listar arquivos e pastas no Google Drive
      drive.FileList fileListResponse = await driveApi.files.list();
      List<drive.File>? files = fileListResponse.files;

      if (files != null && files.isNotEmpty) {
        setState(() {
          fileList = files;
        });
      } else {
        if (kDebugMode) {
          print('Nenhum arquivo ou pasta encontrado.');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Erro ao listar arquivos do Google Drive: $e');
      }
    }
  }

  Future<void> loadStates() async {
    final prefs = await SharedPreferences.getInstance();
    final syncStateString = prefs.getString('syncState');
    final encryptStateString = prefs.getString('encryptState');
    if (syncStateString != null) {
      syncState = Map<String, bool>.from(jsonDecode(syncStateString));
    }
    if (encryptStateString != null) {
      encryptState = Map<String, bool>.from(jsonDecode(encryptStateString));
    }
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

  void toggleBotomActionBarVisibility() {
    setState(() {
      isBottomActionBarVisible = !isBottomActionBarVisible;
    });
  }

  Future<void> saveStates() async {
    final prefs = await SharedPreferences.getInstance();
    final syncStateMap = syncState.map((file, isSync) => MapEntry(file, isSync));
    final encryptStateMap = encryptState.map((file, isEncrypt) => MapEntry(file, isEncrypt));
    await prefs.setString('syncState', jsonEncode(syncStateMap));
    await prefs.setString('encryptState', jsonEncode(encryptStateMap));
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
                  // moveToTrash(selectedFiles);
                  moveToTrash(drive.DriveApi(authClient), selectedFiles.cast<drive.File>().toList());
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

  Future<void> moveToTrash(drive.DriveApi driveApi, List<drive.File> selectedFiles) async {
    final storageProvider = Provider.of<StorageProvider>(context, listen: false);
    for (var file in selectedFiles) {
      try {
        await driveApi.files.update(drive.File(trashed: true), file.id!);
        if (kDebugMode) {
          print('Arquivo movido para a lixeira: ${file.name}');
        }
        storageProvider.addToTrash(file); // Adiciona o arquivo à lixeira do aplicativo
      } catch (e) {
        if (kDebugMode) {
          print('Erro ao mover o arquivo para a lixeira: $e');
        }
      }
    }
    updateTrashList(selectedFiles); // Atualiza a lista de arquivos da lixeira no aplicativo
  }

  void updateTrashList(List<drive.File> selectedFiles) {
    setState(() {
      trashFilesList.addAll(selectedFiles);
      fileList.removeWhere((file) => selectedFiles.contains(file));
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
      if (originalFile is drive.File == false) {
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

  void toggleFileSelection(dynamic file) {
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
      syncState[file.id] = !isFolderMarked(file.id, syncState);
      if (shouldUpdate) {
        for (var selectedFile in selectedFiles) {
          syncState[selectedFile.id] = syncState[file.id] ?? false;
        }
      }
    });
  }

  // Verifica se uma pasta está marcada
  bool isFolderMarked(String path, Map<String, bool> state) {
    return state[path] ?? false;
  }

  void toggleEncryptState(dynamic file, bool shouldUpdate) {
    setState(() {
      encryptState[file.id] = !isFolderMarked(file.id, encryptState);
      if (shouldUpdate) {
        for (var selectedFile in selectedFiles) {
          encryptState[selectedFile.id] = encryptState[file.id] ?? false;
        }
      }
      if (kDebugMode) {
        print('Encrypt state for ${file.id}: ${encryptState[file.id]}');
      }
    });
  }

  Future<bool> _onWillPop(BuildContext context) async {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const CrawlerPpcScreen()),
    );
    return false; // Retorne false para evitar que a tela atual seja removida da pilha
  }

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () => _onWillPop(context), // Aqui você chama o método _onWillPop
      child: Scaffold(
        backgroundColor: Pallete.backgroundColor,
        body: SafeArea(  // Adicionando o SafeArea aqui
          child: Center(
            child: Column(
              children: [

                // SizedBox(height: getHeight(context, 0.046)),

                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.9, // 90% da largura da tela
                  height: MediaQuery.of(context).size.height * 0.06, // 6% da altura da tela
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    decoration: BoxDecoration(
                      color: Pallete.boxColor,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Pallete.borderColor, width: 1),
                    ),
                    child: Row(
                      children: [
                        const Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: 'Search',
                              border: InputBorder.none,
                              hintStyle: TextStyle(
                                color: Pallete.backgroundTextColor,
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Image.asset(
                            'assets/images/search_blue.png',
                            width: 36,
                            height: 36,
                          ),
                          onPressed: () {
                            // Implemente a lógica de pesquisa aqui
                            if (kDebugMode) {
                              print('Search button pressed');
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),

                // SizedBox(height: getHeight(context, 0.02)),

                buildNavigationBar(context, 'google_drive'),

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
                    isButtonSyncPressed,
                    isButtonEncryptPressed,
                    _toggleActionBarVisibility,
                    _toggleActivatedByCopy,
                    _toggleActivatedByMove,
                    toggleSyncState,
                    toggleEncryptState,
                    // _saveStates,
                    saveStates,
                    // _deleteFiles
                    deleteFiles
                  ),
                ),

                // SizedBox(height: getHeight(context, 0.02)),

                Expanded(
                  child: _buildFileListGoogleDrive(),
                ),

              ],
            ),
          ),
        ),

        bottomNavigationBar: buildBottomNavigationBar(
          context, 
          '', 
          'crawler', 
          () => navigateToScreen(const CrawlerInternalStorageScreen(), context), 
          null
        ),

      ),
    );
  }

  Widget _buildFileListGoogleDrive() {
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
          final drive.File file = fileList[index];
          final baseName = file.name ?? '';
          // ignore: collection_methods_unrelated_type
          final isSelected = selectedFiles.contains(file);
          final isSynced = (syncState[file.id] ?? false) || (syncState[baseName] ?? false) || isFolderMarked(pathLib.dirname(file.id ?? ''), syncState);
          final isEncrypted = (encryptState[file.id] ?? false) || (encryptState[baseName] ?? false) || isFolderMarked(pathLib.dirname(file.id ?? ''), encryptState);
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

  List<dynamic> _getFilteredFileList() {
    if (searchQuery.isEmpty) {
      return fileList;
    }
    return fileList.where((file) {
      final fileName = file.name?.toLowerCase();
      final query = searchQuery.toLowerCase();
      return fileName!.contains(query);
    }).toList();
  }

}
