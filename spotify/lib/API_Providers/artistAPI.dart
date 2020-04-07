///Importing dart libraries to use it.
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:spotify/Models/http_exception.dart';
import '../Models/artist.dart';

class ArtistEndPoints {
  static const String albums = '/albums';
  static const String artists = '/artists';
  static const String relatedArtists = '/relatedArtists';
  static const String topTracks = '/topTracks';
}

class ArtistAPI {
  final String baseUrl;
  ArtistAPI({this.baseUrl});

  Future<Artist> fetchChosenApi(String token ,String id) async {
    final url = baseUrl +
        ArtistEndPoints.artists +'/' + id;
    try {
      final response = await http.get(
        url,
        headers: {"authorization": "Bearer " + token},
      );
      print('test111114584s');
      print(response.body);
      print(response.statusCode);
      if (response.statusCode == 200 ||response.statusCode == 211 ) {
        print('test11111');
        //final extractedList = json.decode(response.body) ;
        Map<String, dynamic> temp = json.decode(response.body);
        Map<String, dynamic> extractedList = temp['data'];
        //final extractedList = temp2['playlists'] as List;9
        print(response.body);
        print(extractedList);
        Artist choosedArtist = Artist.fromJson(
            extractedList);
        print('test artist single');
        print(response);
        print(extractedList);
        //print(choosedArtist);
        return choosedArtist;
      } else {
        throw HttpException(json.decode(response.body)['message'].toString());
      }
    } catch (error) {
      print('error artist single');
      print(token);
      throw HttpException(error.toString());
    }
  }

  Future<List> fetchMultiApi(String token , String id) async {
    final url = baseUrl +
        ArtistEndPoints.artists + '/' + id + ArtistEndPoints.relatedArtists;
    try {
      final response = await http.get(
        url,
        headers: {'authorization' : "Bearer " + token},
      );
      if (response.statusCode == 200 ||response.statusCode == 211) {
        final extractedList = json.decode(response.body) as List;
        print('test artist');
        print(extractedList);
        return extractedList;
      } else {
        throw HttpException(json.decode(response.body)['message'].toString());
      }
    } catch (error) {
      print('error artist');
      throw HttpException(error.toString());
    }
  }

  Future<List> fetchAllApi(String token) async {
    final url = baseUrl +
        ArtistEndPoints.artists;
    try {
      final response = await http.get(
        url,
        headers: {'authorization': token},
      );
      if (response.statusCode == 200 ||response.statusCode == 211) {
        final extractedList = json.decode(response.body) as List;
        return extractedList;
      } else {
        throw HttpException(json.decode(response.body)['message'].toString());
      }
    } catch (error) {
      throw HttpException(error.toString());
    }
  }
}
