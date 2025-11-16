import 'package:dicionario/Config/cache/cache_termos/cache_termos.dart';
import 'package:dicionario/Config/model/Post_model.dart';
import 'package:dicionario/Config/server/Api_service.dart';
import 'package:dicionario/Service/topico_sevice.dart';
import 'package:flutter/material.dart';

enum RequestState { idle, loading, success, error }

class TermoService with ChangeNotifier {
  RequestState _topicosState = RequestState.idle;
  RequestState get topicosState => _topicosState;

  RequestState _pageState = RequestState.idle;
  RequestState get pageState => _pageState;
  String? _pageError;
  String? get pageError => _pageError;

  ApiResponse<List<String>>? _topicosResponse;
  ApiResponse<List<String>>? get topicosResponse => _topicosResponse;

  String? _topicosError;
  String? get topicosError => _topicosError;

  RequestState _termosState = RequestState.idle;
  RequestState get termosState => _termosState;

  String? _selectedTopicoFilter;
  String? get selectedTopicoFilter => _selectedTopicoFilter;

  ApiResponse<List<PostModel>>? _termosResponse;
  ApiResponse<List<PostModel>>? get termosResponse => _termosResponse;

  String? _termosError;
  String? get termosError => _termosError;

  String? _lastTopico;
  String? _lastNome;

  Future<void> _revalidateCache(String? topico, String? nome) async {
    print("Cache: Revalidando dados em background...");
    try {
      final apiTopicos = await TopicoSevice.getAllTopico();
      if (apiTopicos.data != null) {
        _topicosResponse = apiTopicos;
        TermosCache.saveTopicos(apiTopicos.data!);
      }
      final apiTermos = await TopicoSevice.getTopicos(
        topico: topico,
        nome: nome,
      );
      if (apiTermos.data != null) {
        TermosCache.saveTermos(topico, nome, apiTermos.data!);
        if (topico == _selectedTopicoFilter && nome == _lastNome) {
          _termosResponse = apiTermos;
          print("CAche: UI atualizada com dados de revalidação");
          notifyListeners();
        }
      }
    } catch (e) {
      print("Cache: Falha na revalidação em background: $e");
    }
  }

  Future<void> initialLoad() async {
    _pageState = RequestState.loading;
    notifyListeners();

    final cachedTopicos = TermosCache.getTopicos();
    final cachedTermos = TermosCache.getTermos(null, null);

    if (cachedTopicos != null && cachedTermos != null) {
      print("Cache: Carregado com sucesso (Tópicos e Termos)");
      _topicosResponse = ApiResponse(data: cachedTopicos, statusCode: 200);
      _termosResponse = ApiResponse(data: cachedTermos, statusCode: 200);
      _pageState = RequestState.success;
      _topicosState = RequestState.success;
      _termosState = RequestState.success;
      notifyListeners();

      _revalidateCache(null, null);
      return;
    }
    print("Cache: vazio. Buscando da Api...");

    try {
      final topicoResult = await TopicoSevice.getAllTopico();
      if (topicoResult.data == null)
        throw Exception("Falha ao carregar Tópicos");
      _topicosResponse = topicoResult;
      TermosCache.saveTopicos(topicoResult.data!);
      _topicosState = RequestState.success;

      final termoResult = await TopicoSevice.getTopicos();
      if (termoResult.data == null)
        throw Exception("Falha ao carregar termos.");
      _termosResponse = termoResult;
      TermosCache.saveTermos(null, null, termoResult.data!);
      _termosState = RequestState.success;
      _pageState = RequestState.success;
    } catch (e) {
      _pageError = "Error ao carregar dadods";
      _pageState = RequestState.error;
    }
    notifyListeners();
  }

  Future<void> fetchTopicos() async {
    _topicosState = RequestState.loading;
    _topicosError = null;
    notifyListeners();
    final cachedTopicos = TermosCache.getTopicos();
    if (cachedTopicos != null) {
      print("Cache: Tópicos (avulso) carregados.");
      _topicosResponse = ApiResponse(data: cachedTopicos, statusCode: 200);
      _topicosState = RequestState.success;
      notifyListeners();
      _revalidateCache(null, null);
      return;
    }
    try {
      final response = await TopicoSevice.getAllTopico();
      if (response.data != null) {
        _topicosResponse = response;
        TermosCache.saveTopicos(response.data!);
        _topicosState = RequestState.success;
      } else {
        _topicosError = "Falha ao buscar Tópicos: ${response.statusCode}";
        _termosState = RequestState.error;
      }
    } catch (e) {
      _topicosError = "Erro de conexção $e";
      _termosState = RequestState.error;
    }
    notifyListeners();
  }

  Future<void> fetchTermos({String? topico, String? nome}) async {
    _lastTopico = topico;
    _lastNome = nome;
    _selectedTopicoFilter = topico;
    _termosError = null;
    notifyListeners();

    final cachedTermos = TermosCache.getTermos(topico, nome);
    if (cachedTermos != null) {
      print("Cache: Filtro carregado ($topico, $nome).");
      _termosResponse = ApiResponse(data: cachedTermos, statusCode: 200);
      _termosState = RequestState.success;
      notifyListeners();
      _revalidateCache(topico, nome);
      return;
    }
    print("Cache: Filtro ($topico, $nome) vazio. Buscando da API...");
    try {
      final response = await TopicoSevice.getTopicos(
        topico: topico,
        nome: nome,
      );
      if (response.data != null) {
        _termosResponse = response;
        TermosCache.saveTermos(topico, nome, response.data!);
        _termosState = RequestState.success;
      } else {
        _termosError = "Falha ao buscar termos.";
        _termosState = RequestState.error;
      }
    } catch (e) {
      _termosError = "Erro de conexção $e";
      _termosState = RequestState.error;
    }
    notifyListeners();
  }

  void retryFetchTermos() {
    fetchTermos(topico: _lastTopico, nome: _lastNome);
  }
}
