import 'dart:io';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages, library_prefixes
import 'package:path/path.dart' as pathLib;
import 'package:personal_power_cloud/widgets/file_item.dart';

Widget buildFileList(
  BuildContext context, 
  List<dynamic> fileList, 
  Map<String, bool> syncState, 
  Map<String, bool> encryptState,
  Set<dynamic> selectedFiles, 
  bool isButton1Pressed,
  bool isButton2Pressed,
  void Function(FileSystemEntity file) toggleFileSelection,
  List<dynamic> synchronizedFolders,
) {

  // Filtra a lista de arquivos de acordo com a consulta de pesquisa (se houver)
  List<dynamic> getFilteredFileList() {
    // Implementação da função de filtragem
    return fileList; // Retorne a lista filtrada
  }

  getFilteredFileList();

  /// Verifica se uma pasta está sincronizada, subindo na hierarquia
  bool isFolderMarked(String folderPath, Map<String, bool> stateMap) {
    String currentPath = folderPath;

    // Subir na hierarquia para verificar se algum ancestral está sincronizado
    while (currentPath.isNotEmpty) {

      if (stateMap[currentPath] == true) {
        // A pasta ou um de seus pais está sincronizado
        return true;
      }

      // Sobe um nível na hierarquia
      currentPath = pathLib.dirname(currentPath);

      // Calcula o próximo caminho na hierarquia (diretório pai)
      String parentPath = pathLib.dirname(currentPath);

      // Se o caminho não mudou, significa que chegamos ao diretório raiz
      if (parentPath == currentPath) {
        // Encerra o loop ao chegar na raiz
        break;
      }

    }
    // Nenhuma pasta ancestral está sincronizada
    return false;
  
  }

  return SizedBox(
    width: MediaQuery.of(context).size.width * 0.9, // 90% da largura da tela
    // height: MediaQuery.of(context).size.height * 0.06, // 6% da altura da tela
    child: ListView.builder(

      // Define o número de itens na lista de acordo com o comprimento de fileList
      itemCount: fileList.length,

      // Define o construtor de itens da lista
      itemBuilder: (context, index) {

        // Obtém o arquivo correspondente ao índice atual
        final file = fileList[index];

        // Obtém o nome base do caminho do arquivo
        final baseName = pathLib.basename(file.path);

        // Verifica se o arquivo está selecionado
        final isSelected = selectedFiles.contains(file);

        // Obtém o estado de sincronização do arquivo, com valor padrão false se não estiver definido
        final isSynced = (syncState[file.path] ?? false) || (syncState[baseName] ?? false) || isFolderMarked(pathLib.dirname(file.path), syncState);

        // Obtém o estado de criptografia do arquivo, com valor padrão false se não estiver definido
        final isEncrypted = (encryptState[file.path] ?? false) || (encryptState[baseName] ?? false) || isFolderMarked(pathLib.dirname(file.path), encryptState);

        return FileItemWidget(
          // Passa o arquivo para o widget FileItemWidget
          file: file,
          // Passa o estado de seleção
          isSelected: isSelected,
          // Define a ação de toque para alternar a seleção do arquivo
          onTap: () => toggleFileSelection(file),
          // Passa o estado do botão 1
          isButton1Pressed: isButton1Pressed,
          // Passa o estado do botão 2
          isButton2Pressed: isButton2Pressed,
          // Passa o estado de sincronização
          syncState: syncState,
          // Passa o estado de criptografia
          encryptState: encryptState,
          // Passa a lista de pastas sincronizadas
          synchronizedFolders: synchronizedFolders,
          // Passa o estado de sincronização para o FileItemWidget
          isSynced: isSynced,
          // Passa o estado de criptografia para o FileItemWidget
          isEncrypted: isEncrypted,
        );

      },

    ),

  );

}
