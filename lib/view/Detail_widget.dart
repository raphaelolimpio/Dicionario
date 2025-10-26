import 'package:dicionario/Config/model/Post_model.dart';
import 'package:dicionario/DS/Components/Card/model/card_custom2/Card_custom2.dart';
import 'package:dicionario/DS/Components/Card/model/card_custom2/Card_custom2_view_model.dart';
import 'package:dicionario/DS/Components/Icons/Icon_view_Model.dart';
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
            explicacaoPraticaIcon: IconViewModel( 
              icon: IconType.dialog, 
              color: colorType.cyan,
              size: IconSize.medium,
            ),
            dicasDeUsoIcon: IconViewModel( 
              icon: IconType.dica, 
              color: colorType.orange,
              size: IconSize.medium,
            ),
    );
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
        child: CardCustom2(viewModel: cardViewModel),
      ),
    );
  }
}
