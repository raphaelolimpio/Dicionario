import 'package:dicionario/Config/model/Post_model.dart';
import 'package:dicionario/Service/topico_sevice.dart';

class ValidationResult {
  final bool isDuplicate;
  final String? message;

  ValidationResult({required this.isDuplicate, this.message});
}

class ValidationService {
  static Future<ValidationResult> isTermoDuplicate({
    required String newTopico,
    required String newNome,
  }) async {
    try {
      final response = await TopicoSevice.getTopicos();
      if (response.statusCode >= 200 &&
          response.statusCode < 300 &&
          response.data != null) {
        final List<PostModel> allTerms = response.data!;

        final String normalizedNewTopico = newTopico.toLowerCase().trim();
        final String normalizedNewNome = newNome.toLowerCase().trim();

        for (final PostModel existingTermo in allTerms) {
          final String existingTopico = (existingTermo.topico)
              .toLowerCase()
              .trim();
          final String existingNome = (existingTermo.nome ?? '')
              .toLowerCase()
              .trim();

          if (existingTopico == normalizedNewTopico &&
              existingNome == normalizedNewNome) {
            return ValidationResult(
              isDuplicate: true,
              message:
                  "Já existe um termo com o nome '$newNome' no tópico '$newTopico'.",
            );
          }
        }

        return ValidationResult(isDuplicate: false, message: null);
      } else {
        return ValidationResult(
          isDuplicate: true,
          message:
              "Não foi possível validar o termo. Erro ao buscar dados: ${response.statusCode}",
        );
      }
    } catch (e) {
      return ValidationResult(
        isDuplicate: true,
        message: "Não foi possível validar o termo. Erro de rede: $e",
      );
    }
  }
}
