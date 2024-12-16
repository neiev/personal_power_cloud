// Função que retorna uma decoração para um widget BoxDecoration
import 'package:flutter/material.dart';
import 'package:personal_power_cloud/theme/pallete.dart';

BoxDecoration boxDecoration() {
  return BoxDecoration(
    // Define a cor de fundo da decoração, obtida de Pallete.boxColor
    color: Pallete.boxColor,
    // Define o raio das bordas arredondadas do container
    borderRadius: BorderRadius.circular(10),
    // Define a borda do container
    border: Border.all(
      color: Pallete.borderColor,
      width: 1,
    ),
  );
}