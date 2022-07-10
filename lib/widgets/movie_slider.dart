import 'package:flutter/material.dart';
import 'package:peliculas/models/models.dart';

class MovieSliders extends StatefulWidget {

  final List<Movie> movies;
  final String? titleList;
  final Function onNextPage;

  const MovieSliders({Key? key, required this.movies, this.titleList, required this.onNextPage}) : super(key: key);

  @override
  State<MovieSliders> createState() => _MovieSlidersState();
}

class _MovieSlidersState extends State<MovieSliders> {

  final ScrollController _scrollController = ScrollController();
  bool _statusCharge = true;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() async {
      if(_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 500 && _statusCharge){
        _statusCharge = false;
        await widget.onNextPage();
        _statusCharge = true;
      }
      /*print(_scrollController.position.pixels);
      print(_scrollController.position.maxScrollExtent);*/
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    if(widget.movies.isEmpty){
      return Container(
        width: double.infinity,
        height: 260,
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Container(
      width: double.infinity,
      height: 270,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if(widget.titleList != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(widget.titleList!, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ),
          const SizedBox(height: 5),
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              scrollDirection: Axis.horizontal,
              itemCount: widget.movies.length,
              itemBuilder: (context, i) => _MoviePoster(movie: widget.movies[i])
            ),
          )
        ],
      ),
    );
  }
}

class _MoviePoster extends StatelessWidget {
  final Movie movie;
//438148
  const _MoviePoster({Key? key, required this.movie}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 130,
      height: 190,
      margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
      child: Column(
        children: [
          GestureDetector(
            onTap: () => Navigator.pushNamed(context, 'details', arguments: movie),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: FadeInImage(
                placeholder: const AssetImage('lib/assets/no-image.jpg'),
                image: NetworkImage(movie.fullPosterImg),
                width: 130,
                height: 190,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Text(
              movie.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          )
        ],
      ),
    );
  }
}

