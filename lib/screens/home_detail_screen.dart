import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:movieverse/models/movie.dart';
import 'package:movieverse/providers/movie_provider.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class DetailScreen extends StatelessWidget {
  final Movie movie;

  DetailScreen(this.movie);
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final videoData = ref.watch(videoProvider(movie.id));
        return Scaffold(
          backgroundColor: Colors.black,
          body: SafeArea(
            child: ListView(children: [
              Container(
                height: 350,
                color: Colors.white,
                child: videoData.when(
                    data: (data) {
                      return YoutubePlayer(
                        controller: YoutubePlayerController(
                          initialVideoId: data,
                          flags: YoutubePlayerFlags(
                            autoPlay: false,
                            mute: false,
                          ),
                        ),
                        showVideoProgressIndicator: true,
                      );
                    },
                    error: (err, stack) => Container(),
                    loading: () => Container()),
              ),
              SizedBox(
                height: 20,
              ),
              Column(
                //mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    movie.title,
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 26),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'RELEASE DATE: ${movie.release_date}',
                    style: TextStyle(color: Colors.white),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'RATING: ${movie.vote_average}',
                    style: TextStyle(color: Colors.white),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'OVERVIEW:',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    movie.overview,
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              )
            ]),
          ),
        );
      },
    );
  }
}
