import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:movieverse/providers/movie_provider.dart';
import 'package:movieverse/screens/home_detail_screen.dart';

class PopularWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      final movieData = ref.watch(movieProvider);
      return OfflineBuilder(
        connectivityBuilder: (
          BuildContext context,
          ConnectivityResult connectivity,
          Widget child,
        ) {
          final bool connected = connectivity != ConnectivityResult.none;

          return movieData.movies.isEmpty
              ? Center(
                  child: CircularProgressIndicator(color: Colors.black),
                )
              : movieData.movies[0].title == 'not available'
                  ? Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Movie Not Found',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          IconButton(
                            onPressed: () {
                              ref.refresh(movieProvider.notifier);
                            },
                            icon: Icon(Icons.refresh_rounded),
                            //ElevatedButton(onPressed: () {}, child: Text('Refresh')
                          ),
                        ],
                      ),
                    )
                  : NotificationListener(
                      onNotification: (onNotification) {
                        if (onNotification is ScrollEndNotification) {
                          final before = onNotification.metrics.extentBefore;
                          final max = onNotification.metrics.maxScrollExtent;
                          if (before == max) {
                            if (connectivity != ConnectivityResult.none) {
                              ref.read(movieProvider.notifier).loadMore();
                            }
                          }
                        }
                        return true;
                      },
                      child: GridView.builder(
                          itemCount: movieData.movies.length,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  crossAxisSpacing: 5,
                                  mainAxisExtent: 200,
                                  mainAxisSpacing: 0),
                          itemBuilder: (context, index) {
                            final movie = movieData.movies[index];
                            return InkWell(
                              onTap: () {
                                Get.to(() => DetailScreen(movie),
                                    transition: Transition.leftToRight);
                              },
                              child: CachedNetworkImage(
                                  errorWidget: (ctx, s, d) {
                                    return Image.asset(
                                        'assets/images/no-image.jpg');
                                  },
                                  imageUrl:
                                      'https://image.tmdb.org/t/p/w600_and_h900_bestv2/${movie.poster_path}'),
                            );
                          }),
                    );
        },
        child: Container(),
      );
    });
  }
}
