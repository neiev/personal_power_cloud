import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:googleapis/drive/v3.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:personal_power_cloud/providers/auth_provider.dart';

class GoogleDriveIntegration {
  final _clientId = ClientId(
    '825969127473-7ccjklac1c1apl12o0ln7mkkdd8l0111.apps.googleusercontent.com', // Substitua pelo seu Client ID
    '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', // Substitua pelo seu Client Secret (se necessário)
  );
  // web abaixo
  // final _clientId = ClientId(
  //   '825969127473-j97i6n33vic8uicani4cqhj1809rjeng.apps.googleusercontent.com', // Substitua pelo seu Client ID
  //   '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', // Substitua pelo seu Client Secret (se necessário)
  // );
  
  final _scopes = [
    DriveApi.driveFileScope, 
    DriveApi.driveScope, 
    DriveApi.driveMetadataScope
  ];
  var _authClient;

  // Método para login no Google Drive (funciona em desktop e mobile)
  Future<void> loginToGoogleDrive(BuildContext context) async {
    try {
      // Autenticação via consentimento do usuário
      final authClient = await clientViaUserConsent(
        _clientId,
        _scopes,
        
        (uri) {
          if (kDebugMode) {
            print("Abra este link para autenticar: $uri");
          }
          // Abre a URL de autenticação no navegador
          final url = Uri.parse(uri).toString();
          if (kDebugMode) {
            print(uri);
          }
          // Abre a URL no navegador
          //_openUrl(url);

          _launchURL(url);  // Abre a URL no navegador
        },
      ); 
      // Salve o cliente autenticado no AuthProvider
      Provider.of<AuthProvider>(context, listen: false).setAuthClient(authClient);
    } catch (e) {
      if (kDebugMode) {
        print('Erro no login: $e');
      }
    }
  }

  void _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (kDebugMode) {
      print(uri);
    }
    if (Platform.isWindows || Platform.isMacOS || Platform.isLinux) {
      // Para desktop, abrir diretamente no navegador
      try {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } catch (e) {
        throw 'Could not launch $uri';
      }
    } else {
      // Para outras plataformas, use o url_launcher normalmente
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        throw 'Could not launch $uri';
      }
    }
  }

  // // Função para abrir a URL de autenticação no navegador
  // void _openUrl(Uri url) {
  //   if (Platform.isWindows || Platform.isMacOS || Platform.isLinux) {
  //     // Para desktop, abrir diretamente no navegador
  //     Process.run('cmd', ['/c', 'start', url.toString()]);
  //   }
  // }

  // Função para abrir a URL de autenticação no navegador
  void _openUrl(String url) {
    if (Platform.isWindows) {
      if (kDebugMode) {
        print('É windows');
      }
      Process.run('cmd', ['/c', 'start', url]);
    } else if (Platform.isMacOS) {
      Process.run('open', [url]);
    } else if (Platform.isLinux) {
      Process.run('xdg-open', [url]);
    } else {
      // Para mobile (Android e iOS), usar flutter_webview ou um navegador embutido
      if (kDebugMode) {
        print(url);
        String os = Platform.operatingSystem;
        print("$os - Abra este link para autenticar: $url");
      }
    }
  }

  // Função para logout (encerra o cliente autenticado)
  Future<void> logout() async {
    if (kDebugMode) {
      print("Logout efetuado");
    }
  }

  // Função para listar arquivos no Google Drive
  Future<void> listFiles(AuthClient authClient) async {
    final driveApi = DriveApi(authClient);

    //Lista os arquivos do Google Drive
    var files = await driveApi.files.list();
    if (kDebugMode) {
      print('Arquivos: ${files.files}');
    }

    var fileList = await driveApi.files.list();
    if (kDebugMode) {
      print("Listando arquivos...");
    }
  }
}
