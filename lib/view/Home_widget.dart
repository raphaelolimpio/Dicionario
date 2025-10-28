import 'package:dicionario/Config/model/Post_model.dart';
import 'package:dicionario/DS/Components/searchView/seachView.dart';
import 'package:flutter/material.dart';

class HomeWidget extends StatefulWidget {
  final void Function(PostModel)? onTermoSelected;
  const HomeWidget({Key? key, this.onTermoSelected}) : super(key: key);

  @override
  State<HomeWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> with TickerProviderStateMixin {
  String _searchTerm = "";

  @override
  void initState() {
    super.initState();
  }

  void _handleSearchSubmitted(String query) {
    setState(() {
      _searchTerm = query;
    });
    print("Busca submetida com: $query");
  }

  void _handleSuggestionSelected(PostModel termo) {
    setState(() {
      _searchTerm = "";
    });
    widget.onTermoSelected?.call(termo);
  }

  void _onSearchCleared() {
    setState(() {
      _searchTerm = "";
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              "Bem-Vindo ao Dicionário do Dev! ",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 15),
            const Text(
              "Pesquise seu Termo",
              style: TextStyle(fontSize: 18, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),

            Seachview(
              initialValue: _searchTerm,
              onSuggestionSelected: _handleSuggestionSelected,
              onSearchSubmitted: _handleSearchSubmitted,
              onSearchCleared: _onSearchCleared,
            ),
          ],
        ),
      ),
    );
  }
}
