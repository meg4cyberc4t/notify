import 'dart:io';

class ApiServiceException extends IOException {
  ApiServiceException({required this.statusCode, required this.message});
  final int statusCode;
  final String message;

  @override
  String toString() => message;
}
