sealed class ApiException  implements Exception {
}

class NotFoundException extends ApiException {
  final String? message;
  NotFoundException({this.message});
  @override
  String toString() {
    return 'NotFoundException: $message';
  }
}
class InternalException extends ApiException {
  final String? message;
  InternalException({this.message});
  @override
  String toString() {
    return 'NotFoundException: $message';
  }
}