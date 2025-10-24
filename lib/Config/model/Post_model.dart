class PostModel {
  final int id;
  final String topico;
  final String? nome;
  final String? categoria;
  final String? definicao;
  final String? comando_exemplo;
  final String? explicacao_pratica;
  final String? dicas_de_uso;

  PostModel({
    required this.id,
    required this.topico,
    this.nome,
    this.categoria,
    this.definicao,
    this.comando_exemplo,
    this.explicacao_pratica,
    this.dicas_de_uso,
  });
  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: json['id'] as int,
      topico: json['topico'] as String,
      nome: json['nome'] as String?,
      categoria: json['categoria'] as String?,
      definicao: json['definicao'] as String?,
      comando_exemplo: json['comando_exemplo'] as String?,
      explicacao_pratica: json['explicacao_pratica'] as String?,
      dicas_de_uso: json['dicas_de_uso'] as String?,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'topico': topico,
      'nome': nome,
      'categoria': categoria,
      'definicao': definicao,
      'comando_exemplo': comando_exemplo,
      'explicacao_pratica': explicacao_pratica,
      'dicas_de_uso': dicas_de_uso,
    };
  }
}
