import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:personal_power_cloud/theme/pallete.dart';
import 'package:personal_power_cloud/utils/screen_utils.dart';
import 'package:personal_power_cloud/widgets/login_field.dart';
import 'package:personal_power_cloud/screens/login_screen.dart';
import 'package:personal_power_cloud/widgets/custom_popup.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();

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
      MaterialPageRoute(builder: (context) => const LoginScreen()),
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
        
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.3, // 30% da largura da tela
              height: MediaQuery.of(context).size.height * 0.06, // 6% da altura da tela
              child: LoginField(
                hintText: 'Email',
                isPasswordField: false,
                suffixIconImage: 'assets/images/email.png',
                // padding: const EdgeInsets.symmetric(horizontal: 16.0),
                label: '',
                controller: _emailController,
                // controller: TextEditingController(),
              ),
            ),
        
            // SizedBox(height: getHeight(context, 0.25)),
        
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.3, // 30% da largura da tela
              height: MediaQuery.of(context).size.height * 0.06, // 6% da altura da tela
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Pallete.firstButtonColor,
                  // padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: const BorderSide(color: Pallete.borderColor, width: 1),
                  ),
                ),
                onPressed: () {

                  showCustomPopup(
                    context: context,
                    title: 'Send email',
                    message: 'We will send a link to the email requesting it, where it will be possible to reset the password.',
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
                                    builder: (context) => const LoginScreen(),
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
                                'Cancel',
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
                    print('Botão send pressionado');
                  }
                },
                child: const Text(
                  'Send',
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
                      builder: (context) => const LoginScreen(),
                    ));
        
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

            SizedBox(
              width: MediaQuery.of(context).size.width * 0.9, // 90% da largura da tela
              height: MediaQuery.of(context).size.height * 0.06, // 6% da altura da tela
              child: LoginField(
                hintText: 'Email',
                isPasswordField: false,
                suffixIconImage: 'assets/images/email.png',
                // padding: const EdgeInsets.symmetric(horizontal: 16.0),
                label: '',
                controller: _emailController,
                // controller: TextEditingController(),
              ),
            ),

            // SizedBox(height: getHeight(context, 0.25)),

            SizedBox(
              width: MediaQuery.of(context).size.width * 0.9, // 90% da largura da tela
              height: MediaQuery.of(context).size.height * 0.06, // 6% da altura da tela
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Pallete.firstButtonColor,
                  // padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: const BorderSide(color: Pallete.borderColor, width: 1),
                  ),
                ),
                onPressed: () {

                  showCustomPopup(
                    context: context,
                    title: 'Send email',
                    message: 'We will send a link to the email requesting it, where it will be possible to reset the password.',
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
                                    builder: (context) => const LoginScreen(),
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
                                'Cancel',
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
                    print('Botão send pressionado');
                  }
                },
                child: const Text(
                  'Send',
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
                  backgroundColor: Pallete.secondButtonColor, // Ajuste de cor conforme seu tema
                  // padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: const BorderSide(color: Pallete.borderColor, width: 1), // Adicionada a borda
                  ),
                ),
                onPressed: () {

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginScreen(),
                    ));

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