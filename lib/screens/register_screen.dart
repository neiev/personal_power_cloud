import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:personal_power_cloud/screens/login_screen.dart';
import 'package:personal_power_cloud/screens/next_screen.dart';
import 'package:personal_power_cloud/theme/pallete.dart';
import 'package:personal_power_cloud/utils/screen_utils.dart';
import 'package:personal_power_cloud/widgets/login_field.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

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
                // padding: const EdgeInsets.symmetric(horizontal: 16.0),
                label: '',
                hintText: 'Name',
                isPasswordField: false,
                suffixIconImage: 'assets/images/user_blue.png',
                controller: TextEditingController(),
              ),
            ),

            // SizedBox(height: getHeight(context, 0.02)),

            SizedBox(
              width: MediaQuery.of(context).size.width * 0.3, // 30% da largura da tela
              height: MediaQuery.of(context).size.height * 0.06, // 6% da altura da tela
              child: LoginField(
                // padding: const EdgeInsets.symmetric(horizontal: 16.0),
                label: '',
                hintText: 'Email',
                isPasswordField: false,
                suffixIconImage: 'assets/images/email.png',
                controller: TextEditingController(),
              ),
            ),

            // SizedBox(height: getHeight(context, 0.02)),

            SizedBox(
              width: MediaQuery.of(context).size.width * 0.3, // 30% da largura da tela
              height: MediaQuery.of(context).size.height * 0.06, // 6% da altura da tela
              child: LoginField(
                // padding: const EdgeInsets.symmetric(horizontal: 16.0),
                label: '',
                hintText: 'Password',
                isPasswordField: true,
                suffixIconImage: 'assets/images/eye_close_blue.png',
                suffixIconVisibleImage: 'assets/images/eye_open_blue.png',
                controller: TextEditingController(),
              ),
            ),

            // SizedBox(height: getHeight(context, 0.02)),

            SizedBox(
              width: MediaQuery.of(context).size.width * 0.3, // 30% da largura da tela
              height: MediaQuery.of(context).size.height * 0.06, // 6% da altura da tela
              child: LoginField(
                // padding: const EdgeInsets.symmetric(horizontal: 16.0),
                label: '',
                hintText: 'Confirm Password',
                isPasswordField: true,
                suffixIconImage: 'assets/images/eye_close_blue.png',
                suffixIconVisibleImage: 'assets/images/eye_open_blue.png',
                controller: TextEditingController(),
              ),
            ),

            // SizedBox(height: getHeight(context, 0.08)),

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

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const NextScreen(),
                    )
                  );

                  if (kDebugMode) {
                    print('Botão de register pressionado');
                  }
                },
                child: const Text(
                  'Next',
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
                    )
                  );

                  if (kDebugMode) {
                    print('Botão de cancel pressionado');
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
                // padding: const EdgeInsets.symmetric(horizontal: 16.0),
                label: '',
                hintText: 'Name',
                isPasswordField: false,
                suffixIconImage: 'assets/images/user_blue.png',
                controller: TextEditingController(),
              ),
            ),

            // SizedBox(height: getHeight(context, 0.02)),

            SizedBox(
              width: MediaQuery.of(context).size.width * 0.9, // 90% da largura da tela
              height: MediaQuery.of(context).size.height * 0.06, // 6% da altura da tela
              child: LoginField(
                // padding: const EdgeInsets.symmetric(horizontal: 16.0),
                label: '',
                hintText: 'Email',
                isPasswordField: false,
                suffixIconImage: 'assets/images/email.png',
                controller: TextEditingController(),
              ),
            ),

            // SizedBox(height: getHeight(context, 0.02)),

            SizedBox(
              width: MediaQuery.of(context).size.width * 0.9, // 90% da largura da tela
              height: MediaQuery.of(context).size.height * 0.06, // 6% da altura da tela
              child: LoginField(
                // padding: const EdgeInsets.symmetric(horizontal: 16.0),
                label: '',
                hintText: 'Password',
                isPasswordField: true,
                suffixIconImage: 'assets/images/eye_close_blue.png',
                suffixIconVisibleImage: 'assets/images/eye_open_blue.png',
                controller: TextEditingController(),
              ),
            ),

            // SizedBox(height: getHeight(context, 0.02)),

            SizedBox(
              width: MediaQuery.of(context).size.width * 0.9, // 90% da largura da tela
              height: MediaQuery.of(context).size.height * 0.06, // 6% da altura da tela
              child: LoginField(
                // padding: const EdgeInsets.symmetric(horizontal: 16.0),
                label: '',
                hintText: 'Confirm Password',
                isPasswordField: true,
                suffixIconImage: 'assets/images/eye_close_blue.png',
                suffixIconVisibleImage: 'assets/images/eye_open_blue.png',
                controller: TextEditingController(),
              ),
            ),

            // SizedBox(height: getHeight(context, 0.08)),

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

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const NextScreen(),
                    )
                  );

                  if (kDebugMode) {
                    print('Botão next pressionado');
                  }
                },
                child: const Text(
                  'Next',
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
                      builder: (context) => const LoginScreen(),
                    )
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