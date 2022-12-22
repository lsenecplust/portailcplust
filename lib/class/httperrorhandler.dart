import 'package:http/http.dart' as http;

class HttpErrorHandler {

  static handle(http.Response response) {
    if(response.statusCode !=200) {
     throw Exception('Http error');
    }
  }
}