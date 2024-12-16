import 'dart:io';

abstract class File extends FileSystemEntity {
  bool isSynchronized;
  bool isEncrypted;

  File({required this.isSynchronized, required this.isEncrypted});
}

class ActionBarFunctions {
  void toggleSyncState(List<dynamic> selectedFiles, bool isButtonSyncPressed, Function setState) {
    setState(() {
      for (var file in selectedFiles) {
        file.isSynchronized = !file.isSynchronized;
      }
      isButtonSyncPressed = !isButtonSyncPressed;
    });
  }

  void toggleEncryptState(List<dynamic> selectedFiles, bool isButtonEncryptPressed, Function setState) {
    setState(() {
      for (var file in selectedFiles) {
        file.isEncrypted = !file.isEncrypted;
      }
      isButtonEncryptPressed = !isButtonEncryptPressed;
    });
  }

  void saveStates(List<dynamic> selectedFiles) {
    // Implementação para salvar os estados dos arquivos
  }

  void deleteFiles(List<dynamic> selectedFiles, Function setState) {
    setState(() {
      selectedFiles.clear();
    });
  }
}