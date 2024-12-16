import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:personal_power_cloud/widgets/action_bar.dart';
import 'package:personal_power_cloud/utils/action_bar_functions.dart';
import 'package:personal_power_cloud/widgets/action_buttons.dart';
import 'package:personal_power_cloud/theme/pallete.dart';
import 'package:personal_power_cloud/utils/screen_utils.dart';
import 'package:personal_power_cloud/widgets/navigation_buttons_more.dart';
import 'crawler_internal_storage_screen.dart';

class CrawlerMoreScreen extends StatefulWidget {
  const CrawlerMoreScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CrawlerMoreScreenState createState() => _CrawlerMoreScreenState();
}

class _CrawlerMoreScreenState extends State<CrawlerMoreScreen> {
  bool activatedByMove = false;
  bool isSelectAllPressed = false;
  bool activatedByCopy = false;
  List<String> fileList = [];
  bool isBottomActionBarVisible = false;
  bool isButtonEncryptPressed = false;
  bool isButtonSyncPressed = false;
  final ActionBarFunctions _actionBarFunctions = ActionBarFunctions();
  Set<FileSystemEntity> selectedFiles = {};
  Map<String, bool> syncState = {};
  Map<String, bool> encryptState = {}; // Estado de criptografia de arquivos

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

  void _saveStates() {
    _actionBarFunctions.saveStates(selectedFiles.whereType<File>().toList());
  }

  void _deleteFiles() {
    _actionBarFunctions.deleteFiles(selectedFiles.whereType<File>().toList(), setState);
  }

  // Alterna o estado de sincronização de um arquivo
  void toggleSyncState(dynamic file, bool shouldUpdate) {
    // Atualiza o estado do widget para refletir as mudanças no estado de sincronização.
    setState(() {
      // Alterna o estado de sincronização do arquivo fornecido.
      syncState[file.path] = !isFolderMarked(file.path, syncState);

      // Se a flag shouldUpdate for verdadeira, atualiza o estado de sincronização de todos os arquivos selecionados.
      if (shouldUpdate) {
        for (var selectedFile in selectedFiles) {
          // Define o estado de sincronização de cada arquivo selecionado para o mesmo valor do arquivo fornecido.
          syncState[selectedFile.path] = syncState[file.path] ?? false;
        }
      }
    });
  }

  // Verifica se uma pasta está marcada
  bool isFolderMarked(String path, Map<String, bool> state) {
    return state[path] ?? false;
  }

  // Alterna o estado de criptografia de um arquivo
  void toggleEncryptState(dynamic file, bool shouldUpdate) {
    // Atualiza o estado do widget para refletir as mudanças no estado de criptografia.
    setState(() {
      // Alterna o estado de criptografia do arquivo fornecido.
      encryptState[file.path] = !isFolderMarked(file.path, encryptState);

      // Se a flag shouldUpdate for verdadeira, atualiza o estado de criptografia de todos os arquivos selecionados.
      if (shouldUpdate) {
        for (var selectedFile in selectedFiles) {
          // Define o estado de criptografia de cada arquivo selecionado para o mesmo valor do arquivo fornecido.
          encryptState[selectedFile.path] = encryptState[file.path] ?? false;
        }
      }

      // Se o modo de depuração estiver ativado, imprime o estado de criptografia do arquivo.
      if (kDebugMode) {
        print('Encrypt state for ${file.path}: ${encryptState[file.path]}');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Pallete.backgroundColor,
      body: SafeArea(  // Adicionando o SafeArea ao redor do conteúdo
        child: SingleChildScrollView(
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

                buildNavigationBarMore(context, 'more'),

                // SizedBox(height: getHeight(context, 0.02)),

                buildActionBar(
                  context, 
                  isSelectAllPressed, 
                  () {}, 
                  activatedByCopy, 
                  activatedByMove,
                  fileList.cast<FileSystemEntity>(),
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
                    _saveStates,
                    _deleteFiles
                  ),
                ),

                // SizedBox(height: getHeight(context, 0.02)),

                Container(
                  width: MediaQuery.of(context).size.width * 0.9, // 90% da largura da tela
                  height: MediaQuery.of(context).size.height * 0.06, // 6% da altura da tela
                  decoration: BoxDecoration(
                    color: const Color(0xFF0061A8),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFF00FF57), width: 1),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        icon: Image.asset('assets/images/select_blue.png'),
                        iconSize: 36,
                        onPressed: () {
                          // Implemente a lógica do botão 1 aqui
                          if (kDebugMode) {
                            print('Button 1 pressed');
                          }
                        },
                      ),
                      IconButton(
                        icon: Image.asset('assets/images/folder_blue.png'),
                        iconSize: 36,
                        onPressed: () {
                        },
                      ),
                      SizedBox(
                        width: 130,
                        height: 50,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 130,
                              height: 24,
                              alignment: Alignment.center,
                              child: const Text(
                                'Internal Storage',
                                style: TextStyle(
                                  color: Color(0xFFFFFFFF),
                                  fontSize: 15,
                                ),
                              ),
                            ),
                            Container(
                              width: 130,
                              height: 24,
                              alignment: Alignment.center,
                              child: const Text(
                                '2 Items - 20/03/2024',
                                style: TextStyle(
                                  color: Color(0xFF959595),
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: Image.asset('assets/images/synchronize_no_name_blue.png'),
                        iconSize: 36,
                        onPressed: () {
                        },
                      ),
                      IconButton(
                        icon: Image.asset('assets/images/encrypt_no_name_blue.png'),
                        iconSize: 36,
                        onPressed: () {
                        },
                      ),
                    ],
                  ),
                ),

              ],
            ),
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
    );
  }

}