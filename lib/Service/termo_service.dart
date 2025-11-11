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

  Future<void> initialLoad() async {
    _pageState = RequestState.loading;
    notifyListeners();
    try {
      final topicoResult = await TopicoSevice.getAllTopico();
      if (topicoResult.statusCode < 200 || topicoResult.statusCode >= 300) {
        throw Exception("Falha ao carregar Tópicos");
      }
      _topicosResponse = topicoResult;
      final termoResult = await TopicoSevice.getTopicos();
      if (termoResult.statusCode < 200 || termoResult.statusCode >= 300) {
        throw Exception("Falha ao carregar termos.");
      }
      _termosResponse = termoResult;
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

    try {
      final response = await TopicoSevice.getAllTopico();
      if (response.statusCode >= 200 && response.statusCode < 300) {
        _topicosResponse = response;
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

    try {
      final response = await TopicoSevice.getTopicos(
        topico: topico,
        nome: nome,
      );
      if (response.statusCode >= 200 && response.statusCode < 300) {
        _termosResponse = response;
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
