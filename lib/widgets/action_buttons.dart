import 'dart:io';
import 'package:flutter/material.dart';
import 'package:personal_power_cloud/widgets/icon_button.dart';
import 'package:personal_power_cloud/widgets/custom_popup.dart';
import 'package:personal_power_cloud/theme/pallete.dart';

List<Widget> buildActionButtons(
  BuildContext context,
  bool isBottomActionBarVisible,
  bool activatedByCopy,
  bool activatedByMove,
  List<dynamic> selectedFiles,
  bool isButtonSyncPressed,
  bool isButtonEncryptPressed,
  dynamic Function() toggleActionBarVisibility,
  void Function() toggleActivatedByCopy,
  void Function() toggleActivatedByMove,
  void Function(dynamic file, bool shouldUpdate) toggleSyncState,
  void Function(dynamic file, bool shouldUpdate) toggleEncryptState,
  void Function() saveStates,
  void Function() deleteFiles,
  {
    bool isTrashScreen = false,
  }
) {
  return [
    if (!isTrashScreen)
      buildIconButton(
        'assets/images/copy_white.png', 
        () {
          if (!isBottomActionBarVisible) {
            toggleActivatedByCopy();
            toggleActionBarVisibility();
          } else {
            toggleBottomActionBarVisibility(
              'copy',
              isBottomActionBarVisible,
              activatedByCopy,
              activatedByMove,
              toggleActivatedByCopy,
              toggleActivatedByMove,
              toggleActionBarVisibility,
            );
          }
          // Alterna a visibilidade da barra de ações inferior
          // copyFiles(); // Função para copiar arquivos
        }, 
        (selectedFiles.isNotEmpty && !activatedByMove),
      ),
    buildIconButton(
      'assets/images/move_white.png', 
      () {
        if (!isBottomActionBarVisible) {
          toggleActivatedByMove();
          toggleActionBarVisibility();
        } else {
          toggleBottomActionBarVisibility(
            'move',
            isBottomActionBarVisible,
            activatedByCopy,
            activatedByMove,
            toggleActivatedByCopy,
            toggleActivatedByMove,
            toggleActionBarVisibility,
          ); // altera a visibilidade da barra de alçao inferior para manipulação de arquivos
        }
        // Implementar lógica de movimentação
      }, 
      (selectedFiles.isNotEmpty && !activatedByCopy)
    ),
    if(!isTrashScreen)
      buildIconButton(
        'assets/images/synchronize_${isButtonSyncPressed ? 'blue' : 'white'}.png',
        () {
          if (selectedFiles.isNotEmpty) {
            for (var file in selectedFiles) {
              toggleSyncState(file, false); // Alterna o estado de sincronização para cada arquivo selecionado
              saveStates(); // Salva os estados após a sincronização
            }
          }
        }, 
        selectedFiles.isNotEmpty && !activatedByCopy && !activatedByMove, 
        isButtonSyncPressed
      ),
    if(!isTrashScreen)
      buildIconButton(
        'assets/images/encrypt_${isButtonEncryptPressed ? 'blue' : 'white'}.png',
        () {
          if (selectedFiles.isNotEmpty) {
            for (var file in selectedFiles) {
              toggleEncryptState(file, false); // Alterna o estado de criptografia para cada arquivo selecionado
              saveStates(); // Salva os estados após a sincronização
            }
          }
        }, 
        selectedFiles.isNotEmpty && !activatedByCopy && !activatedByMove, 
        isButtonEncryptPressed,
        isTrashScreen
      ),
    buildIconButton(
      'assets/images/delete_white.png', 
      () { 
        deleteFiles(); // Exclui os arquivos selecionados
        // showCustomPopup(); // Exibe um popup personalizado para confirmar a exclusão de arquivos
        
      }, // Função para excluir arquivos
      selectedFiles.isNotEmpty && !activatedByCopy && !activatedByMove
    ),
  ];
}

void toggleBottomActionBarVisibility(
  String action,
  bool isBottomActionBarVisible,
  bool activatedByCopy,
  bool activatedByMove,
  void Function() toggleActivatedByCopy,
  void Function() toggleActivatedByMove,
  void Function() toggleActionBarVisibility,
) {
  // Atualiza o estado do widget para refletir as mudanças na visibilidade da barra de ações inferior.
  if (isBottomActionBarVisible && action == 'copy' && activatedByCopy) {
    toggleActivatedByCopy();
    toggleActionBarVisibility();
  } else if (action == 'move' && isBottomActionBarVisible && activatedByMove) {
    toggleActivatedByMove();
    toggleActionBarVisibility();
  }
}

void showCustomPopup({
    required BuildContext context,
    required String title,
    required String message,
    required List<Widget> actions,
    double? width,
    // double? height,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false, // Impede o fechamento ao clicar fora
      builder: (context) => CustomPopup(
        title: title,
        message: message,
        actions: actions,
        width: width,
        // height: height,
      ),
    );
  }