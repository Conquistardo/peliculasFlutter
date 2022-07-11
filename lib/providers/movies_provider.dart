import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:peliculas/helpers/debouncer.dart';
import 'package:peliculas/models/models.dart';

class MoviesProvider extends ChangeNotifier{
  final String _baseUrl = 'api.themoviedb.org';
  final String _apiKey = '1c486cfa9b0b6331fe36fb201531b3df';
  final String _language = 'es-MX';

  List<Movie> onDisplayMovies = [];
  List<Movie> onPopularMovies = [];

  Map<int, List<Cast>> moviesCast = {};

  int _popularPage = 0;

  final debouncer = Debouncer(duration: const Duration(
      milliseconds: 500
    )
  );

  final StreamController<List<Movie>> _suggestionStreamController = StreamController.broadcast();
  Stream<List<Movie>> get suggestionStream => this._suggestionStreamController.stream;

  MoviesProvider(){
    getNowPlayingMovies();
    getPopularMovies();
  }

  Future<String> _getJsonData(String segmento, [int page = 1]) async{
    final url = Uri.https(_baseUrl, segmento, {
      'api_key': _apiKey,
      'language' : _language,
      'page' : '$page'
    });

    // Await the http get response, then decode the json-formatted response.
    final response = await http.get(url);
    return response.body;
  }

  getNowPlayingMovies() async{
    const String segmento = '/3/movie/now_playing';
    final jsonData = await _getJsonData(segmento);
    final nowPlaying = NowPlayingResponse.fromJson(jsonData);
    onDisplayMovies = nowPlaying.results;
    notifyListeners();
  }

  getPopularMovies() async{
    _popularPage++;
    const String segmento = '/3/movie/popular';
    final jsonData = await _getJsonData(segmento, _popularPage);
    final popularMovies = PopularResponse.fromJson(jsonData);
    onPopularMovies = [...onPopularMovies, ...popularMovies.results];
    notifyListeners();
  }

  Future<List<Cast>> getMovieCast(int movieId) async{
    if(moviesCast.containsKey(movieId)){
      return moviesCast[movieId]!;
    }
    final String segmento = '3/movie/$movieId/credits';
    final jsonData = await _getJsonData(segmento, _popularPage);
    final creditsReponse = CreditsReponse.fromJson(jsonData);
    moviesCast[movieId] = creditsReponse.cast;

    return creditsReponse.cast;

  }

  Future<List<Movie>> searchMovies(String query) async{
    const segmento = '3/search/movie';
    final url = Uri.https(_baseUrl, segmento, {
      'api_key': _apiKey,
      'language' : _language,
      'query' : query
    });

    final response = await http.get(url);
    final searchReponse = SearchMovieResponse.fromJson(response.body);

    return searchReponse.results;
  }

  void getSuggestionsByQuery(String query){

    debouncer.value = '';
    debouncer.onValue = (value) async{
      final result = await searchMovies(value);
      _suggestionStreamController.add(result);
    };

    final timer = Timer.periodic(const Duration(milliseconds: 300), (_) {
      debouncer.value = query;
    });

    Future.delayed(const  Duration(milliseconds: 301)).then((_) => timer.cancel());

  }

}