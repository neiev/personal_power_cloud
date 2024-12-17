import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:personal_power_cloud/screens/trash_screen.dart';
import 'package:personal_power_cloud/widgets/custom_popup.dart';
import 'package:provider/provider.dart';
import 'package:personal_power_cloud/providers/auth_provider.dart';
import 'package:personal_power_cloud/screens/login_screen.dart';
import 'package:personal_power_cloud/theme/pallete.dart';
import 'package:personal_power_cloud/utils/screen_utils.dart';
import 'package:personal_power_cloud/widgets/navigation_buttons.dart';
import 'package:personal_power_cloud/screens/crawler_internal_storage_screen.dart';
import 'package:personal_power_cloud/widgets/search_bar.dart' as custom;

class LogoutScreen extends StatelessWidget {
  const LogoutScreen({super.key});

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
      MaterialPageRoute(builder: (context) => const TrashScreen()),
    );
    return false; // Retorne false para evitar que a tela atual seja removida da pilha
  }

  @override
  Widget build(BuildContext context) {
    final email = Provider.of<AuthProvider>(context).email;
    final password = Provider.of<AuthProvider>(context).password;
    TextEditingController searchController = TextEditingController();
    TextEditingController nameController = TextEditingController();
    final TextEditingController emailController = TextEditingController(text: email);
    final TextEditingController passwordController = TextEditingController(text: password);

    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () => _onWillPop(context), // Vincula o método _onWillPop
      child: Scaffold(
        backgroundColor: Pallete.backgroundColor,
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth > 800) {
                // Layout para telas grandes (Desktop e Web)
                return _buildWideLayout(context, searchController, nameController, emailController, passwordController);
              } else {
                // Layout para telas pequenas (Celulares)
                return _buildNarrowLayout(context, searchController, nameController, emailController, passwordController);
              }
            },
          ),
        ),
        bottomNavigationBar: buildBottomNavigationBar(
          context,
          '',
          'logout',
          () => navigateToScreen(const CrawlerInternalStorageScreen(), context),
          null,
        ),
      ),
    );
  }

  Widget _buildWideLayout(
    BuildContext context, 
    TextEditingController searchController, 
    TextEditingController nameController, 
    TextEditingController emailController, 
    TextEditingController passwordController
  ) {
    return SingleChildScrollView(
      child: Center(
        child: Column(
          children: [

            // SizedBox(height: getHeight(context, 0.046)),

            const custom.SearchBar(), // Apenas insere o widget.

            // SizedBox(height: getHeight(context, 0.30)),

            SizedBox(
              width: MediaQuery.of(context).size.width * 0.3,
              height: MediaQuery.of(context).size.height * 0.06,
              child: _buildSearchBar(
                context,
                'Name',
                'assets/images/user_blue.png',
                () {
                  if (kDebugMode) {
                    print('Botão user pressionado');
                  }
                  // Implementar lógica de pesquisa para a barra 2
                },
                nameController,
              ),
            ),

            // SizedBox(height: getHeight(context, 0.02)),

            SizedBox(
              width: MediaQuery.of(context).size.width * 0.3, 
              height: MediaQuery.of(context).size.height * 0.06,
              child: _buildSearchBar(
                context,
                emailController.text.isEmpty ? 'Email' : emailController.text,
                'assets/images/email.png',
                () {
                  if (kDebugMode) {
                    print('Botão email pressionado');
                  }
                  // Implementar lógica de pesquisa para a barra 3
                },
                emailController,
              ),
            ),

            // SizedBox(height: getHeight(context, 0.02)),

            SizedBox(
              width: MediaQuery.of(context).size.width * 0.3, 
              height: MediaQuery.of(context).size.height * 0.06,
              child: _buildSearchBar(
                context,
                'Password',
                'assets/images/eye_close_blue.png',
                () {
                  if (kDebugMode) {
                    print('Botão eye pressionado');
                    // _passwordController;
                  }
                  // Implementar lógica de pesquisa para a barra 4
                },
                passwordController,
                isPasswordField: true, // Adicione esta linha
              ),
            ),

            // SizedBox(height: getHeight(context, 0.10)),

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
                    title: 'Logout',
                    message: 'Are you sure you would like to log out of our system?',
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

                },

                child: const Text(
                  'Logout',
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

  Widget _buildNarrowLayout(
    BuildContext context, 
    TextEditingController searchController, 
    TextEditingController nameController, 
    TextEditingController emailController, 
    TextEditingController passwordController
  ) {
    return SingleChildScrollView(
      child: Center(
        child: Column(
          children: [

            // SizedBox(height: getHeight(context, 0.046)),

            const custom.SearchBar(), // Apenas insere o widget.

            // SizedBox(height: getHeight(context, 0.30)),

            SizedBox(
              width: MediaQuery.of(context).size.width * 0.9,
              height: MediaQuery.of(context).size.height * 0.06,
              child: _buildSearchBar(
                context,
                'Name',
                'assets/images/user_blue.png',
                () {
                  if (kDebugMode) {
                    print('Botão user pressionado');
                  }
                  // Implementar lógica de pesquisa para a barra 2
                },
                nameController,
              ),
            ),

            // SizedBox(height: getHeight(context, 0.02)),

            SizedBox(
              width: MediaQuery.of(context).size.width * 0.9,
              height: MediaQuery.of(context).size.height * 0.06,
              child: _buildSearchBar(
                context,
                emailController.text.isEmpty ? 'Email' : emailController.text,
                'assets/images/email.png',
                () {
                  if (kDebugMode) {
                    print('Botão email pressionado');
                  }
                  // Implementar lógica de pesquisa para a barra 3
                },
                emailController,
              ),
            ),

            // SizedBox(height: getHeight(context, 0.02)),

            SizedBox(
              width: MediaQuery.of(context).size.width * 0.9,
              height: MediaQuery.of(context).size.height * 0.06,
              child: _buildSearchBar(
                context,
                'Password',
                'assets/images/eye_close_blue.png',
                () {
                  if (kDebugMode) {
                    print('Botão eye pressionado');
                  }
                  // Implementar lógica de pesquisa para a barra 4
                },
                passwordController,
                isPasswordField: true, // Adicione esta linha
              ),
            ),

            // SizedBox(height: getHeight(context, 0.10)),

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
                    title: 'Logout',
                    message: 'Are you sure you would like to log out of our system?',
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

                },

                child: const Text(
                  'Logout',
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

  // Função auxiliar para construir uma barra de pesquisa independente
  Widget _buildSearchBar(
    BuildContext context,
    String hintText,
    String imagePath,
    VoidCallback onPressed,
    TextEditingController controller,
    {bool isPasswordField = false} // Adicione esta linha
  ) {
    return SizedBox(
      child: Container(
        // padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
        decoration: BoxDecoration(
          color: Pallete.boxColor,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Pallete.borderColor, width: 1),
        ),
        child: Row(
          children: [
            Expanded(
              child: TextField(
              // child: TextFormField(
                controller: controller,
                textAlignVertical: TextAlignVertical.center, // Centraliza o texto verticalmente
                style: const TextStyle(
                  color: Pallete.userTextColor, // Defina a cor do texto aqui
                ),
                obscureText: isPasswordField, // Adicione esta linha
                decoration: InputDecoration(
                  hintText: hintText,
                  border: InputBorder.none,
                  hintStyle: const TextStyle(
                    color: Pallete.backgroundTextColor,
                    fontSize: 20,
                  ),
                ),
                enabled: false, // Desabilita o campo de entrada
              ),
            ),
            Image.asset(
              imagePath,
              width: 36,
              height: 36,
            ),
          ],
        ),
      ),
    );

  }
}