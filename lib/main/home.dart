import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import '../fetch.dart';
import '../movie.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  late Future<Movie> futureDiscoverMovie;

  @override
  void initState() {
    super.initState();
    futureDiscoverMovie = fetchDiscoverMovies();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Expanded(
            child: FutureBuilder<Movie>(
              future: futureDiscoverMovie,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final moviesData = snapshot.data?.results;

                  // final pageController

                  return Container(
                    margin: const EdgeInsets.only(top: 16),
                    child: CarouselSlider(
                      options: CarouselOptions(
                        height: 400.0,
                        autoPlay: true,
                        enableInfiniteScroll: true,
                      ),
                      items: moviesData?.map((value) {
                        return Builder(
                          builder: (BuildContext context) {
                            return Center(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: CachedNetworkImage(
                                  errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                                  imageUrl:
                                  'https://image.tmdb.org/t/p/w500${value.posterPath}',
                                  height: 300,
                                ),
                              ),
                            );
                          },
                        );
                      }).toList(),
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                }

                // By default, show a loading spinner.
                return const Align(
                  alignment: Alignment.center,
                  child: CircularProgressIndicator(),
                );
              },
            ),
          ),
          Expanded(
              child: FutureBuilder<Movie>(
                future: futureDiscoverMovie,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final moviesData = snapshot.data?.results;
                    return ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        itemCount: moviesData?.length,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: const EdgeInsets.all(8),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(16),
                                  child: CachedNetworkImage(
                                    errorWidget: (context, url, error) =>
                                    const Icon(Icons.error),
                                    imageUrl:
                                    'https://image.tmdb.org/t/p/w500${moviesData?[index].posterPath}',
                                    width: 120,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Flexible(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        moviesData?[index].title ?? 'no data',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                      ),
                                      const SizedBox(height: 16),
                                      Text(
                                        moviesData?[index].overview ?? 'no data',
                                        textAlign: TextAlign.justify,
                                        style:
                                        const TextStyle(color: Colors.white),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          );
                        });
                    // return Text(snapshot.data?.results?.first.title ?? 'no data');
                  } else if (snapshot.hasError) {
                    return Text('${snapshot.error}');
                  }

                  // By default, show a loading spinner.
                  return const Align(
                    alignment: Alignment.center,
                    child: CircularProgressIndicator(),
                  );
                },
              ))
        ],
      ),
    );
  }
}
