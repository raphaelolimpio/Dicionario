import 'package:dicionario/Config/server/Api_service.dart';
import 'package:dicionario/Config/model/Post_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';


class Service {
  static Future<ApiResponse<List<PostModel>>> getPosts() async {
    var url = dotenv.env['LinkApi'] ?? '';
    if (url.isEmpty) {
      print("ERRO DE COMUNICACAO");
      throw Exception('LinkApi não encontrado em .env');
    }

    var response = await ApiService.request<List<PostModel>>(
      url: url,
      verb: HttpVerb.get,
      fromJson:
          (json) =>
              (json as List)
                  .map(
                    (item) => PostModel.fromJson(item as Map<String, dynamic>),
                  )
                  .toList(),
    );
    if (response.statusCode >= 200 || response.statusCode < 300) {
      print("Numero de posts ${response.data!.length}");

      for (PostModel post in response.data!) {
        print(post);
      }
    } else {
      print("ERRO DE COMUNICACAO");
    }

    return response;
  }
}
