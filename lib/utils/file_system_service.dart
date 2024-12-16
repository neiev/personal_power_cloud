import 'dart:io';
import 'package:flutter/foundation.dart';

class FileSystemService {
  // Método para obter a lista de arquivos e pastas em um diretório
  static Future<List<FileSystemEntity>> getFiles(String path) async {
    final directory = Directory(path);
    List<FileSystemEntity> files = [];

    try {
      if (await directory.exists()) {
        files = directory.listSync();
      } else {
        if (kDebugMode) {
          print('Directory does not exist: $path');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error accessing directory: $e');
      }
    }

    return files;
  }

  // Método para obter a lista de arquivos e pastas em um diretório inicial
  static Future<List<FileSystemEntity>> getInitialFiles() async {
    final directory = Directory.current; // Obtém o diretório atual
    return getFiles(directory.path);
  }

  static Future<List<FileSystemEntity>> getFilesFromDirectory(Directory directory) async {
    // Implemente a lógica para obter arquivos e diretórios
    return directory.list().toList();
  }
}