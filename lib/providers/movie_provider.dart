import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movieverse/api.dart';
import 'package:movieverse/models/movie.dart';
import 'package:movieverse/models/movie_init.dart';
import 'package:movieverse/services/movieservice.dart';

final movieProvider =
    StateNotifierProvider<MovieProvider, MovieState>((ref) => MovieProvider());

class MovieProvider extends StateNotifier<MovieState> {
  MovieProvider() : super(MovieState.init()) {
    getMovies();
  }

  Future<void> getMovies() async {
    List<Movie> _movies = [];
    if (state.searchText == '') {
      if (state.apiPath == Api.getPopularMovie) {
        _movies = await MovieService.getMoviesByCategory(
            apiPath: state.apiPath, page: state.page);
      } else if (state.apiPath == Api.getTopRatedMovie) {
        _movies = await MovieService.getMoviesByCategory(
            apiPath: state.apiPath, page: state.page);
      } else {
        _movies = await MovieService.getMoviesByCategory(
            apiPath: state.apiPath, page: state.page);
      }
    } else {
      _movies = await MovieService.getSearchMovie(
          apiPath: state.apiPath, page: state.page, query: state.searchText);
    }
    state = state.copyWith(movies: [...state.movies, ..._movies]);
  }

  void updateApi(String api) {
    state = state.copyWith(
      apiPath: api,
      searchText: '',
      movies: [],
    );
    getMovies();
  }

  void searchMovie(String query) {
    state = state.copyWith(
      searchText: query,
      apiPath: Api.searchMovie,
      movies: [],
    );
    getMovies();
  }

  void loadMore() {
    state = state.copyWith(
      searchText: '',
      page: state.page + 1,
    );
    getMovies();
  }
}

final videoProvider =
    FutureProvider.family((ref, int id) => VideoProvider().getVideo(id));

class VideoProvider {
  Future<String> getVideo(int movieId) async {
    final dio = Dio();
    try {
      final response = await dio.get(
          'https://api.themoviedb.org/3/movie/$movieId/videos',
          queryParameters: {'api_key': '1e0a86a9653d14d172521cabf95056a2'});
      return response.data['results'][0]['key'];
    } on DioError catch (err) {
      return '';
    }
  }
}
