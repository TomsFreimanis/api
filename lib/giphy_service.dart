import 'package:http/http.dart' as http;

class GiphyService {
  static const _baseUrl = 'https://api.giphy.com/v1/gifs';
  static const _apiKey = 'D53Tayit31GiLBHCGAedx4UYYJOlVJSQ'; // Replace with your Giphy API key

  Future<http.Response> search(String query) {
    final url = '$_baseUrl/search?api_key=$_apiKey&q=$query';
    return http.get(Uri.parse(url));
  }
}



