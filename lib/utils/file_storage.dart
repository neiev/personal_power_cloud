import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:personal_power_cloud/screens/trash_screen.dart';
// ignore: depend_on_referenced_packages, library_prefixes
import 'package:path/path.dart' as pathLib;

// Define a lista de arquivos na lixeira
List<dynamic> appTrashFilesList = [];
List<dynamic> fileList = [];

Future<void> carregarArquivosDaLixeira() async {
  final trashFolderPath = await getTrashFolderPath();

  if (kDebugMode) {
    print('Caminho da lixeira: $trashFolderPath');
  }

  if (trashFolderPath != null) {
    final directory = Directory(trashFolderPath);

    if (directory.existsSync()) {
      final List<dynamic> files = await directory.list().toList();
      appTrashFilesList = files;

      if (kDebugMode) {
        print('Arquivos carregados da lixeira: $appTrashFilesList');
      }
    }
  }
}

Future<String?> getTrashFolderPath() async {
  Directory? directory;

  if (Platform.isWindows) {
    directory = Directory('C:\\AppTrash');
    if (!directory.existsSync()) {
      directory.createSync(recursive: true);
    }

  } else if (Platform.isMacOS) {
    // On macOS, the trash folder is located at ~/.Trash
    directory = Directory('${Platform.environment['HOME']}/.Trash');
  
  } else if (Platform.isLinux) {
    // On Linux, the trash folder is located at ~/.local/share/Trash
    directory = Directory('${Platform.environment['HOME']}/.local/share/Trash');
  
  } else if (Platform.isAndroid) {
    // On Android, use the external storage directory for the trash folder
    directory = Directory('/storage/emulated/0/AppTrash');
  
    if (!directory.existsSync()) {
      directory.createSync(recursive: true);
    }
  
  } else if (Platform.isIOS) {
    // On iOS, create a custom trash folder in the app's documents directory
    directory = await getApplicationDocumentsDirectory();
    directory = Directory(pathLib.join(directory.path, 'Trash'));
  
    if (!directory.existsSync()) {
      directory.createSync();
    }
  }

  if (directory != null && directory.existsSync()) {
    return directory.path;

  } else {
    return null;

  }

}