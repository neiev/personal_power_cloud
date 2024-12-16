import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:personal_power_cloud/widgets/action_bar.dart';
import 'package:personal_power_cloud/utils/action_bar_functions.dart';
import 'package:personal_power_cloud/widgets/action_buttons.dart';
import 'package:personal_power_cloud/theme/pallete.dart';
import 'package:personal_power_cloud/utils/screen_utils.dart';
import 'package:personal_power_cloud/widgets/navigation_buttons.dart';
import 'package:personal_power_cloud/screens/crawler_internal_storage_screen.dart';
import 'package:personal_power_cloud/screens/storage_legacy_screen.dart';
import 'package:personal_power_cloud/services/google_drive_integration.dart';

class StorageScreen extends StatefulWidget {
  const StorageScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _StorageScreenState createState() => _StorageScreenState();
}

class _StorageScreenState extends State<StorageScreen> {

  Future<bool> _onWillPop(BuildContext context) async {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const CrawlerInternalStorageScreen()),
    );
    return false; // Retorna false para evitar que a tela atual seja removida da pilha
  }

  @override
  Widget build(BuildContext context) {
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

    void _saveStates() {
      _actionBarFunctions.saveStates(selectedFiles.whereType<File>().toList());
    }

    void _deleteFiles() {
      _actionBarFunctions.deleteFiles(selectedFiles.whereType<File>().toList(), setState);
    }

    bool isFolderMarked(String path, Map<String, bool> state) {
      return state[path] ?? false;
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

    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () => _onWillPop(context),
      child: Scaffold(
        backgroundColor: Pallete.backgroundColor,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Center(
              child: Column(
                children: [

                  // SizedBox(height: getHeight(context, 0.046)),

                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.9,
                    height: MediaQuery.of(context).size.height * 0.06,
                    child: Container(
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
                            icon: Image.asset('assets/images/search_blue.png',
                              width: 36,
                              height: 36,
                            ),
                            onPressed: () {
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

                  Column(
                    children: [

                      CustomButton(
                        text: 'PPC',
                        subText: '12/16 GB',
                        iconImage: const AssetImage('assets/images/select_blue.png'), // Altere para a imagem
                        iconImage1: const AssetImage('assets/images/ppc_blue.png'), // Altere para a imagem
                        iconImage2: const AssetImage('assets/images/standby_no_name_blue.png'), // Altere para a imagem
                        iconImage3: const AssetImage('assets/images/stitching_no_name_blue.png'), // Altere para a imagem
                        onPressed: () {
                          if (kDebugMode) {
                            print('Botão para a tela de login do PPC pressionado');
                          }
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const StorageLegacyScreen(), // Substitua 'NovaTela' pela sua tela de destino
                            ),
                          );
                        },
                      ),

                      // SizedBox(height: getHeight(context, 0.02)),

                      CustomButton(
                        text: 'Google Drive',
                        subText: '12/16 GB',
                        iconImage: const AssetImage('assets/images/select_blue.png'), // Altere para a imagem desejada
                        iconImage1: const AssetImage('assets/images/google_drive_blue.png'), // Altere para a imagem
                        iconImage2: const AssetImage('assets/images/standby_no_name_blue.png'), // Altere para a imagem
                        iconImage3: const AssetImage('assets/images/stitching_no_name_blue.png'), // Altere para a imagem
                        onPressed: () async {
                          // Lógica para navegar para a tela de login do Google Drive
                          if (kDebugMode) {
                            print('Botão para a tela de login do Google Drive pressionado');
                          }
                          final googleDriveIntegration = GoogleDriveIntegration();
                          await googleDriveIntegration.loginToGoogleDrive(context);
                        },
                      ),

                      // SizedBox(height: getHeight(context, 0.02)),

                      CustomButton(
                        text: 'Dropbox',
                        subText: '12/16 GB',
                        iconImage: const AssetImage('assets/images/select_blue.png'), // Altere para a imagem
                        iconImage1: const AssetImage('assets/images/dropbox_blue.png'), // Altere para a imagem
                        iconImage2: const AssetImage('assets/images/standby_no_name_blue.png'), // Altere para a imagem
                        iconImage3: const AssetImage('assets/images/stitching_no_name_blue.png'), // Altere para a imagem
                        onPressed: () {
                          // Lógica de compartilhamento
                          if (kDebugMode) {
                            print('Botão para a tela de login do Dropbox pressionado');
                          }
                        },
                      ),

                      // SizedBox(height: getHeight(context, 0.02)),

                      CustomButton(
                        text: 'OneDrive',
                        subText: '12/16 GB',
                        iconImage: const AssetImage('assets/images/select_blue.png'), // Altere para a imagem
                        iconImage1: const AssetImage('assets/images/onedrive_blue.png'), // Altere para a imagem
                        iconImage2: const AssetImage('assets/images/standby_no_name_blue.png'), // Altere para a imagem
                        iconImage3: const AssetImage('assets/images/stitching_no_name_blue.png'), // Altere para a imagem
                        onPressed: () {
                          // Lógica de exclusão
                          if (kDebugMode) {
                            print('Botão para a tela de login do OneDrive pressionado');
                          }
                        },
                      ),

                      // SizedBox(height: getHeight(context, 0.02)),

                      CustomButton(
                        text: 'FTP',
                        subText: '12/16 GB',
                        iconImage: const AssetImage('assets/images/select_blue.png'), // Altere para a imagem
                        iconImage1: const AssetImage('assets/images/ftp_blue.png'), // Altere para a imagem
                        iconImage2: const AssetImage('assets/images/standby_no_name_blue.png'), // Altere para a imagem
                        iconImage3: const AssetImage('assets/images/stitching_no_name_blue.png'), // Altere para a imagem
                        onPressed: () {
                          // Lógica para mover
                          if (kDebugMode) {
                            print('Botão para a tela de login do FTP pressionado');
                          }
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const StorageLegacyScreen(), // Substitua 'NovaTela' pela sua tela de destino
                            ),
                          );
                        },
                      ),

                      // SizedBox(height: getHeight(context, 0.02)),

                      CustomButton(
                        text: 'SFTP',
                        subText: '12/16 GB',
                        iconImage: const AssetImage('assets/images/select_blue.png'), // Altere para a imagem
                        iconImage1: const AssetImage('assets/images/sftp_blue.png'), // Altere para a imagem
                        iconImage2: const AssetImage('assets/images/standby_no_name_blue.png'), // Altere para a imagem
                        iconImage3: const AssetImage('assets/images/stitching_no_name_blue.png'), // Altere para a imagem
                        onPressed: () {
                          // Lógica para copiar
                          if (kDebugMode) {
                            print('Botão para a tela de login do SFTP pressionado');
                          }
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const StorageLegacyScreen(), // Substitua 'NovaTela' pela sua tela de destino
                            ),
                          );
                        },
                      ),

                      // SizedBox(height: getHeight(context, 0.02)),

                      CustomButton(
                        text: 'RSYNC',
                        subText: '12/16 GB',
                        iconImage: const AssetImage('assets/images/select_blue.png'), // Altere para a imagem
                        iconImage1: const AssetImage('assets/images/rsync_blue.png'), // Altere para a imagem
                        iconImage2: const AssetImage('assets/images/standby_no_name_blue.png'), // Altere para a imagem
                        iconImage3: const AssetImage('assets/images/stitching_no_name_blue.png'), // Altere para a imagem
                        onPressed: () {
                          // Lógica para renomear
                          if (kDebugMode) {
                            print('Botão para a tela de login do RSYNC pressionado');
                          }
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const StorageLegacyScreen(), // Substitua 'NovaTela' pela sua tela de destino
                            ),
                          );
                        },
                      ),

                      // SizedBox(height: getHeight(context, 0.02)),

                      CustomButton(
                        text: 'HTTP',
                        subText: '12/16 GB',
                        iconImage: const AssetImage('assets/images/select_blue.png'), // Altere para a imagem
                        iconImage1: const AssetImage('assets/images/http_blue.png'), // Altere para a imagem
                        iconImage2: const AssetImage('assets/images/standby_no_name_blue.png'), // Altere para a imagem
                        iconImage3: const AssetImage('assets/images/stitching_no_name_blue.png'), // Altere para a imagem
                        onPressed: () {
                          // Lógica para ver propriedades
                          if (kDebugMode) {
                            print('Botão para a tela de login do HTTP pressionado');
                          }
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const StorageLegacyScreen(), // Substitua 'NovaTela' pela sua tela de destino
                            ),
                          );
                        },
                      ),

                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: buildBottomNavigationBar(
          context,
          '',
          'storage',
          () => navigateToScreen(const CrawlerInternalStorageScreen(), context),
          null,
        ),
      ),
    );
  }

}

class CustomButton extends StatefulWidget {
  final String text;
  final String? subText;
  final ImageProvider? iconImage;
  final ImageProvider? iconImage1;
  final ImageProvider? iconImage2;
  final ImageProvider? iconImage3;
  final VoidCallback onPressed;

  const CustomButton({
    super.key,
    required this.text,
    this.subText,
    this.iconImage,
    this.iconImage1,
    this.iconImage2,
    this.iconImage3,
    required this.onPressed,
  });

  @override
  // ignore: library_private_types_in_public_api
  _CustomButtonState createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onPressed,
        child: Container(
          width: MediaQuery.of(context).size.width * 0.9, 
          height: MediaQuery.of(context).size.height * 0.06,  
          decoration: BoxDecoration(
            color: _isHovered ? Pallete.boxColor1 : Pallete.boxColor, // Altere a cor do botão
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: Pallete.borderColor,
              width: 1
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              if (widget.iconImage != null)
                Container(
                  decoration: BoxDecoration(
                    color: _isHovered ? Pallete.boxColor1 : Pallete.boxColor, // Altere a cor do botão
                    border: Border.all(color: Pallete.borderColor, width: 1),
                  ),
                  child: Image(
                    image: widget.iconImage!,
                    width: 36,
                    height: 36,
                  ),
                ),
              if (widget.iconImage1 != null)
                Container(
                  decoration: BoxDecoration(
                    color: _isHovered ? Pallete.boxColor1 : Pallete.boxColor, // Altere a cor do botão
                    border: Border.all(color: Pallete.borderColor, width: 1),
                  ),
                  child: Image(
                    image: widget.iconImage1!,
                    width: 36,
                    height: 36,
                  ),
                ),
              Container(
                width: MediaQuery.of(context).size.width * 0.4,
                height: MediaQuery.of(context).size.height * 0.06,
                decoration: BoxDecoration(
                  color: _isHovered ? Pallete.boxColor1 : Pallete.boxColor, // Altere a cor do botão
                  border: Border.all(color: Pallete.borderColor, width: 1),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.text,
                      style: const TextStyle(
                        color: Pallete.checkBoxTextColor,
                        fontSize: 12,
                      ),
                    ),
                    if (widget.subText != null)
                      Text(
                        widget.subText!,
                        style: const TextStyle(
                          color: Pallete.checkBoxTextColor1,
                          fontSize: 8,
                        ),
                      ),
                    Image.asset(
                      'assets/images/orange_and_white_bar.png',
                      width: MediaQuery.of(context).size.width * 0.9,
                    ),
                  ],
                ),
              ),
              if (widget.iconImage2 != null)
                Container(
                  decoration: BoxDecoration(
                    color: _isHovered ? Pallete.boxColor1 : Pallete.boxColor, // Altere a cor do botão
                    border: Border.all(color: Pallete.borderColor, width: 1),
                  ),
                  child: Image(
                    image: widget.iconImage2!,
                    width: 36,
                    height: 36,
                  ),
                ),
              if (widget.iconImage3 != null)
                Container(
                  decoration: BoxDecoration(
                    color: _isHovered ? Pallete.boxColor1 : Pallete.boxColor, // Altere a cor do botão
                    border: Border.all(color: Pallete.borderColor, width: 1),
                  ),
                  child: Image(
                    image: widget.iconImage3!,
                    width: 36,
                    height: 36,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

}
