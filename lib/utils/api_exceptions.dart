class ApiException implements Exception {
  final String message;

  ApiException(this.message);

  @override
  String toString() => message;
}

class NoInternetException extends ApiException {
  NoInternetException() : super('No internet connection');
}

class BadRequestException extends ApiException {
  BadRequestException() : super('Bad request');
}

class UnauthorizedException extends ApiException {
  UnauthorizedException() : super('Unauthorized');
}

class ForbiddenException extends ApiException {
  ForbiddenException() : super('Forbidden');
}

class NotFoundException extends ApiException {
  NotFoundException() : super('Not found');
}

class InternalServerErrorException extends ApiException {
  InternalServerErrorException() : super('Internal server error');
}

class ServiceUnavailableException extends ApiException {
  ServiceUnavailableException() : super('Service unavailable');
}
