import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:personal_power_cloud/screens/crawler_internal_storage_screen.dart';
import 'package:personal_power_cloud/theme/pallete.dart';
import 'package:personal_power_cloud/utils/screen_utils.dart'; 
import 'package:personal_power_cloud/widgets/login_field.dart';
import 'package:personal_power_cloud/screens/forgot_password_screen.dart';
import 'package:personal_power_cloud/screens/register_screen.dart';
import 'package:personal_power_cloud/providers/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:device_info_plus/device_info_plus.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isChecked = false;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Método para obter o ID do dispositivo
  Future<void> getDeviceId() async {
    try {
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      
      if (Platform.isAndroid) {
        AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        if (kDebugMode) {
          print('ID do dispositivo Android: ${androidInfo.id}');
        }
      } else if (Platform.isIOS) {
        IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
        if (kDebugMode) {
          print('ID do dispositivo iOS: ${iosInfo.identifierForVendor}');
        }
      } else if (Platform.isWindows) {
        WindowsDeviceInfo windowsInfo = await deviceInfo.windowsInfo;
        if (kDebugMode) {
          print('ID do dispositivo Windows: ${windowsInfo.deviceId}');
        }
      } else if (Platform.isLinux) {
        LinuxDeviceInfo linuxInfo = await deviceInfo.linuxInfo;
        if (kDebugMode) {
          print('ID do dispositivo Linux: ${linuxInfo.machineId}');
        }
      } else if (Platform.isMacOS) {
        MacOsDeviceInfo macInfo = await deviceInfo.macOsInfo;
        if (kDebugMode) {
          print('ID do dispositivo macOS: ${macInfo.systemGUID}');
        }
      } else {
        if (kDebugMode) {
          print('Plataforma não suportada.');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Erro ao obter o ID do dispositivo: $e');
      }
    }
  }

  Future<void> _login() async {
    // Imprime o valor do controlador de texto _emailController
    if (kDebugMode) {
      print('Email: ${_emailController.text}');
    }

    // Imprime o valor do controlador de texto _passwordController
    if (kDebugMode) {
      print('Password: ${_passwordController.text}');
    }

    // Armazena o email no AuthProvider
    Provider.of<AuthProvider>(context, listen: false).setEmail(_emailController.text);

    // Armazena a senha no AuthProvider
    Provider.of<AuthProvider>(context, listen: false).setPassword(_passwordController.text);

    // Navegação para a próxima tela
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const CrawlerInternalStorageScreen(
          // Se necessário, você pode passar parâmetros aqui
        ),
      ),
    );

    // Mensagem de depuração adicional
    if (kDebugMode) {
      print('Botão login pressionado');
    }

    // Obtém o ID do dispositivo antes de navegar para a próxima tela
    await getDeviceId();

  }

  Future<bool> _onWillPop(BuildContext context) async {
    SystemNavigator.pop(); // Fecha o aplicativo
    return false; // Retorne false para evitar que a tela atual seja removida da pilha
  }

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () => _onWillPop(context),
      child: Scaffold(
        backgroundColor: Pallete.backgroundColor,
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth > 800) {
                // Layout para telas grandes (Desktop e Web)
                return _buildWideLayout(context);
              } else {
                // Layout para telas pequenas (Celulares)
                return _buildNarrowLayout(context);
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _buildWideLayout(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: Column(
          children: [
        
            // SizedBox(height: getHeight(context, 0.046)),

            Container(
              width: MediaQuery.of(context).size.width * 0.3, // 30% da largura da tela
              decoration: BoxDecoration(
                border: Border.all(
                  color: Pallete.borderColor, // Cor da borda
                  width: 1.0, // Largura da borda
                ),
                borderRadius: BorderRadius.circular(10), // Cantos arredondados (opcional)
              ),
              child: Image.asset(
                'assets/images/personal_power_cloud_image.png',
                errorBuilder: (context, error, stackTrace) {
                  return Text(
                    'Error loading image: $error',
                    style: const TextStyle(color: Pallete.checkBoxTextColor),
                  );
                },
              ),
            ),
        
            // SizedBox(height: getHeight(context, 0.02)),
        
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.3, // 30% da largura da tela
              height: MediaQuery.of(context).size.height * 0.06, // 6% da altura da tela
              child: LoginField(
                hintText: 'Email',
                isPasswordField: false,
                controller: _emailController,
                suffixIconImage: 'assets/images/email.png',
                // padding: const EdgeInsets.symmetric(horizontal: 10.0),
                label: '',
              ),
            ),
        
            // SizedBox(height: getHeight(context, 0.02)),
        
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.3, // 30% da largura da tela
              height: MediaQuery.of(context).size.height * 0.06, // 6% da altura da tela
              child: LoginField(
                hintText: 'Password',
                isPasswordField: true,
                controller: _passwordController,
                suffixIconImage: 'assets/images/eye_close_blue.png',
                suffixIconVisibleImage: 'assets/images/eye_open_blue.png',
                // padding: const EdgeInsets.symmetric(horizontal: 10.0),
                label: '',
              ),
            ),
        
            // SizedBox(height: getHeight(context, 0.08)),
            // SizedBox(height: getHeight(context, 0.02)),

            Container(
              width: MediaQuery.of(context).size.width * 0.3, // 30% da largura da tela
              height: MediaQuery.of(context).size.height * 0.06, // 6% da altura da tela
              decoration: BoxDecoration(
                border: Border.all(
                  color: Pallete.borderColor, // Cor da borda
                  width: 1.0, // Largura da borda
                ),
                borderRadius: BorderRadius.circular(10), // Raio da borda (opcional)
              ),
              child: InkWell(
                onTap: () {
                  setState(() {
                    _isChecked = !_isChecked;
                  });
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Checkbox(
                      value: _isChecked,
                      onChanged: (bool? value) {
                        setState(() {
                          _isChecked = value ?? false;
                        });
                      },
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      activeColor: Pallete.checkBoxTextColor,
                      checkColor: Pallete.backgroundColor,
                      side: const BorderSide(
                        color: Pallete.checkBoxTextColor,
                        width: 1.0,
                      ),
                      visualDensity: VisualDensity.compact,
                    ),
                    const Text(
                      'Remember my password',
                      style: TextStyle(
                        fontSize: 20,
                        color: Pallete.checkBoxTextColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // SizedBox(height: getHeight(context, 0.02)),

            Container(
              width: MediaQuery.of(context).size.width * 0.3, // 30% da largura da tela
              height: MediaQuery.of(context).size.height * 0.06, // 6% da altura da tela
              decoration: BoxDecoration(
                border: Border.all(
                  color: Pallete.borderColor, // Cor da borda
                  width: 1.0, // Largura da borda
                ),
                borderRadius: BorderRadius.circular(10), // Raio da borda (opcional)
              ),

              child: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ForgotPasswordScreen(),
                    ),
                  );
                },

                child: const Text(
                  'Forgot Password?',
                  style: TextStyle(
                    fontSize: 20,
                    decoration: TextDecoration.underline,
                    decorationColor: Pallete.checkBoxTextColor,
                    color: Pallete.checkBoxTextColor,
                  ),
                ),
              ),
            ),
        
            // SizedBox(height: getHeight(context, 0.02)),

            SizedBox(
              width: MediaQuery.of(context).size.width * 0.3, // 30% da largura da tela
              height: MediaQuery.of(context).size.height * 0.06, // 6% da altura da tela
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Pallete.firstButtonColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: const BorderSide(color: Pallete.borderColor, width: 1),
                  ),
                ),
                onPressed: _login,
                child: const Text(
                  'Login',
                  style: TextStyle(
                    fontSize: 25,
                    color: Pallete.bottomTextColor,
                  ),
                ),
              ),
            ),

            // SizedBox(height: getHeight(context, 0.02)),
            
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.3, // 30% da largura da tela
              height: MediaQuery.of(context).size.height * 0.06, // 6% da altura da tela
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Pallete.secondButtonColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: const BorderSide(color: Pallete.borderColor, width: 1),
                  ),
                ),
                onPressed: () {
        
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const RegisterScreen(),
                    )
                  );
        
                  if (kDebugMode) {
                    print('Botão register pressionado');
                  }
                },
                child: const Text(
                  'Register',
                  style: TextStyle(
                    fontSize: 25,
                    color: Pallete.bottomTextColor,
                  ),
                ),
              ),
            ),
        
          ],
        ),
      ),
    );
  }

  Widget _buildNarrowLayout(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: Column(
          children: [

            // SizedBox(height: getHeight(context, 0.046)),

            Container(
              width: MediaQuery.of(context).size.width * 0.9, // 90% da largura da tela
              decoration: BoxDecoration(
                border: Border.all(
                  color: Pallete.borderColor, // Cor da borda
                  width: 1.0, // Largura da borda
                ),
                borderRadius: BorderRadius.circular(10), // Cantos arredondados (opcional)
              ),
              child: Image.asset(
                'assets/images/personal_power_cloud_image.png',
                errorBuilder: (context, error, stackTrace) {
                  return Text(
                    'Error loading image: $error',
                    style: const TextStyle(color: Pallete.checkBoxTextColor),
                  );
                },
              ),
            ),

            // SizedBox(height: getHeight(context, 0.02)),

            SizedBox(
              width: MediaQuery.of(context).size.width * 0.9, // 90% da largura da tela
              height: MediaQuery.of(context).size.height * 0.06, // 6% da altura da tela
              child: LoginField(
                hintText: 'Email',
                isPasswordField: false,
                controller: _emailController,
                suffixIconImage: 'assets/images/email.png',
                // padding: const EdgeInsets.symmetric(horizontal: 10.0),
                label: '',
              ),
            ),

            // SizedBox(height: getHeight(context, 0.02)),

            SizedBox(
              width: MediaQuery.of(context).size.width * 0.9, // 90% da largura da tela
              height: MediaQuery.of(context).size.height * 0.06, // 6% da altura da tela
              child: LoginField(
                hintText: 'Password',
                isPasswordField: true,
                controller: _passwordController,
                suffixIconImage: 'assets/images/eye_close_blue.png',
                suffixIconVisibleImage: 'assets/images/eye_open_blue.png',
                // padding: const EdgeInsets.symmetric(horizontal: 10.0),
                label: '',
              ),
            ),

            // SizedBox(height: getHeight(context, 0.08)),
            // SizedBox(height: getHeight(context, 0.02)),

            Container(
              width: MediaQuery.of(context).size.width * 0.9, // 90% da largura da tela
              height: MediaQuery.of(context).size.height * 0.06, // 6% da altura da tela
              decoration: BoxDecoration(
                border: Border.all(
                  color: Pallete.borderColor, // Cor da borda
                  width: 1.0, // Largura da borda
                ),
                borderRadius: BorderRadius.circular(10), // Raio da borda (opcional)
              ),
              child: InkWell(
                onTap: () {
                  setState(() {
                    _isChecked = !_isChecked;
                  });
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Checkbox(
                      value: _isChecked,
                      onChanged: (bool? value) {
                        setState(() {
                          _isChecked = value ?? false;
                        });
                      },
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      activeColor: Pallete.checkBoxTextColor,
                      checkColor: Pallete.backgroundColor,
                      side: const BorderSide(
                        color: Pallete.checkBoxTextColor,
                        width: 1.0,
                      ),
                      visualDensity: VisualDensity.compact,
                    ),
                    const Text(
                      'Remember my password',
                      style: TextStyle(
                        fontSize: 20,
                        color: Pallete.checkBoxTextColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // SizedBox(height: getHeight(context, 0.02)),

            Container(
              width: MediaQuery.of(context).size.width * 0.9, // 90% da largura da tela
              height: MediaQuery.of(context).size.height * 0.06, // 6% da altura da tela
              decoration: BoxDecoration(
                border: Border.all(
                  color: Pallete.borderColor, // Cor da borda
                  width: 1.0, // Largura da borda
                ),
                borderRadius: BorderRadius.circular(10), // Raio da borda (opcional)
              ),
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ForgotPasswordScreen(),
                    ),
                  );
                },
                child: const Text(
                  'Forgot Password?',
                  style: TextStyle(
                    fontSize: 20,
                    decoration: TextDecoration.underline,
                    decorationColor: Pallete.checkBoxTextColor,
                    color: Pallete.checkBoxTextColor,
                  ),
                ),
              ),
            ),

            // SizedBox(height: getHeight(context, 0.02)),

            SizedBox(
              width: MediaQuery.of(context).size.width * 0.9, // 90% da largura da tela
              height: MediaQuery.of(context).size.height * 0.06, // 6% da altura da tela
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Pallete.firstButtonColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: const BorderSide(color: Pallete.borderColor, width: 1),
                  ),
                ),
                onPressed: _login, // Inserido aqui conforme solicitado
                child: const Text(
                  'Login',
                  style: TextStyle(
                    fontSize: 25,
                    color: Pallete.bottomTextColor,
                  ),
                ),
              ),
            ),

            // SizedBox(height: getHeight(context, 0.02)),

            SizedBox(
              width: MediaQuery.of(context).size.width * 0.9, // 90% da largura da tela
              height: MediaQuery.of(context).size.height * 0.06, // 6% da altura da tela
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Pallete.secondButtonColor,
                  // padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: const BorderSide(color: Pallete.borderColor, width: 1),
                  ),
                ),
                onPressed: () {

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const RegisterScreen(),
                    ));

                  if (kDebugMode) {
                    print('Botão register pressionado');
                  }
                },
                child: const Text(
                  'Register',
                  style: TextStyle(
                    fontSize: 25,
                    color: Pallete.bottomTextColor,
                  ),
                ),
              ),
            ),
            
          ],
        ),
      ),
    );
  }
}