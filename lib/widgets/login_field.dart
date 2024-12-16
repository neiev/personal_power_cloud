import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:personal_power_cloud/theme/pallete.dart';

class LoginField extends StatefulWidget {
  final String hintText;
  final TextEditingController controller;
  final bool isPasswordField;
  final String suffixIconImage;
  final String? suffixIconVisibleImage;
  final String label;

  const LoginField({
    super.key,
    required this.hintText,
    required this.controller,
    required this.isPasswordField,
    required this.suffixIconImage,
    this.suffixIconVisibleImage,
    required this.label,
  });

  @override
  // ignore: library_private_types_in_public_api
  _LoginFieldState createState() => _LoginFieldState();
}

class _LoginFieldState extends State<LoginField> {
  bool _obscureText = true;

  void _togglePasswordView() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: widget.isPasswordField ? _obscureText : false,
      textAlignVertical: TextAlignVertical.center, // Centraliza o texto verticalmente
      style: const TextStyle(
        color: Pallete.userTextColor, // Defina a cor do texto aqui
      ),
      decoration: InputDecoration(
        hintText: widget.hintText,
        hintStyle: const TextStyle(
          color: Pallete.backgroundTextColor, // Defina a cor do texto de dica aqui
        ),
        suffixIcon: widget.isPasswordField
          ? IconButton(
              icon: Image.asset(
                _obscureText ? widget.suffixIconImage : widget.suffixIconVisibleImage ?? widget.suffixIconImage,
                width: 36,
                height: 36,
              ),
              onPressed: _togglePasswordView,
            )
          : Image.asset(
              widget.suffixIconImage,
              width: 36, // Defina a largura do ícone
              height: 36, // Defina a altura do ícone
            ),
        filled: true,
        fillColor: Pallete.boxColor,
        border: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Pallete.borderColor,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Pallete.borderColor,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Pallete.borderColor,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      onChanged: (value) {
        if (kDebugMode) {
          print('Valor digitado: $value');
        }
      },
    );
  }
}
