import 'package:dicionario/Config/model/Post_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class AppBarSearch extends StatefulWidget {
  final Future<List<PostModel>> Function(String query) onSuggestionSearch;
  final void Function(PostModel suggestion) onSuggestionSelected;
  final void Function(String query) onSearchSubmitted;
  final VoidCallback onSearchCleared;
  final String initialValue;

  const AppBarSearch({
    Key? key,
    required this.onSuggestionSearch,
    required this.onSuggestionSelected,
    required this.onSearchSubmitted,
    required this.onSearchCleared,
    this.initialValue = "",
  }) : super(key: key);

  @override
  State<AppBarSearch> createState() => _AppBarSearchState();
}

class _AppBarSearchState extends State<AppBarSearch> {
  final TextEditingController _controller = TextEditingController();
  bool _isExpanded = false;


  @override
  void initState() {
    super.initState();
    _controller.text = widget.initialValue;
    
  }

  void _submitSearch() {
    widget.onSearchSubmitted(_controller.text);
    setState(()=> _isExpanded = false);
  }

  @override
  Widget build(BuildContext context) {
    if (!_isExpanded) {
      return IconButton(
        icon: const Icon(Icons.search),
        onPressed: () => setState(() => _isExpanded = true),
      );
    }

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(right: 8.0, left: 16.0),
        child: TypeAheadField<PostModel>(
          controller: _controller,
          builder: (context, controller, focusNode) {
            return TextField(
              controller: controller,
              focusNode: focusNode,
              autofocus: true,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Buscar termo...',
                hintStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
                border: InputBorder.none,
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear, color: Colors.white),
                  onPressed: () {
                    controller.clear();
                    widget.onSearchCleared();
                    setState(() => _isExpanded = false);
                  },
                ),
              ),
              onSubmitted: (_) => _submitSearch(),
            );
          },
          suggestionsCallback: widget.onSuggestionSearch,
          itemBuilder: (context, suggestion) {
            return ListTile(
              title: Text(suggestion.nome ?? ''),
              subtitle: Text(suggestion.topico),
            );
          },
          onSelected: (suggestion) {
            widget.onSuggestionSelected(suggestion);
          },
          emptyBuilder: (context) {
            return const Padding(
              padding: EdgeInsets.all(12.0),
              child: Text('Nenhum termo encontrado.'),
            );
          },
        ),
      ),
    );
  }
}
