
import 'package:dicionario/Config/cache/cache_termos/cache_entry.dart';
import 'package:dicionario/Config/model/Post_model.dart';

class TermosCache{
  static final Map<String, CacheEntry> _cache = {};
  static const String _topicosKey = 'all_topicos';

  static String _getTermosKey(String? topicos, String? nome){
    final topicoKey = topicos ?? 'all';
    final nomeKey = nome ?? 'all';
    return 'termos-$topicoKey-$nomeKey';  
    }

    static void saveTopicos(List<String> topicos) {
      _cache[_topicosKey] = CacheEntry(topicos, DateTime.now());
      print("Cache: Topicos salvos");
    }

    static List<String>? getTopicos(){
      final entry = _cache[_topicosKey];
      if(entry == null) return null;

      if(entry.isExpired){
        print("Cache: Topicos expirados.");
        _cache.remove(_topicosKey);
        return null;
      }
      print("Cache: Tópicos lidos");
      return entry.data as List<String>;
    }

  static void saveTermos(
    String? topicos, String? nome, List<PostModel> termos
  ){
    final key = _getTermosKey(topicos, nome);
    _cache[key] = CacheEntry(termos, DateTime.now());
    print("Cache: Termos salvos para a chave '$key'.");
  }

  static List<PostModel>? getTermos(String? topico, String? nome){
    final key = _getTermosKey(topico, nome);
    final entry = _cache[key];
    if(entry == null) return null;
    if(entry.isExpired){
      print("Cache: Termos para a chave '$key' expiraram.");
      _cache.remove(key);
      return null;
    }
    print("Cache: Termos lidos da chave '$key'.");
    return entry.data as List<PostModel>;
  }
}