// Responsável por criar os botões de navegação para as telas de crawler.
import 'package:flutter/material.dart';
import 'package:personal_power_cloud/widgets/icon_button.dart'; // Importa o widget de botão de ícone
import 'package:personal_power_cloud/screens/crawler_dropbox_screen.dart'; // Tela para integração com Dropbox
import 'package:personal_power_cloud/screens/crawler_google_drive_screen.dart'; // Tela para integração com Google Drive
import 'package:personal_power_cloud/screens/crawler_more_screen.dart'; // Tela para outras opções de integração
import 'package:personal_power_cloud/screens/crawler_onedrive_screen.dart'; // Tela para integração com OneDrive
import 'package:personal_power_cloud/screens/crawler_ppc_screen.dart'; // Tela principal ou uma específica do projeto PPC
import 'package:personal_power_cloud/screens/crawler_sd_card_screen.dart'; // Tela para visualização e gerenciamento de SD Cards

void navigateToScreen(Widget screen, BuildContext context) {
  // Utiliza o Navigator para realizar a navegação para a tela especificada.
  Navigator.push(context, MaterialPageRoute(builder: (context) => screen, ),);
}

List<Widget> buildNavigationButtons(BuildContext context, String currentScreen) {
  return [
    buildIconButton(
      'assets/images/sd_card_white.png', // Caminho do ícone do cartão SD
      () => navigateToScreen(const CrawlerSdCardScreen(), context), // Navega para a tela do cartão SD
      true,
      currentScreen == 'sd_card'
    ), 
    buildIconButton(
      'assets/images/ppc_white.png', // Caminho do ícone do PPC
      () => navigateToScreen(const CrawlerPpcScreen(), context), // Navega para a tela PPC
      true,
      currentScreen == 'ppc'
    ), 
    buildIconButton(
      'assets/images/google_drive_white.png', // Caminho do ícone do Google Drive
      () => navigateToScreen(const CrawlerGoogleDriveScreen(), context), // Navega para a tela do Google Drive
      true, 
      currentScreen == 'google_drive'
    ), 
    buildIconButton(
      'assets/images/dropbox_white.png', // Caminho do ícone do Dropbox
      () => navigateToScreen(const CrawlerDropboxScreen(), context), // Navega para a tela do Dropbox
      true,
      currentScreen == 'dropbox'
    ), 
    buildIconButton(
      'assets/images/onedrive_white.png', // Caminho do ícone do OneDrive
      () => navigateToScreen(const CrawlerOnedriveScreen(), context), // Navega para a tela do OneDrive
      true,
      currentScreen == 'onedrive'
    ), 
    buildIconButton(
      'assets/images/more_white.png', // Caminho do ícone "mais" para mais opções
      () => navigateToScreen(const CrawlerMoreScreen(), context), // Navega para a tela com mais opções
      true
    ), 
  ];
}