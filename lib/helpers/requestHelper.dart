import 'dart:convert';
import 'dart:io';

import 'package:buking_test/helpers/storageHelper.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:http/http.dart';
import 'package:http/retry.dart';

Client client = RetryClient(
    http.Client(),
    delay: (attempt)=>Duration(seconds: attempt*5),
    onRetry: (p0, p1, retryCount) => debugPrint("${p0.method} /${p0.url}. Attempt: $retryCount"));
String? accessToken;
Future<String?> loadAccessToken()async{
  final prefs = await getPrefs();
  String? token = prefs.getString("accessToken");
  if(token==null)return null;
  Map<String, dynamic>? json = await axios.post("auth/validate",{"token":token}).getObj((json) => json);
  if(json==null||!json['exists']){
    token=null;
    await prefs.remove("accessToken");
  }
  accessToken=token;
  return token;
}
class Request{
  final Future<Response> _req;
  const Request(this._req);
  Future<T?> _r<T>(T Function(dynamic e) map)async{
    try{
      final response = await _req
          .timeout(const Duration(seconds: 5));
      return compute((String responseBody) {
        debugPrint("Response: $responseBody");
        final parsed = jsonDecode(responseBody);
        return map(parsed);
      }, response.body);
    } on SocketException catch (_){
      debugPrint("reload");
    }
  }
  Future<List<T>?> getList<T>([T Function(Map<String, dynamic> json)? toObject]){
    var method = (toObject??((json)=>json as T));
    return _r((parsed) => parsed.map<Map<String, dynamic>>((e) => e as Map<String, dynamic>).map<T>(method).toList());
  }
  Future<T?> getObj<T>([T Function(Map<String, dynamic> json)? toObject])async{
    var method = (toObject??((json)=>json as T));
    return _r((parsed) => method(parsed as Map<String, dynamic>));
  }
  Future<void> wait(){
    return _req.timeout(const Duration(seconds: 5));
  }
}
class axios{
  static Map<String, String>? _addToken(Map<String, String>? header){
    if(accessToken != null){
      header ??={};
      header['Authorization']="Bearer $accessToken";
      debugPrint("Bearer $accessToken");
    }
    return header;
  }
  static Request post(String url, [Object? body, Map<String, String>? headers]){
    debugPrint("POST ${Uri.http("93.79.41.156:3000",url).toString()}\nBody:$body");
    return Request(client.post(Uri.http("93.79.41.156:3000",url),body: body,headers: axios._addToken(headers)));
  }
  static Request get(String url, [Map<String, dynamic>? queryParameters, Map<String, String>? headers]){
    debugPrint("GET ${Uri.http("93.79.41.156:3000",url,queryParameters).toString()}");
    return Request(client.get(Uri.http("93.79.41.156:3000",url,queryParameters),headers: axios._addToken(headers)));
  }
  static Request delete(String url, [Map<String, dynamic>? queryParameters, Map<String, String>? headers]){
    debugPrint("DELETE ${Uri.http("93.79.41.156:3000",url,queryParameters).toString()}");
    return Request(client.delete(Uri.http("93.79.41.156:3000",url,queryParameters),headers: axios._addToken(headers)));
  }
}