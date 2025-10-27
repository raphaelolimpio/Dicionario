import 'package:dicionario/Config/model/Post_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:dicionario/Config/server/Api_service.dart';



class TopicoSevice extends ApiService {

  static String get _getBaseUrl {
    final url = dotenv.env['LinkApi'];
    if (url == null || url.isEmpty){
      print("Erro fatal: 'Link' não encontrado");
      return "";
    }
    return url;
  }

  static Future<ApiResponse<List<PostModel>>> getTopicos({
    String? topico,
    String? nome,
  }) async {

    final baseUrl = _getBaseUrl;
    if (baseUrl.isEmpty){
      return ApiResponse(data: null, statusCode: 500);
    }

    String finalUrl;
    
    if (topico != null && topico.isNotEmpty && topico != 'Todos') {
      final topicoCodificado = Uri.encodeComponent(topico);
      finalUrl = "$baseUrl/comandos/topico/$topicoCodificado";
    } else {
      finalUrl = "$baseUrl/comandos";
    }

    if(nome != null && nome.isNotEmpty){
      final nomeCodificado = Uri.encodeComponent(nome);
      finalUrl += "?nome=$nomeCodificado";
    }
    print("chamando Api: $finalUrl");

    var response = await ApiService.request<List<PostModel>>(
      url: finalUrl,
      verb: HttpVerb.get,
      fromJson: (json) {
        if (json is List) {
          return json
              .map((item) => PostModel.fromJson(item as Map<String, dynamic>))
              .toList();
        }
        return [];
      },
    );
    return response;
  }

  static Future<ApiResponse<List<String>>> getAllTopico() async {

    final baseUrl = _getBaseUrl;
    if(baseUrl.isEmpty){
      return ApiResponse(data: null, statusCode: 500);
    }
   final url = "$baseUrl/topicos";
   print("Chamando Api: $url");
    var response = await ApiService.request<List<String>>(
      url: url,
      verb: HttpVerb.get,
      fromJson: (json) {
        if (json is List) {
          return json.map((item) => item.toString()).toList();
        }
        return [];
      },
    );
    return response;
  }

}
