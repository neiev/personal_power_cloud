import 'package:flutter/material.dart';
import 'package:personal_power_cloud/theme/pallete.dart';

Widget buildIconButton(
  String iconPath, 
  VoidCallback onPressed, 
  bool canBePressed, 
  [
    bool isSelected = false, 
    isTransparent = false,
  ]
) {
    return LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
      // Obtém as dimensões da tela usando MediaQuery
      double screenWidth = MediaQuery.of(context).size.width;
      double screenHeight = MediaQuery.of(context).size.height;

      // Define as porcentagens desejadas para altura e largura
      double iconSizePercentage = 0.12; // Exemplo: 10% do tamanho da tela
      double iconHeight = screenHeight * iconSizePercentage;
      double iconWidth = screenWidth * iconSizePercentage;

      return Container(
        height: iconHeight, // Define a altura baseada na porcentagem da tela
        width: iconWidth,   // Define a largura baseada na porcentagem da tela

        // width: 36,
        // height: 36,

        decoration: BoxDecoration(color: isSelected ? Pallete.selectedColor : Colors.transparent, borderRadius: BorderRadius.circular(10),),
        child: IconButton(
          icon: Image.asset(
            iconPath, 
            color: isSelected ? Pallete.iconColor : isTransparent ? Colors.transparent : Colors.white, 
          ),
          onPressed: canBePressed ? onPressed : null, 
          iconSize: iconHeight,
        ),
      );
    },);


}