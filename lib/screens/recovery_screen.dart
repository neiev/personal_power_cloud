import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:personal_power_cloud/theme/pallete.dart';
import 'package:personal_power_cloud/utils/screen_utils.dart';
import 'package:personal_power_cloud/widgets/navigation_buttons.dart';
import 'package:personal_power_cloud/screens/crawler_internal_storage_screen.dart';
import 'package:personal_power_cloud/screens/storage_screen.dart';

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
        body: SafeArea(
          child: SingleChildScrollView(
            child: Center(
              child: Column(
                children: [

                  // SizedBox(height: getHeight(context, 0.046)),

                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.9, // 90% da largura da tela
                    height: MediaQuery.of(context).size.height * 0.06, // 6% da altura da tela
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      decoration: BoxDecoration(
                        color: Pallete.boxColor,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Pallete.borderColor, width: 1),
                      ),
                      child: Row(
                        children: [
                          const Expanded(
                            child: TextField(
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
                            icon: Image.asset(
                              'assets/images/search_blue.png',
                              width: 36,
                              height: 36,
                            ),
                            onPressed: () {
                              // Implemente a lógica de pesquisa aqui
                              if (kDebugMode) {
                                print('Search button pressed');
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
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
