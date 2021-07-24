import 'package:dio/dio.dart';

const API_BASE_URL = 'https://listie-service.herokuapp.com';
// const API_BASE_URL = 'http://127.0.0.1:8000';

class ApiService {
  String _paramsToQueryString(Map<String, dynamic> params) {
    Map<String, String> _params = {};

    params.entries.forEach((element) {
      _params = {
        ..._params,
        ...{element.key: "${element.value}"},
      };
    });

    return Uri(queryParameters: _params).query;
  }

  Future<Map<String, dynamic>> get(
    String path, [
    Map<String, dynamic> params = const {},
  ]) async {
    final query = _paramsToQueryString(params);
    final url = "$API_BASE_URL$path/?$query";
    final response = await Dio().get(url);
    return {'results': response.data};
  }

  Future<Map<String, dynamic>> post(
    String path, [
    Map<String, dynamic> params = const {},
  ]) async {
    final url = "$API_BASE_URL$path/";
    final response = await Dio().post(url, data: params);
    return response.data;
  }

  Future<Map<String, dynamic>> put(
    String path, [
    Map<String, dynamic> params = const {},
  ]) async {
    final url = "$API_BASE_URL$path/";
    final response = await Dio().put(url, data: params);
    return response.data;
  }

  Future<Map<String, dynamic>> delete(String path) async {
    final url = "$API_BASE_URL$path/";
    final response = await Dio().delete(url);
    return response.data;
  }
}
