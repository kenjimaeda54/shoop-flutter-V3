class CustomHttpException implements Exception {
  late final String message;
  late final int statusCode;

  CustomHttpException({required this.message, required this.statusCode});

  @override
  String toString() {
    return message;
  }
}
