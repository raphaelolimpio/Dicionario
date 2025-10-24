import 'package:dicionario/Config/model/Post_model.dart';
import 'package:dicionario/DS/Components/Card/model/card_custom2/Card_custom2.dart';
import 'package:dicionario/DS/Components/Card/model/card_custom2/Card_custom2_view_model.dart';
import 'package:flutter/material.dart';

class DetalWidget extends StatelessWidget {
  final PostModel termo;

  const DetalWidget({Key? key, required this.termo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cardViewModel = CardCustom2ViewModel(
      id: termo.id,
      topico: termo.topico,
      nome: termo.nome ?? '',
      categoria: termo.categoria ?? '',
      definicao: termo.definicao ?? '',
      comando_exemplo: termo.comando_exemplo ?? '',
      explicacao_pratica: termo.explicacao_pratica ?? '',
      dicas_de_uso: termo.dicas_de_uso ?? '',
    );
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
        child: CardCustom2(viewModel: cardViewModel),
      ),
    );
  }
}
