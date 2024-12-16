import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:personal_power_cloud/providers/storage_provider.dart';
import 'package:personal_power_cloud/screens/splash_screen.dart';
import 'package:url_launcher_windows/url_launcher_windows.dart';
import 'package:provider/provider.dart';
import 'package:personal_power_cloud/providers/auth_provider.dart'; // Importe o AuthProvider

// void main() {
//   WidgetsFlutterBinding.ensureInitialized();
//   SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
//       .then((_) {
//     runApp(const MyApp());
//   });
// }

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  if (!kIsWeb) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  }
  // Verifique se a plataforma é Windows
  if (Platform.isWindows) {
    UrlLauncherWindows.registerWith();
  }

  // runApp(const MyApp());
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => StorageProvider()), // Adicione o provedor de armazenamento 
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Personal Power Cloud',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const SplashScreen(),
      initialRoute: '/',
      routes: {
        '/splash': (context) => const SplashScreen(),
      },
    );
  }
}
