import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:messagehdm/Composants/Evenements/evenements_class.dart';
import 'package:session_next/session_next.dart';

final String _rpcUrl =
    Platform.isAndroid ? 'https://10.0.2.2:8000' : 'https://127.0.0.1:8000';
var session = SessionNext();

Future<List<Evenements>> fetchFindEvent(String idEvent) async {
  var url = Uri.parse('$_rpcUrl/api/evenements/${idEvent}');
  var headers = {'Authorization': 'Bearer ${session.get('tokenUser')}'};
  var request = http.Request('GET', url);

  request.headers.addAll(headers);

  http.StreamedResponse response = await request.send();
  var streamReponse = await http.Response.fromStream(response);

  if (response.statusCode == 200) {
    return Evenements.fromJsonList(json.decode(streamReponse.body));
  } else {
    print(response.reasonPhrase);
    throw Exception('Request Failed.');
  }
}
