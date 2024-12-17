import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:personal_power_cloud/theme/pallete.dart';

class SearchBar extends StatefulWidget {
  const SearchBar({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  String _searchQuery = ''; // Estado interno do campo de busca.

  void _onSearchQueryChanged(String query) {
    setState(() {
      _searchQuery = query;
    });
    if (kDebugMode) {
      print('Texto alterado: $_searchQuery');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.9, // 90% da largura da tela
      height: MediaQuery.of(context).size.height * 0.06, // 6% da altura da tela
      child: Container(
        decoration: BoxDecoration(
          color: Pallete.boxColor,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: Pallete.borderColor,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 10),
                child: TextField(
                  onChanged: _onSearchQueryChanged,
                  style: const TextStyle(color: Pallete.userTextColor),
                  decoration: InputDecoration(
                    hintText: 'Search',
                    hintStyle: const TextStyle(color: Pallete.backgroundTextColor),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height * 0.02,),
                  ),
                ),
              ),
            ),
            IconButton(
              icon: Image.asset('assets/images/search_blue.png'),
              onPressed: () {
                if (kDebugMode) {
                  print('Botão search button pressionado');
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
