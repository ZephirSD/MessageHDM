import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:session_next/session_next.dart';

final String _rpcUrl =
    Platform.isAndroid ? 'https://10.0.2.2:8000' : 'https://127.0.0.1:8000';
var session = SessionNext();

Future<List<dynamic>> fetchGetAllUtilisateurs() async {
  var url = Uri.parse('$_rpcUrl/api/getAllUser');
  var headers = {'Authorization': 'Bearer ${session.get('tokenUser')}'};
  var request = http.Request('GET', url);

  request.headers.addAll(headers);

  http.StreamedResponse response = await request.send();
  var streamReponse = await http.Response.fromStream(response);

  if (response.statusCode == 200) {
    var jsonRecup = json.decode(streamReponse.body);
    return jsonRecup['result'];
  } else {
    throw Exception('Request Failed.');
  }
}
