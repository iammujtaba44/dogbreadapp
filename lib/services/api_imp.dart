import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class ApiImp {
  http.Client _httpClient = new http.Client();

  Future<List<dynamic>> _generateResponse(Response res) async {
    if (res.statusCode == 200) return json.decode(res.body);

    return null;
    // {
    //   "status": "fail",
    //   "message": 'Failed with error: ${res.statusCode} ${res.reasonPhrase}',
    // };
  }

  Future<List<dynamic>> getPaginatedBreeds(int limt, int page) async {
    var response =
        await get("https://api.thedogapi.com/v1/breeds?limit=$limt&page=$page");
    //await get("https://api.thecatapi.com/v1/breeds?limit=$limt&page=$page");
    print(json.decode(response.body));
    return _generateResponse(response);
  }

  Future<Response> get(url) async {
    url = '$url';
    return _httpClient.get(url);
  }
}
