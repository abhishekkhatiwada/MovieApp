import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:movieverse/api.dart';
import 'package:movieverse/providers/authprovider.dart';
import 'package:movieverse/providers/login_provider.dart';
import 'package:movieverse/providers/movie_provider.dart';
import 'package:movieverse/widgets/popular_widget.dart';
import 'package:movieverse/widgets/tab_bar_widget.dart';

class HomeScreen extends StatelessWidget {
  final searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        child: Consumer(builder: (context, ref, child) {
          return Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: Text('MOVIE VERSE'),
              elevation: 0,
              backgroundColor: Colors.black,
              actions: [
                IconButton(
                    onPressed: () {
                      ref.read(loadingProvider.notifier).toggle();
                      ref.read(authProvider).userSignOut();
                    },
                    icon: Icon(Icons.exit_to_app_sharp))
              ],
              bottom: TabBar(
                  onTap: (index) {
                    switch (index) {
                      case 0:
                        ref
                            .read(movieProvider.notifier)
                            .updateApi(Api.getPopularMovie);
                        break;
                      case 1:
                        ref
                            .read(movieProvider.notifier)
                            .updateApi(Api.getTopRatedMovie);
                        break;
                      default:
                        ref
                            .read(movieProvider.notifier)
                            .updateApi(Api.getUpcomingMovie);
                    }
                  },
                  labelColor: Colors.black,
                  unselectedLabelColor: Colors.white,
                  indicator: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                      ),
                      color: Colors.white),
                  tabs: [
                    Tab(
                      text: 'Populars',
                    ),
                    Tab(
                      text: 'Top Rated',
                    ),
                    Tab(
                      text: 'Upcoming',
                    ),
                  ]),
            ),
            body: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    left: 12,
                    right: 12,
                    top: 10,
                  ),
                  child: TextFormField(
                    controller: searchController,
                    onFieldSubmitted: (val) {
                      searchController.clear();
                      ref.read(movieProvider.notifier).searchMovie(val);
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20)),
                      hintText: 'Search Movies',
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      //icon: Icon(Icons.search)
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Expanded(
                  child: TabBarView(
                    children: [
                      PopularWidget(),
                      TabBarWidget(),
                      TabBarWidget(),
                    ],
                  ),
                ),
              ],
            ),
          );
        }));
  }
}
