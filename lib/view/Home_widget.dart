import 'package:dicionario/Config/model/Post_model.dart';
import 'package:dicionario/Config/server/Api_service.dart';
import 'package:dicionario/DS/Components/Card/BaseCard/Card_enum.dart';
import 'package:dicionario/DS/Components/Card/ListCard/List_card_custom.dart';
import 'package:dicionario/DS/Components/Card/model/card_custom/Card_custom_view_model.dart';
import 'package:dicionario/DS/Components/Icons/Icon_view_Model.dart';
import 'package:dicionario/Service/topico_sevice.dart';
import 'package:flutter/material.dart';

class HomeWidget extends StatefulWidget {
  final void Function(PostModel)? onTermoSelected;
  const HomeWidget({Key? key, this.onTermoSelected}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> with TickerProviderStateMixin {
  late Future<ApiResponse<List<PostModel>>> _TermosFuture;
  late Future<ApiResponse<List<String>>> _TopicoFuture;
  String? _selectedTopico;

  @override
  void initState() {
    super.initState();
    _fetchTermo();
    _TopicoFuture = TopicoSevice.getAllTopico();
  }

  void _fetchTermo() {
    setState(() {
      _TermosFuture = TopicoSevice.getTopicos(
        topico: _selectedTopico 
      );
    });
  }

  List<CardCustomViewModel> _mapPostsToCardViewModels(List<PostModel> posts) {
    return posts.map((post) {
      return CardCustomViewModel(
        id: post.id,
        topico: post.topico,
        nome: post.nome ?? "sem nome",
        categoria: post.categoria ?? "sem nome",
        definicao: post.definicao ?? "sem nome",
        comando_exemplo: post.comando_exemplo ?? "",
        explicacao_pratica: post.explicacao_pratica ?? "sem nome",
        dicas_de_uso: post.dicas_de_uso ?? "",
        buttonText: 'Detalhes',
        onButtonPressed: (context) {
          if (widget.onTermoSelected != null) {
            widget.onTermoSelected!(post);
          }
        },
        topicoIcon: IconViewModel(
          icon: IconType.fixed,
          color: colorType.darkblue,
          size: IconSize.medium,
        ),
        categorIcon: IconViewModel(
          icon: IconType.folder,
          color: colorType.yellow,
          size: IconSize.medium,
        ),
        definicaoIcon: IconViewModel(
          icon: IconType.definition,
          color: colorType.pink,
          size: IconSize.medium,
        ),
        comandoExemploIcon: IconViewModel(
          icon: IconType.bash,
          color: colorType.green,
          size: IconSize.medium,
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: FutureBuilder<ApiResponse<List<String>>>(
            future: _TopicoFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError ||
                  !snapshot.hasData ||
                  snapshot.data!.data == null) {
                return const Text('Não foi possível carregar categorias.');
              } else {
                final categories = ['Todas', ...snapshot.data!.data!];
                return DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'Filtrar por Categoria',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                  ),
                  value: _selectedTopico ?? 'Todas',
                  items: categories.map((String category) {
                    return DropdownMenuItem<String>(
                      value: category,
                      child: Text(category),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedTopico = newValue;
                      _fetchTermo();
                    });
                  },
                );
              }
            },
          ),
        ),
        const Divider(height: 20, thickness: 1),
        Expanded(
          child: FutureBuilder<ApiResponse<List<PostModel>>>(
            future: _TermosFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(
                  child: Text(
                    'Erro ao carregar produtos: ${snapshot.error}',
                    textAlign: TextAlign.center,
                  ),
                );
              } else if (snapshot.hasData) {
                final apiResponse = snapshot.data!;
                if (apiResponse.statusCode >= 200 &&
                    apiResponse.statusCode < 300 &&
                    apiResponse.data != null) {
                  final List<PostModel> termo = apiResponse.data!;
                  if (termo.isEmpty) {
                    return const Center(
                      child: Text(
                        'Nenhum produto encontrado para esta categoria.',
                      ),
                    );
                  }
                  final List<CardCustomViewModel> cardViewModels =
                      _mapPostsToCardViewModels(termo);
                  return ListCard(
                    cards: cardViewModels,
                    cardModelType: CardModelType.cardCustom,
                    displayMode: CardDisplayMode.verticalList,
                    listHeight: 400,
                  );
                } else {
                  return Center(
                    child: Text(
                      'Falha na API: ${apiResponse.statusCode} - $apiResponse',
                      textAlign: TextAlign.center,
                    ),
                  );
                }
              }
              return const Center(child: Text('Carregando...'));
            },
          ),
        ),
      ],
    );
  }
}
