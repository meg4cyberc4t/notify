import 'package:http/http.dart' as http;
import 'package:notify/src/notify_api_client/errors/exception_model.dart';

Future<void> statusCodeExceptionHandler(http.Response res) async {
  if (res.statusCode >= 400) {
    throw NotifyApiClientException(
      statusCode: res.statusCode,
      message: res.body,
    );
  }
}
