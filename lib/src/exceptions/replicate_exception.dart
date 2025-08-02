class ReplicateException implements Exception {
  final String message;
  final int statsCode;

  ReplicateException({
    required this.message,
    required this.statsCode,
  });

  @override
  String toString() {
    return 'ReplicateException(message: $message, statsCode: $statsCode)';
  }
}
