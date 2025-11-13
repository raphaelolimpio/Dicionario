import 'package:dicionario/Config/model/Post_model.dart';
import 'package:dicionario/DS/Components/searchView/seachView.dart';
import 'package:flutter/material.dart';

class HomeWidget extends StatefulWidget {
  final void Function(PostModel)? onTermoSelected;
  const HomeWidget({Key? key, this.onTermoSelected}) : super(key: key);

  @override
  State<HomeWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
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
    final textTheme = Theme.of(context).textTheme;
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
           
            const SizedBox(height:100),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                 Text(
              "Bem-Vindo ao",
              style: textTheme.headlineMedium?.copyWith(fontSize: 30),
              textAlign: TextAlign.center,
            ),
            Text(
              "Dicionário do Dev.",
              style: textTheme.bodySmall?.copyWith(fontSize: 30),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20.0,),
            
            Seachview(
              initialValue: _searchTerm,
              onSuggestionSelected: _handleSuggestionSelected,
              onSearchSubmitted: _handleSearchSubmitted,
              onSearchCleared: _onSearchCleared,

            ), 
            const SizedBox(height: 20.0),
             Text(
              "Explore o vocabulário do mundo DEV.",
              style: textTheme.bodyLarge?.copyWith(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
              ],
            ),

            
          ],
        ),
      ),
    );
  }
}
