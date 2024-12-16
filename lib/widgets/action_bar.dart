import 'package:flutter/material.dart';
import 'package:personal_power_cloud/widgets/icon_button.dart';
import 'package:personal_power_cloud/theme/Pallete.dart';

Widget buildActionBar(
  BuildContext context,
  bool isSelectAllPressed,
  void Function() toggleSelectAll,
  bool activatedByCopy,
  bool activatedByMove,
  List<dynamic> fileList,
  List<Widget> buildActionButtons
) {
    final hasFiles = fileList.isNotEmpty; // Verifica se há arquivos na lista
    return Container(
      width: MediaQuery.of(context).size.width * 0.9, // 90% da largura da tela
      height: MediaQuery.of(context).size.height * 0.06, // 6% da altura da tela
      decoration: BoxDecoration(
        color: Pallete.boxColor,
        border: Border.all(
          color: Pallete.borderColor,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(10),
      ), // Aplica uma decoração ao container
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Distribui os botões igualmente ao longo da linha
        children: [
          buildIconButton(
            'assets/images/${isSelectAllPressed ? 'deselect_all_blue' : 'select_all_white'}.png',
            toggleSelectAll, // Função a ser executada ao pressionar o botão
            hasFiles &&
                !activatedByCopy &&
                !activatedByMove, // Condição para habilitar o botão (habilitado se houver arquivos na lista)
            isSelectAllPressed, // Verifica se o botão está pressionado
          ),
          ...buildActionButtons, // Insere os outros botões de ação na barra
        ],
      ),
    );
  }