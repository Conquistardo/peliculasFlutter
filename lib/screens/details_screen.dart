import 'package:flutter/material.dart';
import 'package:peliculas/widgets/widgets.dart';

class DetailsScreen extends StatelessWidget {
  const DetailsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String movie = ModalRoute.of(context)?.settings.arguments.toString()?? 'no-movie';
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const _CustomAppBar(),
          SliverList(
              delegate: SliverChildListDelegate([
                const _PosterAndTitle(),
                const _OverView(),
                const CastingCards()
              ])
          )
        ],
      )
    );
  }
}

class _CustomAppBar extends StatelessWidget {
  const _CustomAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: Colors.indigo,
      expandedHeight: 200,
      floating: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: EdgeInsets.zero,
        title: Container(
          color: Colors.black12,
          width: double.infinity,
          alignment: Alignment.bottomCenter,
          padding: const EdgeInsets.only(bottom: 5.0),
          child: const Text('movie.title', style: TextStyle(fontSize: 16))
        ),
        centerTitle: true,
        background: const FadeInImage(
          placeholder: AssetImage('lib/assets/loading.gif'),
          image: NetworkImage('https://via.placeholder.com/500x300'),
          fit: BoxFit.cover,
        ),
      )
    );
  }
}

class _PosterAndTitle extends StatelessWidget {
  const _PosterAndTitle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final textTheme = Theme.of(context).textTheme;

    return Container(
      margin: const EdgeInsets.only(top: 20.0),
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20.0),
            child: const FadeInImage(
              placeholder: AssetImage('lib/assets/no-image.jpg'),
              image: NetworkImage('https://via.placeholder.com/200x300'),
              height: 150,
            ),
          ),
          const SizedBox( width: 20.0 ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('movie.title', style: textTheme.headline5, overflow: TextOverflow.ellipsis, maxLines: 2,),
              Text('movie.originalTitle', style: textTheme.subtitle1, overflow: TextOverflow.ellipsis, maxLines: 2,),
              Row(
                children: [
                  const Icon(Icons.star_outline, size: 15.0, color: Colors.red,),
                  const SizedBox(width: 5,),
                  Text('movie.voteAverage', style: textTheme.caption,)
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}

class _OverView extends StatelessWidget {
  const _OverView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
      child: Text(
        'Lorem ipsum dolor sit amet. Id Quis dolore et voluptas nulla nam nobis velit eos natus minus! Et necessitatibus maiores ea molestias dolore nam fugit excepturi qui quia asperiores ut facilis voluptas hic voluptates provident. Qui tempore quam rem veniam asperiores rem quidem impedit. Sed aliquam consequuntur et maxime ipsa in totam dignissimos. Est totam dolorem a alias accusamus ad nemo consequatur ut error molestiae ut tenetur magnam non veritatis exercitationem est consectetur accusantium. Aut quia temporibus qui repudiandae enim 33 consequatur pariatur aut quibusdam quidem et aspernatur voluptatibus! Vel consequatur quos et cupiditate esse et quisquam rerum ut enim reiciendis. Non optio atque et asperiores excepturi aut natus iusto a modi aperiam  libero nobis eos nihil assumenda vel esse libero. Id dolorum error et aliquam exercitationem est officiis galisum. Non repudiandae quam est iure earum sed obcaecati atque quo nulla quibusdam ut sunt dolor est expedita perspiciatis. Et repudiandae consectetur eum nobis aliquam non fuga soluta est similique tempora ex molestiae aliquam. Ut beatae quam qui maxime corrupti qui alias fugit  deserunt ipsam. Et incidunt blanditiis qui autem quae est voluptatem necessitatibus At quidem expedita et ipsa provident sed consequatur galisum. Qui aspernatur illum sit cumque incidunt sed enim adipisci ut veritatis quis id perferendis dolorem ab voluptas necessitatibus ad officiis cupiditate.',
        textAlign: TextAlign.justify,
        style: Theme.of(context).textTheme.subtitle1,
      )
    );
  }
}
