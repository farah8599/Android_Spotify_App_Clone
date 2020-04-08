import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:spotify/Models/http_exception.dart';

class PlayHistoryEndpoints {
  static const me = '/me';
  static const player = '/player';
  static const recentlyPlayed = '/recentlyPlayed';
}

class PlayHistoryAPI {
  final String baseUrl;
  PlayHistoryAPI({
    this.baseUrl,
  });

  Future<List> fetchRecentlyPlayedApi(String token) async {
    final url = baseUrl +
        PlayHistoryEndpoints.me +
        PlayHistoryEndpoints.player +
        PlayHistoryEndpoints.recentlyPlayed;
    try {
      final response = await http.get(
        url,
        headers: {"authorization": "Bearer " + token},
      );
      if (response.statusCode == 200) {
        Map<String, dynamic> temp = json.decode(response.body);
        Map<String, dynamic> temp2 = temp['data'];
        final extractedList = temp2['items'] as List;
        print(extractedList);
        return extractedList;
      } else {
        throw HttpException(json.decode(response.body)['message'].toString());
      }
    } catch (error) {
      throw HttpException(error.toString());
    }
  }
}