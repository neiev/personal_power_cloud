import 'package:flutter/material.dart';

class StorageProvider with ChangeNotifier {
  List<dynamic> _trashFilesList = []; // Lista de arquivos da lixeira

  List<dynamic> get trashFilesList => _trashFilesList; // Getter para a lista de arquivos da lixeira

  void addToTrash(dynamic file) {
    _trashFilesList.add(file);
    notifyListeners();
  }

  void removeFromTrash(dynamic file) {
    _trashFilesList.remove(file);
    notifyListeners();
  }

  void clearTrash() {
    _trashFilesList.clear();
    notifyListeners();
  }
}