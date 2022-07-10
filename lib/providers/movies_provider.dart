import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:peliculas/models/models.dart';

class MoviesProvider extends ChangeNotifier{
  final String _baseUrl = 'api.themoviedb.org';
  final String _apiKey = '1c486cfa9b0b6331fe36fb201531b3df';
  final String _language = 'es-MX';

  List<Movie> onDisplayMovies = [];
  List<Movie> onPopularMovies = [];

  MoviesProvider(){
    print('Movies provider inicializado');
    getNowPlayingMovies();
    getPopularMovies();
  }

  getNowPlayingMovies() async{
    String segmento = '/3/movie/now_playing';
    var url = Uri.https(_baseUrl, segmento, {
      'api_key': _apiKey,
      'language' : _language,
      'page' : '1'
    });

    // Await the http get response, then decode the json-formatted response.
    final response = await http.get(url);
    final nowPlaying = NowPlayingResponse.fromJson(response.body);
    onDisplayMovies = nowPlaying.results;
    notifyListeners();
  }

  getPopularMovies() async{
    String segmento = '/3/movie/popular';
    var url = Uri.https(_baseUrl, segmento, {
      'api_key': _apiKey,
      'language' : _language,
      'page' : '1'
    });

    // Await the http get response, then decode the json-formatted response.
    final response = await http.get(url);
    final popularMovies = PopularResponse.fromJson(response.body);
    onPopularMovies = [...onPopularMovies, ...popularMovies.results];
    notifyListeners();
  }
}