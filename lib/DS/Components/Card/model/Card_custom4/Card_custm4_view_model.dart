import 'package:dicionario/Config/model/Post_model.dart';
import 'package:dicionario/DS/Components/Card/BaseCard/base_Card.dart';
import 'package:dicionario/DS/Components/Icons/Icon_view_Model.dart';


class CardCustom4ViewModel extends BaseCardViewModel {
  final PostModel? initialData;
  final String buttonText;
  final Future<void> Function(PostModel) onSave;

  final IconViewModel? topicoIcon;
  final IconViewModel? categorIcon;
  final IconViewModel? definicaoIcon;
  final IconViewModel? comandoExemploIcon;
  final IconViewModel? explicacaoPraticaIcon;
  final IconViewModel? dicasDeUsoIcon;

  CardCustom4ViewModel({
    this.initialData,
    this.buttonText = 'Salvar',
    required this.onSave,
    

    this.topicoIcon,
    this.categorIcon,
    this.definicaoIcon,
    this.comandoExemploIcon,
    this.explicacaoPraticaIcon,
    this.dicasDeUsoIcon,
  });
}