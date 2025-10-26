import 'package:dicionario/DS/Components/Card/BaseCard/Card_enum.dart';
import 'package:dicionario/DS/Components/Card/BaseCard/base_Card.dart';
import 'package:dicionario/DS/Components/Card/model/card_custom/Card_custom.dart';
import 'package:dicionario/DS/Components/Card/model/card_custom/Card_custom_view_model.dart';
import 'package:dicionario/DS/Components/Card/model/card_custom2/Card_custom2.dart';
import 'package:dicionario/DS/Components/Card/model/card_custom2/Card_custom2_view_model.dart';
import 'package:dicionario/DS/Components/Card/model/card_custom3/Card_custom3.dart';
import 'package:dicionario/DS/Components/Card/model/card_custom3/Card_custom3_view_model.dart';
import 'package:flutter/material.dart';

class ListCard extends StatelessWidget {
  final List<BaseCardViewModel> cards;
  final CardModelType cardModelType;
  final CardDisplayMode displayMode;
  final double? listHeight;
  final ScrollController? scrollController;

  const ListCard({
    super.key,
    required this.cards,
    this.cardModelType = CardModelType.cardCustom,
    this.displayMode = CardDisplayMode.verticalList,
    this.listHeight,
    this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final double responsiveCardWidth = screenWidth * 0.75;

    Widget buildCardWidget(BaseCardViewModel viewModel) {
      switch (cardModelType) {
        case CardModelType.cardCustom:
          if (viewModel is CardCustomViewModel) {
            return CardCustom(
              viewModel: viewModel,
              cardWidth: displayMode == CardDisplayMode.horizontalScroll
                  ? responsiveCardWidth
                  : null,
            );
          }
          return Text('Erro: ViewModel inesperado para Default Card');
        case CardModelType.cardCustom2:
          if (viewModel is CardCustom2ViewModel) {
            return CardCustom2(
              viewModel: viewModel,
              cardWidth: displayMode == CardDisplayMode.horizontalScroll
                  ? responsiveCardWidth
                  : null,
            );
          }
          return Text('Erro: ViewModel inesperado para Custom2 Card');
        case CardModelType.CardCustom3:
          if (viewModel is CardCustom3ViewModel) {
            return CardCustom3(
              viewModel: viewModel,
              cardWidth: displayMode == CardDisplayMode.horizontalScroll
                  ? responsiveCardWidth
                  : null,
            );
          }
          return Text('Erro: ViewModel inesperado para Custom Card');
      }
    }

    if (displayMode == CardDisplayMode.verticalList) {
      return ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: cards.length,
        itemBuilder: (context, index) {
          return buildCardWidget(cards[index]);
        },
      );
    } else {
      return SizedBox(
        height: listHeight ?? 420,
        child: RawScrollbar(
          controller: scrollController,
          thumbVisibility: true,
          child: ListView.builder(
            controller: scrollController,
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            scrollDirection: Axis.horizontal,
            itemCount: cards.length,
            shrinkWrap: true,
            physics: const ClampingScrollPhysics(),
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: buildCardWidget(cards[index]),
              );
            },
          ),
        ),
      );
    }
  }
}
