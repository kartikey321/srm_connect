import 'dart:convert';

import 'package:http/http.dart' as http;

class RequestHelper {
  static getRequest(String url) async {
    var res = await http.get(Uri.parse(url));

    var data = jsonDecode(res.body);

    return data;
  }

  static deleteRequest(String url) async {
    var res = await http.delete(Uri.parse(url));
    var data = jsonDecode(res.body);
    return data;
  }

  static patchRequest(String url) async {
    var res = await http.patch(Uri.parse(url));
    var data = jsonDecode(res.body);
    return data;
  }

  static postRequest(String url, Map<String, dynamic> body) async {
    var res = await http.post(Uri.parse(url), body: jsonEncode(body));
    var data = res.body;
    return data;
  }
}
