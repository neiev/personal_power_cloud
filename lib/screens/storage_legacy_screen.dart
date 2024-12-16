import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:personal_power_cloud/providers/auth_provider.dart';
import 'package:personal_power_cloud/screens/storage_legacy_screen1.dart';
import 'package:personal_power_cloud/theme/pallete.dart';
import 'package:personal_power_cloud/utils/screen_utils.dart';
import 'package:personal_power_cloud/widgets/custom_popup.dart';
import 'package:personal_power_cloud/widgets/navigation_buttons.dart';
import 'package:personal_power_cloud/screens/crawler_internal_storage_screen.dart';
import 'package:personal_power_cloud/screens/storage_screen.dart';
import 'package:provider/provider.dart';

class StorageLegacyScreen extends StatefulWidget {
  const StorageLegacyScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _StorageLegacyScreenState createState() => _StorageLegacyScreenState();
}

class _StorageLegacyScreenState extends State<StorageLegacyScreen> {
  bool _isEyeOpen = false; // Estado inicial (fechado)
  bool _isPasswordVisible = false; // Controla visibilidade da senha

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

  Future<bool> _onWillPop(BuildContext context) async {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const StorageScreen()),
    );
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
    return Scaffold(
      backgroundColor: Pallete.backgroundColor,
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [

              // SizedBox(height: getHeight(context, 0.046)),

              SizedBox(
                width: MediaQuery.of(context).size.width * 0.3, // 30% da largura da tela
                height: MediaQuery.of(context).size.height * 0.06, // 6% da altura da tela
                child: Container(
                  decoration: BoxDecoration(
                    color: Pallete.boxColor,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Pallete.borderColor, width: 1),
                  ),
                  child: Row(
                    children: [
                      const Expanded(
                        child: TextField(
                          style: TextStyle(
                            color: Pallete.userTextColor, // Define a cor do texto digitado
                            fontSize: 20,
                          ),
                          decoration: InputDecoration(
                            hintText: 'Search',
                            border: InputBorder.none,
                            hintStyle: TextStyle(
                              color: Pallete.backgroundTextColor,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Image.asset('assets/images/search_blue.png',
                          width: 36,
                          height: 36,
                        ),
                        onPressed: () {
                          if (kDebugMode) {
                            print('Botão search pressionado');
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),

              // SizedBox(height: getHeight(context, 0.30)),

              SizedBox(
                width: MediaQuery.of(context).size.width * 0.3, // 30% da largura da tela
                height: MediaQuery.of(context).size.height * 0.06, // 6% da altura da tela
                child: Container(
                  decoration: BoxDecoration(
                    color: Pallete.boxColor,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Pallete.borderColor, width: 1),
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        icon: Image.asset('assets/images/host_ip_blue.png',
                          width: 36,
                          height: 36,
                        ),
                        onPressed: () {
                          if (kDebugMode) {
                            print('Botão host/ip pressionado');
                          }
                        },
                      ),

                      Expanded(
                        child: Consumer<AuthProvider>(
                          builder: (context, authProvider, child) {
                            return TextField(
                              onChanged: (value) {
                                authProvider.setHost(value);
                              },
                              style: const TextStyle(
                                color: Pallete.userTextColor, // Define a cor do texto digitado
                                fontSize: 20,
                              ),
                              decoration: const InputDecoration(
                                hintText: 'Host/IP',
                                border: InputBorder.none,
                                hintStyle: TextStyle(
                                  color: Pallete.backgroundTextColor,
                                  fontSize: 20,
                                ),
                              ),
                            );
                          },
                        ),
                      ),

                    ],
                  ),
                ),
              ),

              // SizedBox(height: getHeight(context, 0.02)),

              SizedBox(
                width: MediaQuery.of(context).size.width * 0.3, // 30% da largura da tela
                height: MediaQuery.of(context).size.height * 0.06, // 6% da altura da tela
                child: Container(
                  decoration: BoxDecoration(
                    color: Pallete.boxColor,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Pallete.borderColor, width: 1),
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        icon: Image.asset('assets/images/port_blue.png',
                          width: 36,
                          height: 36,
                        ),
                        onPressed: () {
                          if (kDebugMode) {
                            print('Botão port pressionado');
                          }
                        },
                      ),

                      Expanded(
                        child: Consumer<AuthProvider>(
                          builder: (context, authProvider, child) {
                            return TextField(
                              onChanged: (value) {
                                authProvider.setPort(value);
                              },
                              style: const TextStyle(
                                color: Pallete.userTextColor, // Define a cor do texto digitado
                                fontSize: 20,
                              ),
                              decoration: const InputDecoration(
                                hintText: 'Port',
                                border: InputBorder.none,
                                hintStyle: TextStyle(
                                  color: Pallete.backgroundTextColor,
                                  fontSize: 20,
                                ),
                              ),
                            );
                          },
                        ),
                      ),

                    ],
                  ),
                ),
              ),

              // SizedBox(height: getHeight(context, 0.02)),

              SizedBox(
                width: MediaQuery.of(context).size.width * 0.3, // 30% da largura da tela
                height: MediaQuery.of(context).size.height * 0.06, // 6% da altura da tela
                child: Container(
                  decoration: BoxDecoration(
                    color: Pallete.boxColor,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Pallete.borderColor, width: 1),
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        icon: Image.asset('assets/images/user_blue1.png',
                          width: 36,
                          height: 36,
                        ),
                        onPressed: () {
                          if (kDebugMode) {
                            print('Botão user pressionado');
                          }
                        },
                      ),

                      Expanded(
                        child: Consumer<AuthProvider>(
                          builder: (context, authProvider, child) {
                            return TextField(
                              onChanged: (value) {
                                authProvider.setUser(value);
                              },
                              style: const TextStyle(
                                color: Pallete.userTextColor, // Define a cor do texto digitado
                                fontSize: 20,
                              ),
                              decoration: const InputDecoration(
                                hintText: 'User',
                                border: InputBorder.none,
                                hintStyle: TextStyle(
                                  color: Pallete.backgroundTextColor,
                                  fontSize: 20,
                                ),
                              ),
                            );
                          },
                        ),
                      ),

                    ],
                  ),
                ),
              ),

              // SizedBox(height: getHeight(context, 0.02)),

              SizedBox(
                width: MediaQuery.of(context).size.width * 0.3, // 30% da largura da tela
                height: MediaQuery.of(context).size.height * 0.06, // 6% da altura da tela
                child: Container(
                  decoration: BoxDecoration(
                    color: Pallete.boxColor,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Pallete.borderColor, width: 1),
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        icon: Image.asset('assets/images/password_blue.png',
                          width: 36,
                          height: 36,
                        ),
                        onPressed: () {
                          if (kDebugMode) {
                            print('Botão password pressionado');
                          }
                        },
                      ),

                      Expanded(
                        child: Consumer<AuthProvider>(
                          builder: (context, authProvider, child) {
                            return TextField(
                              onChanged: (value) {
                                authProvider.setPassword1(value);
                              },
                              obscureText: !_isPasswordVisible, // Controla se a senha está visível
                              style: const TextStyle(
                                color: Pallete.userTextColor, // Define a cor do texto digitado
                                fontSize: 20,
                              ),
                              decoration: const InputDecoration(
                                hintText: 'Password',
                                border: InputBorder.none,
                                hintStyle: TextStyle(
                                  color: Pallete.backgroundTextColor,
                                  fontSize: 20,
                                ),
                              ),
                            );
                          },
                        ),
                      ),

                      IconButton(
                        icon: Image.asset(
                          _isEyeOpen 
                              ? 'assets/images/eye_open_blue.png' // Ícone para olho aberto
                              : 'assets/images/eye_close_blue.png', // Ícone para olho fechado
                          width: 36,
                          height: 36,
                        ),
                        onPressed: () {
                          setState(() {
                            _isEyeOpen = !_isEyeOpen; // Alterna o estado
                            _isPasswordVisible = !_isPasswordVisible; // Alterna visibilidade da senha
                          });
                          if (kDebugMode) {
                            print('Botão eye pressionado: ${_isEyeOpen ? "aberto" : "fechado"}');
                          }
                        },
                      ),

                    ],
                  ),
                ),
              ),

              // SizedBox(height: getHeight(context, 0.02)),

              Column(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.3, // 30% da largura da tela
                    height: MediaQuery.of(context).size.height * 0.06, // 6% da altura da tela
                    child: CustomButton(
                      text: 'Connect',
                      onPressed: () {
                        
                        showCustomPopup(
                          context: context,
                          title: 'Connect server',
                          message: 'Are you requesting connection to the server?',
                          width: MediaQuery.of(context).size.width * 0.9, // Define a largura
                          // height: MediaQuery.of(context).size.height * 0.4, // Define a altura

                          actions: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [

                                SizedBox(
                                  width: MediaQuery.of(context).size.width * 0.2,
                                  height: MediaQuery.of(context).size.height * 0.06,
                                  child: TextButton(
                                    style: TextButton.styleFrom(
                                      backgroundColor: Pallete.firstButtonColor,
                                      foregroundColor: Pallete.bottomTextColor,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10.0),
                                        side: const BorderSide(color: Pallete.borderColor, width: 1),
                                      ),
                                    ),
                                    onPressed: () {
                                      Navigator.of(context).pop(); // Fecha o popup
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => const StorageLegacyScreen1(),
                                        ),
                                      );
                                    },
                                    child: const Text(
                                      'Yes',
                                      style: TextStyle(
                                        fontSize: 25.0,
                                      ),
                                    ),
                                  ),
                                ),

                                const SizedBox(width: 16.0),

                                SizedBox(
                                  width: MediaQuery.of(context).size.width * 0.2,
                                  height: MediaQuery.of(context).size.height * 0.06,
                                  child: ElevatedButton(
                                    style: TextButton.styleFrom(
                                      backgroundColor: Pallete.secondButtonColor,
                                      foregroundColor: Pallete.bottomTextColor,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10.0),
                                        side: const BorderSide(color: Pallete.borderColor, width: 1),
                                      ),
                                    ),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      // Outra ação
                                    },
                                    child: const Text(
                                      'No',
                                      style: TextStyle(
                                        fontSize: 25.0,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),

                          ],

                        );

                        if (kDebugMode) {
                          print('Botão connect pressionado');
                        }
                      },
                    ),
                  ),
                ],
              ),

            ],
          ),
        ),
      ),
      bottomNavigationBar: buildBottomNavigationBar(
        context,
        '',
        'storage',
        () => navigateToScreen(
          const CrawlerInternalStorageScreen(), 
          context
        ),
        null,
      ),
    );

  }

  Widget _buildNarrowLayout(BuildContext context) {
    return Scaffold(
      backgroundColor: Pallete.backgroundColor,
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [

              // SizedBox(height: getHeight(context, 0.046)),

              SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                height: MediaQuery.of(context).size.height * 0.06,
                child: Container(
                  decoration: BoxDecoration(
                    color: Pallete.boxColor,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Pallete.borderColor, width: 1),
                  ),
                  child: Row(
                    children: [
                      const Expanded(
                        child: TextField(
                          style: TextStyle(
                            color: Pallete.userTextColor, // Define a cor do texto digitado
                            fontSize: 20,
                          ),
                          decoration: InputDecoration(
                            hintText: 'Search',
                            border: InputBorder.none,
                            hintStyle: TextStyle(
                              color: Pallete.backgroundTextColor,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Image.asset('assets/images/search_blue.png',
                          width: 36,
                          height: 36,
                        ),
                        onPressed: () {
                          if (kDebugMode) {
                            print('Botão search pressionado');
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),

              // SizedBox(height: getHeight(context, 0.30)),

              SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                height: MediaQuery.of(context).size.height * 0.06,
                child: Container(
                  decoration: BoxDecoration(
                    color: Pallete.boxColor,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Pallete.borderColor, width: 1),
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        icon: Image.asset('assets/images/host_ip_blue.png',
                          width: 36,
                          height: 36,
                        ),
                        onPressed: () {
                          if (kDebugMode) {
                            print('Botão host/ip pressionado');
                          }
                        },
                      ),

                      Expanded(
                        child: Consumer<AuthProvider>(
                          builder: (context, authProvider, child) {
                            return TextField(
                              onChanged: (value) {
                                authProvider.setHost(value);
                              },
                              style: const TextStyle(
                                color: Pallete.userTextColor, // Define a cor do texto digitado
                                fontSize: 20,
                              ),
                              decoration: const InputDecoration(
                                hintText: 'Host/IP',
                                border: InputBorder.none,
                                hintStyle: TextStyle(
                                  color: Pallete.backgroundTextColor,
                                  fontSize: 20,
                                ),
                              ),
                            );
                          },
                        ),
                      ),

                    ],
                  ),
                ),
              ),

              // SizedBox(height: getHeight(context, 0.02)),

              SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                height: MediaQuery.of(context).size.height * 0.06,
                child: Container(
                  decoration: BoxDecoration(
                    color: Pallete.boxColor,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Pallete.borderColor, width: 1),
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        icon: Image.asset('assets/images/port_blue.png',
                          width: 36,
                          height: 36,
                        ),
                        onPressed: () {
                          if (kDebugMode) {
                            print('Botão port pressionado');
                          }
                        },
                      ),

                      Expanded(
                        child: Consumer<AuthProvider>(
                          builder: (context, authProvider, child) {
                            return TextField(
                              onChanged: (value) {
                                authProvider.setPort(value);
                              },
                              style: const TextStyle(
                                color: Pallete.userTextColor, // Define a cor do texto digitado
                                fontSize: 20,
                              ),
                              decoration: const InputDecoration(
                                hintText: 'Port',
                                border: InputBorder.none,
                                hintStyle: TextStyle(
                                  color: Pallete.backgroundTextColor,
                                  fontSize: 20,
                                ),
                              ),
                            );
                          },
                        ),
                      ),

                    ],
                  ),
                ),
              ),

              // SizedBox(height: getHeight(context, 0.02)),

              SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                height: MediaQuery.of(context).size.height * 0.06,
                child: Container(
                  decoration: BoxDecoration(
                    color: Pallete.boxColor,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Pallete.borderColor, width: 1),
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        icon: Image.asset('assets/images/user_blue1.png',
                          width: 36,
                          height: 36,
                        ),
                        onPressed: () {
                          if (kDebugMode) {
                            print('Botão user pressionado');
                          }
                        },
                      ),

                      Expanded(
                        child: Consumer<AuthProvider>(
                          builder: (context, authProvider, child) {
                            return TextField(
                              onChanged: (value) {
                                authProvider.setUser(value);
                              },
                              style: const TextStyle(
                                color: Pallete.userTextColor, // Define a cor do texto digitado
                                fontSize: 20,
                              ),
                              decoration: const InputDecoration(
                                hintText: 'User',
                                border: InputBorder.none,
                                hintStyle: TextStyle(
                                  color: Pallete.backgroundTextColor,
                                  fontSize: 20,
                                ),
                              ),
                            );
                          },
                        ),
                      ),

                    ],
                  ),
                ),
              ),

              // SizedBox(height: getHeight(context, 0.02)),

              SizedBox(
                width: MediaQuery.of(context).size.width * 0.9, // 90% da largura da tela
                height: MediaQuery.of(context).size.height * 0.06, // 6% da altura da tela
                child: Container(
                  decoration: BoxDecoration(
                    color: Pallete.boxColor,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Pallete.borderColor, width: 1),
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        icon: Image.asset('assets/images/password_blue.png',
                          width: 36,
                          height: 36,
                        ),
                        onPressed: () {
                          if (kDebugMode) {
                            print('Botão password pressionado');
                          }
                        },
                      ),

                      Expanded(
                        child: Consumer<AuthProvider>(
                          builder: (context, authProvider, child) {
                            return TextField(
                              onChanged: (value) {
                                authProvider.setPassword1(value);
                              },
                              obscureText: !_isPasswordVisible, // Controla se a senha está visível
                              style: const TextStyle(
                                color: Pallete.userTextColor, // Define a cor do texto digitado
                                fontSize: 20,
                              ),
                              decoration: const InputDecoration(
                                hintText: 'Password',
                                border: InputBorder.none,
                                hintStyle: TextStyle(
                                  color: Pallete.backgroundTextColor,
                                  fontSize: 20,
                                ),
                              ),
                            );
                          },
                        ),
                      ),

                      IconButton(
                        icon: Image.asset(
                          _isEyeOpen 
                              ? 'assets/images/eye_open_blue.png' // Ícone para olho aberto
                              : 'assets/images/eye_close_blue.png', // Ícone para olho fechado
                          width: 36,
                          height: 36,
                        ),
                        onPressed: () {
                          setState(() {
                            _isEyeOpen = !_isEyeOpen; // Alterna o estado
                            _isPasswordVisible = !_isPasswordVisible; // Alterna visibilidade da senha
                          });
                          if (kDebugMode) {
                            print('Botão eye pressionado: ${_isEyeOpen ? "aberto" : "fechado"}');
                          }
                        },
                      ),

                    ],
                  ),
                ),
              ),

              // SizedBox(height: getHeight(context, 0.02)),

              Column(
                children: [
                  CustomButton(
                    text: 'Connect',
                    onPressed: () {
                      
                      showCustomPopup(
                        context: context,
                        title: 'Connect server',
                        message: 'Are you requesting connection to the server?',
                        width: MediaQuery.of(context).size.width * 0.9, // Define a largura
                        // height: MediaQuery.of(context).size.height * 0.4, // Define a altura

                        actions: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [

                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.319,
                                height: MediaQuery.of(context).size.height * 0.06,
                                child: TextButton(
                                  style: TextButton.styleFrom(
                                    backgroundColor: Pallete.firstButtonColor,
                                    foregroundColor: Pallete.bottomTextColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                      side: const BorderSide(color: Pallete.borderColor, width: 1),
                                    ),
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).pop(); // Fecha o popup
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const StorageLegacyScreen1(),
                                      ),
                                    );
                                  },
                                  child: const Text(
                                    'Yes',
                                    style: TextStyle(
                                      fontSize: 25.0,
                                    ),
                                  ),
                                ),
                              ),

                              const SizedBox(width: 16.0),

                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.319,
                                height: MediaQuery.of(context).size.height * 0.06,
                                child: ElevatedButton(
                                  style: TextButton.styleFrom(
                                    backgroundColor: Pallete.secondButtonColor,
                                    foregroundColor: Pallete.bottomTextColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                      side: const BorderSide(color: Pallete.borderColor, width: 1),
                                    ),
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    // Outra ação
                                  },
                                  child: const Text(
                                    'No',
                                    style: TextStyle(
                                      fontSize: 25.0,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),

                        ],

                      );

                      if (kDebugMode) {
                        print('Botão connect pressionado');
                      }
                    },
                  ),
                ],
              ),

            ],
          ),
        ),
      ),
      bottomNavigationBar: buildBottomNavigationBar(
        context,
        '',
        'storage',
        () => navigateToScreen(
          const CrawlerInternalStorageScreen(), 
          context
        ),
        null,
      ),
    );

  }

}

class CustomButton extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  // ignore: library_private_types_in_public_api
  _CustomButtonState createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onPressed,
        child: Container(
          width: MediaQuery.of(context).size.width * 0.9,
          height: MediaQuery.of(context).size.height * 0.06,
          decoration: BoxDecoration(
            color: _isHovered ? Pallete.firstButtonColor1 : Pallete.firstButtonColor, // Altere a cor do botão
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: Pallete.borderColor,
              width: 1
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.text,
                    style: TextStyle(
                      color: _isHovered ? Pallete.bottomTextColor1 : Pallete.bottomTextColor,
                      fontSize: 25,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
