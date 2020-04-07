///Importing dart libraries to use it.
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:spotify/Models/http_exception.dart';
import '../API_Providers/artistAPI.dart';
import 'package:dio/dio.dart';
import 'dart:io';

class AlbumEndPoints {
  static const String albums = '/albums';
  static const String popular = '/popular';
  static const String mostRecent = '/most-recent';
  static const String forArtist = '/me';
  static const String track = '/track';
}

class AlbumAPI {
  final String baseUrl;
  AlbumAPI({this.baseUrl});

  Future<List> fetchPopularAlbumsApi(String token) async {
    final url = baseUrl +
        AlbumEndPoints.albums +
        AlbumEndPoints.popular; //base url to be added
    try {
      final response = await http.get(
        url,
        headers: {'authorization': token},
      );
      if (response.statusCode == 200) {
        final extractedList = json.decode(response.body) as List;
        return extractedList;
      } else {
        throw HttpException(json.decode(response.body)['message'].toString());
      }
    } catch (error) {
      throw HttpException(error.toString());
    }
  }

  Future<List> fetchMostRecentAlbumsApi(String token) async {
    final url = baseUrl +
        AlbumEndPoints.albums +
        AlbumEndPoints.mostRecent; //base url to be added
    try {
      final response = await http.get(
        url,
        headers: {'authorization': token},
      );
      if (response.statusCode == 200) {
        final extractedList = json.decode(response.body) as List;
        return extractedList;
      } else {
        throw HttpException(json.decode(response.body)['message'].toString());
      }
    } catch (error) {
      throw HttpException(error.toString());
    }
  }


  Future<List> fetchMyAlbumsApi(String token , String id) async {
    final url = baseUrl +
        AlbumEndPoints.forArtist + AlbumEndPoints.albums + '/' + id;
    try {
      final response = await http.get(
        url,
        headers: {'authorization': token},
      );
      if (response.statusCode == 200) {
        final extractedList = json.decode(response.body) as List;
        return extractedList;
      } else {
        throw HttpException(json.decode(response.body)['message'].toString());
      }
    } catch (error) {
      throw HttpException(error.toString());
    }
  }

  Future<List> fetchArtistAlbumsApi(String token , String id) async {
    final url = baseUrl +
        ArtistEndPoints.artists + '/' + id + AlbumEndPoints.albums;
    try {
      final response = await http.get(
        url,
        headers: {'authorization': token},
      );
      if (response.statusCode == 200) {
        final extractedList = json.decode(response.body) as List;
        return extractedList;
      } else {
        throw HttpException(json.decode(response.body)['message'].toString());
      }
    } catch (error) {
      throw HttpException(error.toString());
    }
  }

  Future<bool> uploadAlbumApi(File file, String token, String albumName,
      String albumType, String _currentTime) async {
    final url =
        baseUrl+ AlbumEndPoints.forArtist +AlbumEndPoints.albums ;
    try {
      FormData formData = new FormData.fromMap({
        "image": MultipartFile.fromFile(
          file.path,
        ),
        "releaseDate": _currentTime,
        "name": albumName,
        "type": albumType,
        // "genres": ,
      });
      Dio dio = new Dio();
      dio.options.headers["authorization"] = token;
      Response response = await dio.post(url, data: formData);
      if(response.statusCode==200)  {
        return true;
      }
      else {
        return false;
      }
    } catch (error) {
        throw HttpException(error.toString());
    }
  }
  //'http://www.mocky.io/v2/5e7e7536300000e0134afb12'


  Future<bool> uploadSongApi(String token,String songName , String path ) async
  {
    final url =
        baseUrl+ AlbumEndPoints.forArtist +AlbumEndPoints.albums + AlbumEndPoints.track;
    try {
      FormData formData = new FormData.fromMap({
        "name": songName,
        "trackAudio": MultipartFile.fromFile(
          path,
        ),
      });
      Dio dio = new Dio();
      dio.options.headers["authorization"] = token;
      Response response = await dio.post(url, data: formData);
      if(response.statusCode==200)  {
        return true;
      }
      else {
        return false;
      }
    } catch (error) {
      throw HttpException(error.toString());
    }
  }

}