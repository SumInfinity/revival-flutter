import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';

class NetworkingClass {
  String _rootURL = 'http://172.20.10.5:8000/api';
  //final Uri uri =    Uri(scheme: 'http', host: "localhost", path: "/api", port: 8000);
  final String token;

  NetworkingClass({@required this.token}) {
    //this._rootURL = uri.toString();
  }

  Map<String, String> headers() {
    if (token != '') {
      return {'Authorization': 'Bearer ' + token, 'Accept': 'application/json'};
    } else {
      return {'Accept': 'application/json'};
    }
  }

  Future<dynamic> get(String url) async {
    http.Response response =
        await http.get(_rootURL + url, headers: this.headers());
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return data;
    } else {
      return [];
    }
  }

  Future<dynamic> post(String url, dynamic data) async {
    http.Response response =
        await http.post(_rootURL + url, body: data, headers: this.headers());
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return data;
    } else {
      return [];
    }
  }

  Future<dynamic> put(String url, dynamic data) async {
    http.Response response =
        await http.put(_rootURL + url, body: data, headers: this.headers());
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return data;
    } else {
      return [];
    }
  }

  Future<dynamic> delete(String url) async {
    http.Response response =
        await http.delete(_rootURL + url, headers: this.headers());
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body).data;
      return data;
    } else {
      return [];
    }
  }
}