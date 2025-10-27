import 'package:dicionario/Config/model/Post_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:dicionario/Config/server/Api_service.dart';

class CreatService extends ApiService {
   static String get _getBaseUrl {
    final url = dotenv.env['LinkApi'];
    if (url == null || url.isEmpty){
      print("Erro fatal: 'Link' não encontrado");
      return "";
    }
    return url;
  }
  static Future<ApiResponse<PostModel>> createTermo(PostModel comando) async {
    final baseUrl = _getBaseUrl;
    if (baseUrl.isEmpty) {
      return ApiResponse(data: null, statusCode: 500);
    
    }
    final String? apiKey = dotenv.env['API_KEY'];
    final String apiKeyName =  dotenv.env['API_KEY_NAME'] ?? 'X-API-Key';

    if(apiKey == null || apiKey.isEmpty){
      print("Erro fatal: 'API_KEY' não foi encontrada no arquivo .env");
      return ApiResponse(data: null, statusCode: 401);
    }

    final url = "$baseUrl/comandos";
    print("Chamando API POST: $url");

    final Map<String,String> headers = {
      apiKeyName: apiKey,
      'Content-Type' : 'application/json',
    };
    var response = await ApiService.request<PostModel>(
      url: url,
      verb: HttpVerb.post,
      body: comando.toJson(), 
      headers: headers,
      fromJson: (json) {
        return PostModel.fromJson(json as Map<String, dynamic>);
      },
    );
    return response;
  }
}