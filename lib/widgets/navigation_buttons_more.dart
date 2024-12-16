// Responsável por criar os botões de navegação para as telas de crawler.
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:personal_power_cloud/screens/crawler_ftp_screen.dart';
import 'package:personal_power_cloud/screens/crawler_http_screen.dart';
import 'package:personal_power_cloud/screens/crawler_internal_storage_screen.dart';
import 'package:personal_power_cloud/screens/crawler_rsync_screen.dart';
import 'package:personal_power_cloud/screens/crawler_sftp_screen.dart';
import 'package:personal_power_cloud/theme/decorations.dart';
import 'package:personal_power_cloud/utils/screen_utils.dart';
import 'package:personal_power_cloud/widgets/icon_button.dart'; // Importa o widget de botão de ícone

void navigateToScreen(Widget screen, BuildContext context) {
  // Utiliza o Navigator para realizar a navegação para a tela especificada.
  Navigator.push(context, MaterialPageRoute(builder: (context) => screen, ),);
}

List<Widget> buildNavigationButtonsMore(BuildContext context, String currentScreen) {
  return [
    buildIconButton(
      'assets/images/ftp_blue.png', // Caminho do ícone Less
      () => navigateToScreen(const CrawlerFtpScreen(), context), // Navega para a tela do CRAWLER
      true,
      currentScreen == 'ftp'
    ), 
    buildIconButton(
      'assets/images/sftp_white.png', // Caminho do ícone do PPC
      () => navigateToScreen(const CrawlerSftpScreen(), context), // Navega para a tela PPC
      true,
      currentScreen == 'sftp'
    ), 
    buildIconButton(
      'assets/images/rsync_white.png', // Caminho do ícone do Google Drive
      () => navigateToScreen(const CrawlerRsyncScreen(), context), // Navega para a tela do Google Drive
      true, 
      currentScreen == 'rsync' // caso a tela atual seja a rsync, está selecionado recebe true
    ), 
    buildIconButton(
      'assets/images/http_white.png', // Caminho do ícone do Dropbox
      () => navigateToScreen(const CrawlerHttpScreen(), context), // Navega para a tela do Dropbox
      true,
      currentScreen == 'http'
    ), 
    buildIconButton(
      'assets/images/http_invisible.png', // Caminho do ícone do OneDrive
      // () => navigateToScreen(const CrawlerOnedriveScreen(), context), // Navega para a tela do OneDrive
      () {
        // Função vazia, não faz nada quando o botão é pressionado
      },
      false, // é clicável?
      false,  // está selecionado?
      true // é transparente?
    ), 
    buildIconButton(
      'assets/images/http_invisible.png', // Caminho do ícone "mais" para mais opções
      // () => navigateToScreen(const CrawlerMoreScreen(), context), // Navega para a tela com mais opções
      () {
        // Função vazia, não faz nada quando o botão é pressionado
      },
      false, // é clicável?
      false, // está selecionado?
      true // é transparente?
    ),
  ];
}

Widget buildNavigationBarMore(BuildContext context, String selectedScreen) {
  if (kDebugMode) {
    print('selectedScreen $selectedScreen');
  }
  return Container(
    height: getHeight(context, 0.06), // Define a altura da barra de navegação como 6% da altura total da tela
    width: getWidth(context, 0.9), // Define a largura da barra de navegação como 90% da largura total da tela
    decoration: boxDecoration(), // Aplica a decoração definida na função `boxDecoration()`, que pode incluir bordas, cores, etc.
    child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Distribui os itens na linha de forma espaçada uniformemente
      children: [
        buildIconButton('assets/images/less_white.png', // Caminho para o ícone de armazenamento interno
          () {
            if (selectedScreen != 'crawler') {
              navigateToScreen(const CrawlerInternalStorageScreen(),
                  context); // Navega para a tela de armazenamento interno
            }
          }, // Função vazia que seria chamada ao clicar no botão
            true,
            selectedScreen == 'crawler'), // Indica que o botão pode ser pressionado
        ...buildNavigationButtonsMore(context, selectedScreen), // Desestrutura o retorno da função `buildNavigationButtons()` e insere os botões de navegação aqui
      ],
    ),
  );
}