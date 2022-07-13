import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:movieverse/api.dart';
import 'package:movieverse/models/movie.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MovieService {
  static Future<List<Movie>> getMoviesByCategory(
      {required String apiPath, required int page}) async {
    final prefs = await SharedPreferences.getInstance();
    final dio = Dio();
    try {
      if (apiPath == Api.getPopularMovie) {
        final response = await dio.get(apiPath, queryParameters: {
          'api_key': '1e0a86a9653d14d172521cabf95056a2',
          'page': 1,
          'language': 'en-US'
        });
        prefs.setString('movieData', jsonEncode(response.data['results']));

        final data = (response.data['results'] as List)
            .map((e) => Movie.fromJson(e))
            .toList();
        return data;
      } else {
        final response = await dio.get(apiPath, queryParameters: {
          'api_key': '1e0a86a9653d14d172521cabf95056a2',
          'page': page,
          'language': 'en-US'
        });

        final data = (response.data['results'] as List)
            .map((e) => Movie.fromJson(e))
            .toList();
        return data;
      }
    } on DioError catch (err) {
      if (apiPath == Api.getPopularMovie) {
        final data = jsonDecode(prefs.getString('movieData')!);
        final modelData = (data as List).map((e) => Movie.fromJson(e)).toList();
        return modelData;
      }
      return [];
    }
  }

  static Future<List<Movie>> getSearchMovie(
      {required String apiPath,
      required int page,
      required String query}) async {
    final dio = Dio();
    try {
      final response = await dio.get(apiPath, queryParameters: {
        'api_key': '1e0a86a9653d14d172521cabf95056a2',
        'page': page,
        'language': 'en-US',
        'query': query
      });
      if ((response.data['results'] as List).isEmpty) {
        return [
          Movie(
              id: 0,
              title: 'not available',
              overview: '',
              poster_path: '',
              release_date: '',
              vote_average: '')
        ];
      } else {
        final data = (response.data['results'] as List)
            .map((e) => Movie.fromJson(e))
            .toList();
        return data;
      }
    } on DioError catch (err) {
      print(err);
      return [];
    }
  }
}
