import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:peliculas/models/models.dart';

class MoviesProvider extends ChangeNotifier{
  final String _baseUrl = 'api.themoviedb.org';
  final String _apiKey = '1c486cfa9b0b6331fe36fb201531b3df';
  final String _language = 'es-MX';

  List<Movie> onDisplayMovies = [];
  List<Movie> onPopularMovies = [];
  int _popularPage = 0;

  MoviesProvider(){
    print('Movies provider inicializado');
    getNowPlayingMovies();
    getPopularMovies();
  }

  Future<String> _getJsonData(String segmento, [int page = 1]) async{

    var url = Uri.https(_baseUrl, segmento, {
      'api_key': _apiKey,
      'language' : _language,
      'page' : '$page'
    });

    // Await the http get response, then decode the json-formatted response.
    final response = await http.get(url);
    return response.body;
  }

  getNowPlayingMovies() async{
    String segmento = '/3/movie/now_playing';
    final jsonData = await _getJsonData(segmento);
    final nowPlaying = NowPlayingResponse.fromJson(jsonData);
    onDisplayMovies = nowPlaying.results;
    notifyListeners();
  }

  getPopularMovies() async{
    _popularPage++;
    String segmento = '/3/movie/popular';
    final jsonData = await _getJsonData(segmento, _popularPage);
    final popularMovies = PopularResponse.fromJson(jsonData);
    onPopularMovies = [...onPopularMovies, ...popularMovies.results];
    notifyListeners();
  }
}