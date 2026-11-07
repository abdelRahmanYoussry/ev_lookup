class NotFoundException implements Exception {
  final String message;
  const NotFoundException(this.message);
}

class ServerException implements Exception {
  final int statusCode;
  const ServerException(this.statusCode);
}
