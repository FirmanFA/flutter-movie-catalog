import 'dart:convert';
import 'package:http/http.dart' as http;

import 'movie.dart';

final queryParam = {
  'api_key': '5374e8eba1107b24236cc30d17d5aa11',
};

Future<Movie> fetchDiscoverMovies() async {

  final uriDiscoverMovies = Uri.https('api.themoviedb.org','/3/discover/movie',queryParam);

  final response = await http
      .get(uriDiscoverMovies);

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    print(response.body);
    return Movie.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}