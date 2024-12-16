import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:personal_power_cloud/screens/crawler_internal_storage_screen.dart';
import 'package:personal_power_cloud/screens/register_screen.dart';
import 'package:personal_power_cloud/theme/pallete.dart';
import 'package:personal_power_cloud/utils/screen_utils.dart';
import 'package:personal_power_cloud/widgets/custom_popup.dart';
import 'package:personal_power_cloud/widgets/login_field.dart';
import 'package:device_info_plus/device_info_plus.dart';

class NextScreen extends StatefulWidget {
  const NextScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _NextScreenState createState() => _NextScreenState();
}

class _NextScreenState extends State<NextScreen> {
  late TextEditingController _firstAnswerController;
  late TextEditingController _secondAnswerController;
  String? _selectedFirstSecurityQuestion;
  String? _selectedSecondSecurityQuestion;
  final List<String> _securityQuestions = [
    'Childhood nickname?',
    'City of your first job?',
    'City where you met your spouse?',
    'Name of your childhood friend?',
    'Childhood hero?',
  ];

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

  @override
  void initState() {
    super.initState();
    _firstAnswerController = TextEditingController();
    _secondAnswerController = TextEditingController();
  }

  @override
  void dispose() {
    _firstAnswerController.dispose();
    _secondAnswerController.dispose();
    super.dispose();
  }




  void _showSecurityQuestionMenu(BuildContext context, bool isFirst) async {
    final RenderBox? button = context.findRenderObject() as RenderBox?;
    final RenderBox? overlay = Overlay.of(context).context.findRenderObject() as RenderBox?;

    if (button == null || overlay == null) {
      // Verifique se os elementos existem antes de prosseguir
      debugPrint('Erro: botão ou overlay não encontrado.');
      return;
    }

    // Calcula a posição do menu com ajustes de offset
    final position = RelativeRect.fromRect(
      Rect.fromPoints(
        button.localToGlobal(
          button.size.bottomLeft(const Offset(0, 10)),
          ancestor: overlay,
        ),
        button.localToGlobal(
          button.size.bottomRight(const Offset(0, 10)),
          ancestor: overlay,
        ),
      ),
      Offset.zero & overlay.size,
    );

    // Exibe o menu e aguarda a seleção do usuário
    final String? selected = await showMenu<String>(
      context: context,
      position: position,
      items: _securityQuestions.map((String question) {
        return PopupMenuItem<String>(
          value: question,
          child: SizedBox(
            width: button.size.width, // Define a largura do menu com base no botão
            child: Text(question),
          ),
        );
      }).toList(),
    );

    // Atualiza o estado com a seleção feita pelo usuário
    if (selected != null) {
      setState(() {
        if (isFirst) {
          _selectedFirstSecurityQuestion = selected;
        } else {
          _selectedSecondSecurityQuestion = selected;
        }
      });
    }
  }




  Future<bool> _onWillPop(BuildContext context) async {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const RegisterScreen()),
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

            GestureDetector(
              onTap: () => _showSecurityQuestionMenu(context, false),
              child: PopupMenuButton<String>(
                color: Pallete.dropdownColor,
                // Usando constraints para garantir que a largura será 100% da tela
                constraints: BoxConstraints(
                  minWidth: MediaQuery.of(context).size.width * 0.3, // 30% da largura da tela
                ),
                onSelected: (String value) {
                  setState(() {
                    _selectedFirstSecurityQuestion = value;
                  });
                },
                itemBuilder: (BuildContext context) {
                  return _securityQuestions.map((String question) {
                    return PopupMenuItem<String>(
                      value: question,
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(13.0),
                        decoration: BoxDecoration(
                          color: Pallete.dropdownColor,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: Pallete.borderColor,
                            width: 1.0,
                          ),
                        ),

                        child: Text(
                          question,
                          style: const TextStyle(color: Pallete.backgroundTextColor),
                        ),

                      ),
                    );
                  }).toList();
                },
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.3, // 30% da largura da tela
                  height: MediaQuery.of(context).size.height * 0.06, // 6% da altura da tela
                  decoration: BoxDecoration(
                    color: Pallete.boxColor,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Pallete.borderColor,
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Text(
                          _selectedFirstSecurityQuestion ?? 'Security question',
                          style: const TextStyle(
                            color: Pallete.backgroundTextColor,
                          ),
                        ),
                      ),

                      Image.asset(
                        'assets/images/down_arrow_blue.png',
                        width: 36,
                        height: 36,
                        color: Pallete.iconColor,
                      ),

                    ],
                  ),
                ),
              ),
            ),

            // SizedBox(height: getHeight(context, 0.02)),

            SizedBox(
              width: MediaQuery.of(context).size.width * 0.3, // 30% da largura da tela
              height: MediaQuery.of(context).size.height * 0.06, // 6% da altura da tela
              child: LoginField(
                label: '',
                hintText: "First question's answer",
                isPasswordField: false,
                suffixIconImage: 'assets/images/write_blue.png',
                controller: _firstAnswerController,
              ),
            ),

            // SizedBox(height: getHeight(context, 0.02)),

            GestureDetector(
              onTap: () => _showSecurityQuestionMenu(context, false),
              child: PopupMenuButton<String>(
                color: Pallete.dropdownColor,
                // Usando constraints para garantir que a largura será 100% da tela
                constraints: BoxConstraints(
                  minWidth: MediaQuery.of(context).size.width * 0.3, // 90% da largura da tela
                ),
                onSelected: (String value) {
                  setState(() {
                    _selectedSecondSecurityQuestion = value;
                  });
                },
                itemBuilder: (BuildContext context) {
                  return _securityQuestions.map((String question) {
                    return PopupMenuItem<String>(
                      value: question,
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(13.0),
                        decoration: BoxDecoration(
                          color: Pallete.dropdownColor,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: Pallete.borderColor,
                            width: 1.0,
                          ),
                        ),

                        child: Text(
                          question,
                          style: const TextStyle(color: Pallete.backgroundTextColor),
                        ),

                      ),
                    );
                  }).toList();
                },
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.3, // 30% da largura da tela 
                  height: MediaQuery.of(context).size.height * 0.06, // 6% da altura da tela
                  decoration: BoxDecoration(
                    color: Pallete.boxColor,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Pallete.borderColor,
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Text(
                          _selectedSecondSecurityQuestion ?? 'Security question',
                          style: const TextStyle(
                            color: Pallete.backgroundTextColor,
                          ),
                        ),
                      ),

                      Image.asset(
                        'assets/images/down_arrow_blue.png',
                        width: 36,
                        height: 36,
                        color: Pallete.iconColor,
                      ),

                    ],
                  ),
                ),
              ),
            ),

            // SizedBox(height: getHeight(context, 0.02)),

            SizedBox(
              width: MediaQuery.of(context).size.width * 0.3, // 30% da largura da tela
              height: MediaQuery.of(context).size.height * 0.06, // 6% da altura da tela
              child: LoginField(
                label: '',
                hintText: "Second question's answer",
                isPasswordField: false,
                suffixIconImage: 'assets/images/write_blue.png',
                controller: _secondAnswerController,
              ),
            ),

            // SizedBox(height: getHeight(context, 0.076)),

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
                onPressed: () async {

                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) => const CrawlerInternalStorageScreen(),
                  //   ),
                  // );

                  showCustomPopup(
                    context: context,
                    title: 'Registered',
                    message: 'Thank you for registering.',
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
                                    builder: (context) => const CrawlerInternalStorageScreen(),
                                  ),
                                );
                              },
                              child: const Text(
                                'Ok',
                                style: TextStyle(
                                  fontSize: 25.0,
                                ),
                              ),
                            ),
                          ),

                          // const SizedBox(width: 16.0),

                          // SizedBox(
                          //   width: MediaQuery.of(context).size.width * 0.2,
                          //   height: MediaQuery.of(context).size.height * 0.06,
                          //   child: ElevatedButton(
                          //     style: TextButton.styleFrom(
                          //       backgroundColor: Pallete.secondButtonColor,
                          //       foregroundColor: Pallete.bottomTextColor,
                          //       shape: RoundedRectangleBorder(
                          //         borderRadius: BorderRadius.circular(10.0),
                          //         side: const BorderSide(color: Pallete.borderColor, width: 1),
                          //       ),
                          //     ),
                          //     onPressed: () {
                          //       Navigator.of(context).pop();
                          //       // Outra ação
                          //     },
                          //     child: const Text(
                          //       'Cancel',
                          //       style: TextStyle(
                          //         fontSize: 25.0,
                          //       ),
                          //     ),
                          //   ),
                          // ),
                        ],
                      ),

                    ],

                  );

                  if (kDebugMode) {
                    print('Botão register pressionado');
                  }

                  // Obtém o ID do dispositivo antes de navegar para a próxima tela
                  await getDeviceId();

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
                    ),
                  );

                  if (kDebugMode) {
                    print('Botão cancel pressionado');
                  }
                },
                child: const Text(
                  'Cancel',
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

            GestureDetector(
              onTap: () => _showSecurityQuestionMenu(context, false),
              child: PopupMenuButton<String>(
                color: Pallete.dropdownColor,
                // Usando constraints para garantir que a largura será 100% da tela
                constraints: BoxConstraints(
                  minWidth: MediaQuery.of(context).size.width * 0.9, // 90% da largura da tela
                ),
                onSelected: (String value) {
                  setState(() {
                    _selectedFirstSecurityQuestion = value;
                  });
                },
                itemBuilder: (BuildContext context) {
                  return _securityQuestions.map((String question) {
                    return PopupMenuItem<String>(
                      value: question,
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(13.0),
                        decoration: BoxDecoration(
                          color: Pallete.dropdownColor,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: Pallete.borderColor,
                            width: 1.0,
                          ),
                        ),

                        child: Text(
                          question,
                          style: const TextStyle(color: Pallete.backgroundTextColor),
                        ),

                      ),
                    );
                  }).toList();
                },
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.9, // 90% da largura da tela
                  height: MediaQuery.of(context).size.height * 0.06, // 6% da altura da tela
                  decoration: BoxDecoration(
                    color: Pallete.boxColor,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Pallete.borderColor,
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Text(
                          _selectedFirstSecurityQuestion ?? 'Security question',
                          style: const TextStyle(
                            color: Pallete.backgroundTextColor,
                          ),
                        ),
                      ),

                      Image.asset(
                        'assets/images/down_arrow_blue.png',
                        width: 36,
                        height: 36,
                        color: Pallete.iconColor,
                      ),

                    ],
                  ),
                ),
              ),
            ),

            // SizedBox(height: getHeight(context, 0.02)),

            SizedBox(
              width: MediaQuery.of(context).size.width * 0.9, // 90% da largura da tela
              height: MediaQuery.of(context).size.height * 0.06, // 6% da altura da tela
              child: LoginField(
                label: '',
                hintText: "First question's answer",
                isPasswordField: false,
                suffixIconImage: 'assets/images/write_blue.png',
                controller: _firstAnswerController,
              ),
            ),

            // SizedBox(height: getHeight(context, 0.02)),

            GestureDetector(
              onTap: () => _showSecurityQuestionMenu(context, false),
              child: PopupMenuButton<String>(
                color: Pallete.dropdownColor,
                // Usando constraints para garantir que a largura será 100% da tela
                constraints: BoxConstraints(
                  minWidth: MediaQuery.of(context).size.width * 0.9, // 90% da largura da tela
                ),
                onSelected: (String value) {
                  setState(() {
                    _selectedSecondSecurityQuestion = value;
                  });
                },
                itemBuilder: (BuildContext context) {
                  return _securityQuestions.map((String question) {
                    return PopupMenuItem<String>(
                      value: question,
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(13.0),
                        decoration: BoxDecoration(
                          color: Pallete.dropdownColor,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: Pallete.borderColor,
                            width: 1.0,
                          ),
                        ),

                        child: Text(
                          question,
                          style: const TextStyle(color: Pallete.backgroundTextColor),
                        ),
                        
                      ),
                    );
                  }).toList();
                },
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.9, // 90% da largura da tela
                  height: MediaQuery.of(context).size.height * 0.06, // 6% da altura da tela
                  decoration: BoxDecoration(
                    color: Pallete.boxColor,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Pallete.borderColor,
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Text(
                          _selectedSecondSecurityQuestion ?? 'Security question',
                          style: const TextStyle(
                            color: Pallete.backgroundTextColor,
                          ),
                        ),
                      ),

                      Image.asset(
                        'assets/images/down_arrow_blue.png',
                        width: 36,
                        height: 36,
                        color: Pallete.iconColor,
                      ),

                    ],
                  ),
                ),
              ),
            ),

            // SizedBox(height: getHeight(context, 0.02)),

            SizedBox(
              width: MediaQuery.of(context).size.width * 0.9, // 90% da largura da tela
              height: MediaQuery.of(context).size.height * 0.06, // 6% da altura da tela
              child: LoginField(
                label: '',
                hintText: "Second question's answer",
                isPasswordField: false,
                suffixIconImage: 'assets/images/write_blue.png',
                controller: _secondAnswerController,
              ),
            ),

            // SizedBox(height: getHeight(context, 0.076)),

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
                onPressed: () async {

                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) => const CrawlerInternalStorageScreen(),
                  //   ),
                  // );

                  showCustomPopup(
                    context: context,
                    title: 'Registered',
                    message: 'Thank you for registering.',
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
                                    builder: (context) => const CrawlerInternalStorageScreen(),
                                  ),
                                );
                              },
                              child: const Text(
                                'Ok',
                                style: TextStyle(
                                  fontSize: 25.0,
                                ),
                              ),
                            ),
                          ),

                          // const SizedBox(width: 16.0),

                          // SizedBox(
                          //   width: MediaQuery.of(context).size.width * 0.319,
                          //   height: MediaQuery.of(context).size.height * 0.06,
                          //   child: ElevatedButton(
                          //     style: TextButton.styleFrom(
                          //       backgroundColor: Pallete.secondButtonColor,
                          //       foregroundColor: Pallete.bottomTextColor,
                          //       shape: RoundedRectangleBorder(
                          //         borderRadius: BorderRadius.circular(10.0),
                          //         side: const BorderSide(color: Pallete.borderColor, width: 1),
                          //       ),
                          //     ),
                          //     onPressed: () {
                          //       Navigator.of(context).pop();
                          //       // Outra ação
                          //     },
                          //     child: const Text(
                          //       'Cancel',
                          //       style: TextStyle(
                          //         fontSize: 25.0,
                          //       ),
                          //     ),
                          //   ),
                          // ),
                        ],
                      ),

                    ],

                  );

                  if (kDebugMode) {
                    print('Botão register pressionado');
                  }

                  // Obtém o ID do dispositivo antes de navegar para a próxima tela
                  await getDeviceId();

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

            // SizedBox(height: getHeight(context, 0.02)),

            SizedBox(
              width: MediaQuery.of(context).size.width * 0.9, // 90% da largura da tela
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
                    ),
                  );
                  if (kDebugMode) {
                    print('Botão cancel pressionado');
                  }
                },
                child: const Text(
                  'Cancel',
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