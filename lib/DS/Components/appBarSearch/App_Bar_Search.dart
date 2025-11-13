import 'package:dicionario/Config/model/Post_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class AppBarSearch extends StatefulWidget {
  final Future<List<PostModel>> Function(String query) onSuggestionSearch;
  final void Function(PostModel suggestion) onSuggestionSelected;
  final void Function(String query) onSearchSubmitted;
  final VoidCallback onSearchCleared;
  final String initialValue;
  final void Function(bool isExpanded)? onExpansionChanged;

  const AppBarSearch({
    Key? key,
    required this.onSuggestionSearch,
    required this.onSuggestionSelected,
    required this.onSearchSubmitted,
    required this.onSearchCleared,
    this.initialValue = "",
    this.onExpansionChanged,
  }) : super(key: key);

  @override
  State<AppBarSearch> createState() => _AppBarSearchState();
}

class _AppBarSearchState extends State<AppBarSearch> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _controller.text = widget.initialValue;
    _focusNode.addListener(_handleFocusChange);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_handleFocusChange);
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _handleFocusChange() {
    if (!_focusNode.hasFocus && _isExpanded) {
      setState(() {
        _isExpanded = false;
      });
    }
  }

  void _submitSearch() {
    widget.onSearchSubmitted(_controller.text);
    _focusNode.unfocus();
  }

  void _setExpanded(bool isExpanded) {
    setState(() {
      _isExpanded = isExpanded;
    });
    widget.onExpansionChanged?.call(isExpanded);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    if (!_isExpanded) {
      return 
      IconButton(
        icon: Icon(Icons.search, color: theme.primaryColorDark),
        iconSize: 25,
        onPressed: () {
          _setExpanded(true);
          Future.delayed(const Duration(microseconds: 100), () {
            _focusNode.requestFocus();
          });
        },
      );
    }
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(right: 8.0, left: 16.0),
        child: TypeAheadField<PostModel>(
          controller: _controller,
          focusNode: _focusNode,
          builder: (context, controller, focusNode) {
            return TextField(
              controller: controller,
              focusNode: focusNode,
              autofocus: true,
              decoration: InputDecoration(
                filled: true,
                fillColor: theme.shadowColor.withOpacity(0.12),
                hintText: 'Buscar termo...',
                hintStyle: TextStyle(
                  color: theme.primaryColorDark.withOpacity(0.7),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: theme.primaryColorDark,
                    width: 1,
                  ),
                ),
                suffixIcon: IconButton(
                  icon: Icon(Icons.clear, color: theme.primaryColorDark),
                  onPressed: () {
                    controller.clear();
                    widget.onSearchCleared();
                    _setExpanded(false);
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
            _controller.clear();
            _setExpanded(false);
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
