import 'dart:convert';
import 'package:http/http.dart' as http;

class Show {
  // ignore: non_constant_identifier_names
  final int api_id;
  final String name;
  final String summary;
  final String imageOriginal;
  final String imageMedium;
  final String imdb;
  final dynamic rating;
  final bool favorite;

  Show({
    // ignore: non_constant_identifier_names
    required this.api_id,
    required this.name,
    required this.summary,
    required this.imageOriginal,
    required this.imageMedium,
    required this.imdb,
    required this.rating,
    required this.favorite,
  });

  factory Show.fromJson(Map<String, dynamic> json) {
    return Show(
      api_id: json['id'],
      name: json['name'],
      summary: json['summary'],
      imageOriginal: json['image']['original'],
      imageMedium: json['image']['medium'],
      imdb: json['externals'] != null ? json['externals']['imdb'] ?? '' : '',
      rating: json['rating'] != null ? json['rating']['average'] ?? 0.0 : 0.0,
      favorite: false,
    );
  }
}

Future<List<Show>> fetchShows() async {
  final response = await http.get(Uri.parse('https://api.tvmaze.com/shows'));

  if (response.statusCode == 200) {
    final parsed = jsonDecode(response.body).cast<Map<String, dynamic>>();
    return parsed.map<Show>((json) => Show.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load shows');
  }
}
