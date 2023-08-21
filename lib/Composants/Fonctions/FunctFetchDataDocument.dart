import 'dart:convert';
import 'package:http/http.dart' as http;
import '../Documents/documents_class.dart';

Future<List<Documents>> fetchDocuments(String _rpcUrl, dynamic session) async {
  var url =
      Uri.parse('${_rpcUrl}/api/documents/recents/${session.get("idUser")}');
  var headers = {'Authorization': 'Bearer ${session.get('tokenUser')}'};
  var request = http.Request('GET', url);
  request.headers.addAll(headers);
  http.StreamedResponse response = await request.send();
  var streamReponse = await http.Response.fromStream(response);

  if (response.statusCode == 200) {
    return Documents.fromJsonList(json.decode(streamReponse.body));
  } else {
    print(response.reasonPhrase);
    throw Exception('Request Failed.');
  }
}

Future<List<Documents>> fetchDocumentsPDF(
    String _rpcUrl, dynamic session) async {
  var url =
      Uri.parse('${_rpcUrl}/api/documents/listes/pdf/${session.get("idUser")}');
  var headers = {'Authorization': 'Bearer ${session.get('tokenUser')}'};
  var request = http.Request('GET', url);
  request.headers.addAll(headers);
  http.StreamedResponse response = await request.send();
  var streamReponse = await http.Response.fromStream(response);

  if (response.statusCode == 200) {
    return Documents.fromJsonList(json.decode(streamReponse.body));
  } else {
    print(response.reasonPhrase);
    throw Exception('Request Failed.');
  }
}

Future<List<Documents>> fetchDocumentsImages(
    String _rpcUrl, dynamic session) async {
  var url = Uri.parse(
      '${_rpcUrl}/api/documents/listes/images/${session.get("idUser")}');
  var headers = {'Authorization': 'Bearer ${session.get('tokenUser')}'};
  var request = http.Request('GET', url);
  request.headers.addAll(headers);
  http.StreamedResponse response = await request.send();
  var streamReponse = await http.Response.fromStream(response);

  if (response.statusCode == 200) {
    return Documents.fromJsonList(json.decode(streamReponse.body));
  } else {
    print(response.reasonPhrase);
    throw Exception('Request Failed.');
  }
}

Future<List<Documents>> fetchDocumentsWord(
    String _rpcUrl, dynamic session) async {
  var url = Uri.parse(
      '${_rpcUrl}/api/documents/listes/word/${session.get("idUser")}');
  var headers = {'Authorization': 'Bearer ${session.get('tokenUser')}'};
  var request = http.Request('GET', url);
  request.headers.addAll(headers);
  http.StreamedResponse response = await request.send();
  var streamReponse = await http.Response.fromStream(response);

  if (response.statusCode == 200) {
    return Documents.fromJsonList(json.decode(streamReponse.body));
  } else {
    print(response.reasonPhrase);
    throw Exception('Request Failed.');
  }
}

Future<List<Documents>> fetchDocumentsExcel(
    String _rpcUrl, dynamic session) async {
  var url = Uri.parse(
      '${_rpcUrl}/api/documents/listes/excel/${session.get("idUser")}');
  var headers = {'Authorization': 'Bearer ${session.get('tokenUser')}'};
  var request = http.Request('GET', url);
  request.headers.addAll(headers);
  http.StreamedResponse response = await request.send();
  var streamReponse = await http.Response.fromStream(response);

  if (response.statusCode == 200) {
    // print(await response.stream.bytesToString());
    return Documents.fromJsonList(json.decode(streamReponse.body));
  } else {
    print(response.reasonPhrase);
    throw Exception('Request Failed.');
  }
}
