import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
// ignore: depend_on_referenced_packages, library_prefixes
import 'package:path/path.dart' as pathLib;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:personal_power_cloud/providers/storage_provider.dart';
import 'package:personal_power_cloud/screens/remote_access_screen.dart';
import 'package:personal_power_cloud/utils/file_storage.dart';
import 'package:personal_power_cloud/theme/pallete.dart';
import 'package:personal_power_cloud/widgets/action_bar.dart';
import 'package:personal_power_cloud/widgets/action_buttons.dart';
import 'package:personal_power_cloud/widgets/file_list_builder.dart';
import 'package:personal_power_cloud/screens/crawler_internal_storage_screen.dart';
import 'package:personal_power_cloud/widgets/move_file.dart';
import 'package:personal_power_cloud/widgets/navigation_buttons.dart';
import 'package:personal_power_cloud/utils/screen_utils.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:personal_power_cloud/utils/file_storage.dart';

class TrashScreen extends StatefulWidget {
  const TrashScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _TrashScreenState createState() => _TrashScreenState();
}

class _TrashScreenState extends State<TrashScreen> {
  bool isSelectAllPressed = false;
  Set<dynamic> selectedFiles = {};
  bool isButton1Pressed = false;
  bool isButton2Pressed = false;
  bool activatedByCopy = false;
  bool activatedByMove = false;
  bool isBottomActionBarVisible = false;
  Map<String, bool> syncState = {};
  Map<String, bool> encryptState = {};
  Set<dynamic> trashFilesList = {};
  List<dynamic> synchronizedFolders = [];

  @override
  void initState() {
    super.initState();
    _loadTrashFiles(); // Carrega arquivos ao iniciar
  }

  void toggleSelectAll() {
    setState(() {
  
      if (isSelectAllPressed) {
        // Desmarca todos os itens
        selectedFiles.clear();
        isButton1Pressed = false;
        isButton2Pressed = false;

      } else {
        // Marca todos os itens visíveis
        selectedFiles.addAll(appTrashFilesList);
      }

      isSelectAllPressed = !isSelectAllPressed;

      if (kDebugMode) {
        print('Selected Files: ${selectedFiles.map((e) => e.path).toList()}');
      }

    });
  }

  void toggleFileSelection(dynamic file) {
    setState(() {
      if (selectedFiles.contains(file)) {
        selectedFiles.remove(file);
      } else {
        selectedFiles.add(file);
      }
    });
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

  Future<void> saveStates() async {
    final prefs = await SharedPreferences.getInstance();
    final syncStateMap = syncState.map((file, isSync) => MapEntry(file, isSync));
    final encryptStateMap = encryptState.map((file, isEncrypt) => MapEntry(file, isEncrypt));
    await prefs.setString('syncState', jsonEncode(syncStateMap));
    await prefs.setString('encryptState', jsonEncode(encryptStateMap));
  }

  void deleteFilePermanently(dynamic file) {
    try {
      file.deleteSync();
      if (kDebugMode) {
        print('Arquivo excluído: ${file.path}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Erro ao excluir o arquivo: $e');
      }
    }
  }

  void deleteFilesFromTrash() {
    showCustomPopup(
      context: context,
      title: 'Delete permanently',
      message: 'Are you sure you would like to permanently delete files from the Trash?',
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
                  for (var file in selectedFiles) {
                    deleteFilePermanently(file);
                  }
                  setState(() {
                    selectedFiles.clear();
                    _loadTrashFiles(); // Recarrega a lista de arquivos da lixeira
                  });
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
                  Navigator.of(context).pop(); // Fecha o popup
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
      print('Trash targetPath $targetPath');
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
      const directory = 'C:';
      return '$directory\\AppTrash';

    } else if (Platform.isMacOS || Platform.isLinux) {
      // Diretório padrão para macOS e Linux
      final directory = Directory.systemTemp;
      return '${directory.path}/AppTrash';

    } else {
      throw UnsupportedError('Plataforma não suportada');
    }

  }

  Future<void> _loadTrashFiles() async {
    await carregarArquivosDaLixeira();
    setState(() {}); // Atualiza a interface com os arquivos carregados
  }

  Future<bool> _onWillPop(BuildContext context) async {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const RemoteAccessScreen()),
    );
    return false; // Retorne false para evitar que a tela atual seja removida da pilha
  }

  @override
  Widget build(BuildContext context) {
    final storageProvider = Provider.of<StorageProvider>(context);
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () => _onWillPop(context), // Vincula o método _onWillPop
      child: Scaffold(
        backgroundColor: Pallete.backgroundColor,
        body: SafeArea(
          child: Center(
            child: Column(
              children: [
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
                              print('Botão search pressionado');
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),

                // SizedBox(height: getHeight(context, 0.02)),

                buildNavigationBar(context, ''),

                buildActionBar(
                  context,
                  isSelectAllPressed,
                  toggleSelectAll,
                  activatedByCopy,
                  activatedByMove,
                  appTrashFilesList,
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
                    deleteFilesFromTrash,
                    isTrashScreen: true,
                  ),
                ),

                if (appTrashFilesList.isEmpty)
                  Container(
                    width: MediaQuery.of(context).size.width * 0.9, // 90% da largura da tela
                    height: MediaQuery.of(context).size.height * 0.6, // 6% da altura da tela
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Pallete.borderColor, // Cor da borda
                        width: 1.0, // Largura da borda
                      ),
                      borderRadius: BorderRadius.circular(10), // Cantos arredondados (opcional)
                    ),
                    child: Image.asset(
                      'assets/images/trash_giant_blue.png',
                      errorBuilder: (context, error, stackTrace) {
                        return Text(
                          'Error loading image: $error',
                          style: const TextStyle(color: Pallete.checkBoxTextColor),
                        );
                      },
                    ),
                  )

                // SizedBox(height: getHeight(context, 0.02)),

                else
                  Expanded(
                    child: buildFileList(
                      context, 
                      appTrashFilesList, 
                      syncState, 
                      encryptState, 
                      selectedFiles, 
                      isButton1Pressed, 
                      isButton2Pressed, 
                      toggleFileSelection,
                      synchronizedFolders,
                    ),
                  ),

              ],
            ),
          ),
        ),
        bottomNavigationBar: buildBottomNavigationBar(
          context,
          '',
          'trash',
          () => navigateToScreen(const CrawlerInternalStorageScreen(), context),
          null,
        ),
      ),
    );
  }
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
