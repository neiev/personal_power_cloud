import 'package:flutter/material.dart';
import 'package:personal_power_cloud/theme/pallete.dart';
import 'package:personal_power_cloud/screens/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    // Inicializa o AnimationController
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300), // Duração da animação
    );

    // Define a animação de escala
    _scaleAnimation = Tween<double>(begin: 1.0, end: 2.0).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut, // Curva da animação
    ));

    // Define a animação de opacidade
    _fadeAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

    // Atraso de 1 segundo antes de iniciar a animação
    Future.delayed(const Duration(seconds: 1), () {
      _controller.forward(); // Inicia a animação
    });

    // Aguarda a animação terminar antes de ir para a tela de login
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Future.delayed(const Duration(milliseconds: 800), () {
          // ignore: use_build_context_synchronously
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const LoginScreen()), // Navega para a LoginScreen
          );
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose(); // Libera o AnimationController
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Pallete.backgroundColor, // Cor de fundo
      body: SafeArea( // Envolve o conteúdo no SafeArea
        child: Center(
          child: FadeTransition(
            opacity: _fadeAnimation, // Aplica a animação de opacidade
            child: ScaleTransition(
              scale: _scaleAnimation, // Aplica a animação de escala
              child: Image.asset(
                'assets/images/personal_power_cloud_giant.png', // Caminho do seu logo
                width: MediaQuery.of(context).size.width * 0.8, // 80% da largura da tela
                height: MediaQuery.of(context).size.height * 0.5, // 50% da altura da tela
              ),
            ),
          ),
        ),
      ),
    );
  }

}
