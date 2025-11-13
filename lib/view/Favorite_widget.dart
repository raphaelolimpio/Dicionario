import 'package:dicionario/Config/model/Post_model.dart';
import 'package:dicionario/DS/Components/Card/BaseCard/Card_enum.dart';
import 'package:dicionario/DS/Components/Card/ListCard/List_card_custom.dart';
import 'package:dicionario/DS/Components/Card/model/card_custom3/Card_custom3_view_model.dart';
import 'package:dicionario/DS/Components/Icons/Icon_view_Model.dart';
import 'package:dicionario/Service/favorite_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FavorictWidget extends StatefulWidget {
  final void Function(PostModel)? onTermoSelected;
  const FavorictWidget({Key? key, this.onTermoSelected}) : super(key: key);

  @override
  State<FavorictWidget> createState() => _FavorictWidgetState();
}

class _FavorictWidgetState extends State<FavorictWidget> {
  String? _selectedTopico;
  static const String _allTopicsValue = "Todos";

  List<CardCustom3ViewModel> _mapPostsToCardViewModels(List<PostModel> posts) {
    return posts.map((post) {
      return CardCustom3ViewModel(
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
    final favoriteService = context.watch<FavoriteService>();
    final List<PostModel> allFavorites = favoriteService.favorites;
    final topicSet = allFavorites.map((post) => post.topico).toSet();
    final List<String> dropdownTopics = [
      _allTopicsValue,
      ...topicSet.toList()..sort(),
    ];
    if (_selectedTopico != null &&
        _selectedTopico != _allTopicsValue &&
        !topicSet.contains(_selectedTopico)) {
      _selectedTopico = _allTopicsValue;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() {
            _selectedTopico = _allTopicsValue;
          });
        }
      });
    }
    final List<PostModel> filteredFavorites =
        (_selectedTopico == null || _selectedTopico == _allTopicsValue)
        ? allFavorites
        : allFavorites.where((post) => post.topico == _selectedTopico).toList();
    return Column(
      children: [
        if (!favoriteService.isLoading && allFavorites.isNotEmpty)
          Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
            child: DropdownButtonFormField<String>(
              value: _selectedTopico ?? _allTopicsValue,
              isExpanded: true,
              decoration: const InputDecoration(
                labelText: "Filtrar por Tópico",
                border: OutlineInputBorder(),
              ),
              items: dropdownTopics.map((String topic) {
                return DropdownMenuItem<String>(
                  value: topic,
                  child: Text(topic, overflow: TextOverflow.ellipsis),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedTopico = newValue;
                });
              },
            ),
          ),
         Divider(height: 20, thickness: 1,),
        Expanded(
          child: Builder(
            builder: (context) {
              if (favoriteService.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (allFavorites.isEmpty) {
                return const Center(
                  child: Text(
                    'Nenhum Termo Favorito Encontrado!',
                    style: TextStyle(fontSize: 18),
                  ),
                );
              }
              if (filteredFavorites.isEmpty) {
                return Center(
                  child: Text(
                    'Nenhum Termo Favorito para o Tópico "$_selectedTopico".',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18),
                  ),
                );
              }
              final List<CardCustom3ViewModel> cardViewModels =
                  _mapPostsToCardViewModels(filteredFavorites);
              return ListCard(
                cards: cardViewModels,
                cardModelType: CardModelType.cardCustom3,
                displayMode: CardDisplayMode.verticalList,
              );
            },
          ),
        ),
      ],
    );
  }
}
