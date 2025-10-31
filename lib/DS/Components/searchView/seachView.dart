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

  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    _controller.text = widget.initialValue;
  }

  void _submitSearch() {
    widget.onSearchSubmitted(_controller.text);
    FocusScope.of(context).unfocus();
  }


  @override
  void dispose() {

    _controller.dispose();

    _debounceTimer?.cancel();
    super.dispose();
  }

  Future<List<PostModel>> _fetchSuggestions(String query) async {
    _debounceTimer?.cancel();
    final completer = Completer<List<PostModel>>();
    _debounceTimer = Timer(const Duration(milliseconds: 500), () async {
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

                return TextField(
                  controller: controller,
                  focusNode: focusNode,
                  decoration: InputDecoration(
                    labelText: "Buscar Termo",
                    hintText: "Digite o nome do Termo...",
                    prefixIcon: const Icon(Icons.search),
                    border: const OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue, width: 2.0),
                    ),
                    suffixIcon: controller.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear, color: Colors.black),
                            tooltip: "limpar busca",
                            onPressed: () {
                              controller.clear();
                              widget.onSearchCleared();
                              focusNode.unfocus();
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
                FocusScope.of(context).unfocus();
                widget.onSearchSubmitted("");
                widget.onSuggestionSelected(suggestion);
              },
              emptyBuilder: (context) {
                final currentFocusNode = FocusScope.of(context).focusedChild;
                final hasFocus = currentFocusNode != null && currentFocusNode is FocusNode && currentFocusNode == FocusScope.of(context).focusedChild;
                return hasFocus && _controller.text.isNotEmpty
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
