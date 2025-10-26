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
        onFavoriteChanged: null,
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
    return Column(
      children: [
        Expanded(
          child: Builder(
            builder: (context) {
              if (favoriteService.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              
              if (favoriteService.favorites.isEmpty) {
                return const Center(
                  child: Text(
                    'Nenhum item favorito encontrado.',
                    style: TextStyle(fontSize: 18),
                  ),
                );
              }
                final List<PostModel> favorites = favoriteService.favorites;
                final List<CardCustom3ViewModel> cardViewModels =
                    _mapPostsToCardViewModels(favorites);
                return ListCard(
                  cards: cardViewModels,
                  cardModelType: CardModelType.CardCustom3,
                  displayMode: CardDisplayMode.verticalList,
                );
            },
          ),
        ),
      ],
    );
  }
}

