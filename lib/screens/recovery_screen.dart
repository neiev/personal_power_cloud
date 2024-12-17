import 'package:flutter/material.dart';
import 'package:personal_power_cloud/theme/pallete.dart';
import 'package:personal_power_cloud/utils/screen_utils.dart';
import 'package:personal_power_cloud/widgets/navigation_buttons.dart';
import 'package:personal_power_cloud/screens/crawler_internal_storage_screen.dart';
import 'package:personal_power_cloud/screens/storage_screen.dart';
import 'package:personal_power_cloud/widgets/search_bar.dart' as custom;

class RecoveryScreen extends StatelessWidget {
  const RecoveryScreen({super.key});

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
      onWillPop: () => _onWillPop(context), // Vincula o método _onWillPop
      child: Scaffold(
        backgroundColor: Pallete.backgroundColor,
        body: const SafeArea(
          child: SingleChildScrollView(
            child: Center(
              child: Column(
                children: [

                  // SizedBox(height: getHeight(context, 0.046)),

                  custom.SearchBar(), // Apenas insere o widget.

                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: buildBottomNavigationBar(
          context,
          '',
          'recovery',
          () => navigateToScreen(const CrawlerInternalStorageScreen(), context),
          null,
        ),
      ),
    );
  }

}
