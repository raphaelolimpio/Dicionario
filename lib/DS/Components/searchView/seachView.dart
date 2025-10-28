import 'dart:async';
import 'package:dicionario/Config/model/Post_model.dart';
import 'package:dicionario/Service/topico_sevice.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class Seachview extends StatefulWidget {
  final void Function(PostModel suggestion) onSuggestionSelected;
  final void Function(String query) onSearchSubmitted;
  final VoidCallback onSearchCleared;
  final String initialValue;

  const Seachview({
    Key? key,
    required this.onSuggestionSelected,
    required this.onSearchSubmitted,
    required this.onSearchCleared,
    this.initialValue = "",
  }) : super(key: key);

  @override
  State<Seachview> createState() => _SearchViewState();
}

class _SearchViewState extends State<Seachview> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  Timer? _debounceTimer;
  bool _showClearButton = false;

  @override
  void initState() {
    super.initState();
    _controller.text = widget.initialValue;
    _showClearButton = _controller.text.isNotEmpty && _focusNode.hasFocus;
    _controller.addListener(_updateClearButtonVisibility);
    _focusNode.addListener(_updateClearButtonVisibility);
  }

  void _updateClearButtonVisibility() {
    if (mounted) {
      setState(() {
        _showClearButton = _controller.text.isNotEmpty && _focusNode.hasFocus;
      });
    }
  }

  void _submitSearch() {
    widget.onSearchSubmitted(_controller.text);
    _focusNode.unfocus();
  }

  @override
  void dispose() {
    _controller.removeListener(_updateClearButtonVisibility);
    _focusNode.removeListener(_updateClearButtonVisibility);
    _controller.dispose();
    _focusNode.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  Future<List<PostModel>> _fetchSuggestions(String query) async {
    _debounceTimer?.cancel();
    final completer = Completer<List<PostModel>>();
    _debounceTimer = Timer(const Duration(microseconds: 500), () async {
      if (query.isEmpty) {
        completer.complete([]);
        return;
      }
      try {
        final response = await TopicoSevice.getTopicos(nome: query);
        if (response.statusCode >= 200 &&
            response.statusCode < 300 &&
            response.data != null) {
          completer.complete(response.data!);
        } else {
          print("Erro ao Buscar Sugestões: ${response.statusCode}");
          completer.complete([]);
        }
      } catch (e) {
        print("Exceção ao buscar sugestão: $e");
        completer.completeError(e);
      }
    });
    return completer.future;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(
            child: TypeAheadField<PostModel>(
              controller: _controller,
              builder: (context, controller, focusNode) {
                final localFocusNode = _focusNode;
                return TextField(
                  controller: controller,
                  focusNode: localFocusNode,
                  decoration: InputDecoration(
                    labelText: "Buscar Termo",
                    hintText: "Digite o nome do Termo...",
                    prefixIcon: const Icon(Icons.search),
                    border: const OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue, width: 2.0),
                    ),
                    suffixIcon: _showClearButton
                    ? IconButton(
                      icon: const Icon(Icons.clear, color: Colors.black),
                      tooltip: "Limpar busca",
                      onPressed: () {
                        controller.clear();
                        widget.onSearchCleared();
                      },
                    )
                    : null,
                  ),
                  onSubmitted: (_) => _submitSearch(),
                );
              },
              suggestionsCallback: _fetchSuggestions,
              itemBuilder: (context, suggestion) {
                return ListTile(
                  title: Text(suggestion.nome ?? "Sem Nome"),
                  subtitle: Text(suggestion.topico),
                );
              },
              onSelected: (suggestion) {
                _controller.clear();
                _focusNode.unfocus();
                widget.onSearchSubmitted("");
                widget.onSuggestionSelected(suggestion);
              },
              emptyBuilder: (context) {
                return _focusNode.hasFocus && _controller.text.isNotEmpty
                    ? const Padding(
                        padding: EdgeInsets.all(12.0),
                        child: Text("Nenhuma sugestão encontrada."),
                      )
                    : const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }
}
