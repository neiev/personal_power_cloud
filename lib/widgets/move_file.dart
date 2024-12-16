import 'dart:io';
// ignore: depend_on_referenced_packages, library_prefixes
import 'package:path/path.dart' as pathLib;
import 'package:flutter/foundation.dart';

Future<void> moveFile(FileSystemEntity file, String targetPath) async {
  final newPath = pathLib.join(targetPath, pathLib.basename(file.path));

  if (kDebugMode) {
    print('Movendo arquivo/diretório: ${file.path}');
    print('Destino: $newPath');
  }

  try {
    // Verifique se o destino já existe
    final destinationEntity = FileSystemEntity.typeSync(newPath);
    if (destinationEntity != FileSystemEntityType.notFound) {
      if (destinationEntity == FileSystemEntityType.file) {
        await File(newPath).delete();
      } else if (destinationEntity == FileSystemEntityType.directory) {
        await Directory(newPath).delete(recursive: true);
      }
    }

    if (file is File) {
      if (kDebugMode) {
        print('Tentando renomear arquivo: ${file.path}');
      }

      try {
        // Tente renomear o arquivo (move rápido no mesmo sistema de arquivos)
        await file.rename(newPath);
      } catch (e) {
        if (kDebugMode) {
          print('Falha ao renomear, tentando copiar: $e');
        }
        // Se renomear falhar, copie e exclua o original
        await file.copy(newPath);
        await file.delete();
      }

    } else if (file is Directory) {
      if (kDebugMode) {
        print('Criando diretório no destino: $newPath');
      }

      // Criar o diretório de destino
      await Directory(newPath).create(recursive: true);

      // Mover recursivamente o conteúdo do diretório
      for (var entity in file.listSync()) {
        await moveFile(entity, newPath);
      }

      if (kDebugMode) {
        print('Deletando diretório original: ${file.path}');
      }
      await file.delete(recursive: true);
    }
  } catch (e) {
    if (kDebugMode) {
      print('Erro ao mover arquivo/diretório: $e');
    }
    // Em casos de erro grave, repropague para depuração
    rethrow;
  }
}


