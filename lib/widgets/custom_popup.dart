import 'package:flutter/material.dart';
import 'package:personal_power_cloud/theme/pallete.dart';

class CustomPopup extends StatelessWidget {
  final String title;
  final String message;
  final List<Widget> actions;
  final double? width; // Largura do popup
  // final double? height; // Altura do popup

  const CustomPopup({
    super.key,
    required this.title,
    required this.message,
    required this.actions,
    this.width,
    // this.height,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Pallete.boxColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
        side: const BorderSide(color: Pallete.borderColor, width: 1),
      ),
      content: SizedBox(
        width: width,
        // height: height,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            Text(
              title,
              style: const TextStyle(
                fontSize: 25, 
                fontWeight: FontWeight.bold,
                color: Pallete.userTextColor,
              ),
              textAlign: TextAlign.center,
            ),
            
            const SizedBox(height: 16), // Espaçamento entre o título e a mensagem

            Text(
              message,
              style: const TextStyle(
                fontSize: 20,
                color: Pallete.userTextColor,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 16), // Espaçamento entre o título e a mensagem

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: actions,
            ),

          ],
        ),
      ),
    );

  }

}
