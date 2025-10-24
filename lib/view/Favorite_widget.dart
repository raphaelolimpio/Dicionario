import 'package:dicionario/Config/model/Post_model.dart';
import 'package:dicionario/DS/Components/Card/BaseCard/Card_enum.dart';
import 'package:dicionario/DS/Components/Card/ListCard/List_card_custom.dart';
import 'package:dicionario/DS/Components/Card/model/card_custom3/Card_custom3_view_model.dart';
import 'package:dicionario/Service/favorite_service.dart';
import 'package:dicionario/shared/color.dart';
import 'package:flutter/material.dart';

class FavorictWidget extends StatefulWidget {
  final void Function(PostModel)? onProductSelected;
  const FavorictWidget({Key? key, this.onProductSelected}) : super(key: key);

  @override
  State<FavorictWidget> createState() => _FavorictWidgetState();
}

class _FavorictWidgetState extends State<FavorictWidget> {
  late Future<List<PostModel>> _favoritesFuture = Future.value([]);

  @override
  void initState() {
    super.initState();
    _fetchFavorites();
  }

  void _fetchFavorites() {
    setState(() {
      _favoritesFuture = FavoriteService.getFavorites();
    });
  }

  List<CardCustom3ViewModel> _mapPostsToCardViewModels(List<PostModel> posts) {
    return posts.map((post) {
      return CardCustom3ViewModel(
        id: post.id,
        topico: post.topico,
       nome: post.nome ?? "sem nome",
        categoria: post.categoria?? "sem nome",
        definicao: post.definicao?? "sem nome",
        comando_exemplo: post.comando_exemplo,
        explicacao_pratica: post.explicacao_pratica?? "sem nome",
        dicas_de_uso: post.dicas_de_uso,
        onButtonPressed: (context) {
          if (widget.onProductSelected != null) {
            widget.onProductSelected!(post);
          }
        },
        onFavortiteRemoved: _fetchFavorites,
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: FutureBuilder<List<PostModel>>(
            future: _favoritesFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(
                  child: Text(
                    'Erro ao carregar favoritos: ${snapshot.error}',
                    textAlign: TextAlign.center,
                  ),
                );
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(
                  child: Text(
                    'Nenhum item favorito encontrado.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18, color: GrayBorderColor),
                  ),
                );
              } else {
                final List<PostModel> favorites = snapshot.data!;
                final List<CardCustom3ViewModel> cardViewModels =
                    _mapPostsToCardViewModels(favorites);
                return ListCard(
                  cards: cardViewModels,
                  cardModelType: CardModelType.CardCustom3,
                  displayMode: CardDisplayMode.verticalList,
                );
              }
            },
          ),
        ),
      ],
    );
  }
}
