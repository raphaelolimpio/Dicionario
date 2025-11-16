class CacheEntry<T>{
  final T data;
  final DateTime timestamp;
  CacheEntry(this.data, this.timestamp);
  bool get isExpired{
    return DateTime.now().difference(timestamp) > const Duration(hours: 24);
  }
}