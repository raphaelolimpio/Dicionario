import 'package:dicionario/Config/model/Post_model.dart';
import 'package:dicionario/DS/Components/Card/BaseCard/base_Card.dart';
import 'package:flutter/material.dart';

class CardCustom3ViewModel extends BaseCardViewModel {
  final int id;
  final String topico;
  final String nome;
  final String categoria;
  final String definicao;
  final String? comando_exemplo;
  final String explicacao_pratica;
  final String? dicas_de_uso;
  final String? buttonText;
  final void Function(BuildContext context)? onButtonPressed;
  final VoidCallback? onFavortiteRemoved;

  CardCustom3ViewModel({
    required this.id,
    required this.topico,
    required this.nome,
    required this.categoria,
    required this.definicao,
    this.comando_exemplo,
    required this.explicacao_pratica,
    this.dicas_de_uso,
    this.buttonText,
    required this.onButtonPressed,
    this.onFavortiteRemoved,
  });
  PostModel toPostModel() {
    return PostModel(
      id: id,
      topico: topico,
      nome: nome,
      categoria: categoria,
      definicao: definicao,
      comando_exemplo: comando_exemplo,
      explicacao_pratica: explicacao_pratica,
      dicas_de_uso: dicas_de_uso,
    );
  }
}
