import 'package:flutter/material.dart';

// Função para calcular uma fração específica da altura da tela
double getHeight(BuildContext context, double percentage) => MediaQuery.of(context).size.height * percentage;

// Função para calcular uma fração específica da largura da tela
double getWidth(BuildContext context, double percentage) => MediaQuery.of(context).size.width * percentage;