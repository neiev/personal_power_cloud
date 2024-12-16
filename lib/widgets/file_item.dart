import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:personal_power_cloud/screens/crawler_internal_storage_screen.dart';
import 'package:personal_power_cloud/theme/pallete.dart';
// ignore: depend_on_referenced_packages, library_prefixes
import 'package:path/path.dart' as pathLib;

class FileItemWidget extends StatelessWidget {
  final dynamic file;
  final bool isSelected;
  final VoidCallback onTap;
  final bool isButton1Pressed;
  final bool isButton2Pressed;
  final Map<String, bool> syncState;
  final Map<String, bool> encryptState;
  final List<dynamic> synchronizedFolders;
  final bool isSynced;
  final bool isEncrypted;

  const FileItemWidget({
    super.key,
    required this.file,
    required this.isSelected,
    required this.onTap,
    required this.isButton1Pressed,
    required this.isButton2Pressed,
    required this.syncState,
    required this.encryptState,
    required this.synchronizedFolders,
    required this.isSynced,
    required this.isEncrypted,
  });

  @override
  Widget build(BuildContext context) {
    String fileName;
    double iconSize = MediaQuery.of(context).size.height * 0.06;
    bool isDirectory;
    String filePath = '';

    if (file is drive.File) {
      fileName = (file as drive.File).name ?? '';
      filePath = (file as drive.File).id ?? '';
      isDirectory = file.mimeType == 'application/vnd.google-apps.folder';
    } else if (file is FileSystemEntity) {
      filePath = (file as FileSystemEntity).path;
      fileName = pathLib.basename(filePath);
      isDirectory = file is Directory;
    } else {
      fileName = 'Unknown';
      isDirectory = false;
    }

    final selectionImage = isSelected
      ? 'assets/images/select_blue1.png'
      : 'assets/images/select_blue.png';

    final synchronizeImage = isSynced
      ? 'assets/images/synchronize_no_name_blue.png'
      : 'assets/images/synchronize_no_name_blue1.png';

    final encryptImage = isEncrypted
      ? 'assets/images/encrypt_no_name_blue.png'
      : 'assets/images/encrypt_no_name_blue1.png';

    if (kDebugMode) {
      print('file_item_widget file.path $filePath');
    }

    return GestureDetector(
      onDoubleTap: () {
        if (isDirectory) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CrawlerInternalStorageScreen(
                initialPath: filePath,
                rootPath: Platform.isAndroid ? '/storage/emulated/0/' : filePath.split('\\').first,
              ),
            ),
          ).then((_) {
          });
        }
      },
      child: Padding(
        padding: EdgeInsets.zero,
        child: Container(
          decoration: BoxDecoration(
            color: isSelected ? Colors.transparent : Pallete.selectedColor,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Pallete.borderColor, width: 1),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Espaçamento igual entre os elementos
            crossAxisAlignment: CrossAxisAlignment.center, // Centralização vertical
            children: [

              Flexible(
                flex: 1, // Controla a proporção dentro do Row
                child: InkWell(
                  onTap: onTap,
                  child: _buildIcon(
                    selectionImage,
                    iconSize,
                  ),
                ),
              ),

              Flexible(
                flex: 1, // Controla a proporção dentro do Row
                child: _buildIcon(
                  isDirectory
                      ? 'assets/images/folder_blue.png'
                      : 'assets/images/file_blue.png',
                  iconSize,
                ),
              ),

              Flexible(
                flex: 3, // Espaço proporcional maior para textos
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _buildTextContainer(
                      fileName,
                      Pallete.bottomTextColor,
                    ),
                    _buildTextContainer(
                      filePath,
                      Pallete.checkBoxTextColor1,
                    ),
                  ],
                ),
              ),

              Flexible(
                flex: 1, // Controla a proporção dentro do Row
                child: _buildIcon(
                  (isSelected || isSynced || isEncrypted)
                      ? synchronizeImage
                      : 'assets/images/synchronize_no_name_blue1.png', // Imagem padrão quando não estiver selecionado
                  iconSize,
                ),
              ),

              Flexible(
                flex: 1, // Controla a proporção dentro do Row
                child: _buildIcon(
                  (isSelected || isSynced || isEncrypted)
                      ? encryptImage
                      : 'assets/images/encrypt_no_name_blue1.png', // Imagem padrão quando não estiver selecionado
                  iconSize,
                  true,
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIcon(String iconPath, double size, [bool isLastElement = false]) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Pallete.borderColor,
          width: 1,
        ),
      ),
      child: Image.asset(
        iconPath,
        width: 36,  // Ajustando o tamanho do ícone
        height: 36, // Garantindo a consistência no tamanho
      ),
    );
  }

  Widget _buildTextContainer(String text, Color color) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return Container(
          width: MediaQuery.of(context).size.width * 0.4,
          // height: MediaQuery.of(context).size.height * 0.06,
          height: MediaQuery.of(context).size.height * 0.0285,
          alignment: Alignment.center, // Centraliza o conteúdo vertical e horizontalmente
          decoration: BoxDecoration(
            border: Border.all(
              color: Pallete.borderColor,
              width: 1,
            ),
          ),
          child: Center( // Garante que o texto seja centralizado
            child: Text(
              text,
              style: TextStyle(color: color),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
        );
      },
    );
  }

}
