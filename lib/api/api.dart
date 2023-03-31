import 'dart:convert';
import 'package:http/http.dart' as http;

class Show {
  String apiId;
  String name;
  String summary;
  String imageOriginal;
  String imageMedium;
  String imdb;
  double rating;
  bool favorite;

  Show({
    required this.apiId,
    required this.name,
    required this.summary,
    required this.imageOriginal,
    required this.imageMedium,
    required this.imdb,
    required this.rating,
    required this.favorite,
  });

  Map<String, dynamic> toMap() {
    return {
      'api_id': apiId,
      'name': name,
      'summary': summary,
      'image_original': imageOriginal,
      'image_medium': imageMedium,
      'imdb': imdb,
      'rating': rating,
      'favorite': favorite ? 1 : 0,
    };
  }

  factory Show.fromMap(Map<String, dynamic> map) {
    return Show(
      apiId: map['api_id'],
      name: map['name'],
      summary: map['summary'],
      imageOriginal: map['image_original'],
      imageMedium: map['image_medium'],
      imdb: map['imdb'],
      rating: map['rating'],
      favorite: map['favorite'] == 1,
    );
  }
}

Future<List<Show>> fetchShows() async {
  final response = await http.get(Uri.parse('https://api.tvmaze.com/shows'));

  if (response.statusCode == 200) {
    final parsed = jsonDecode(response.body).cast<Map<String, dynamic>>();
    return parsed.map<Show>((json) => Show.fromMap(json)).toList();
  } else {
    throw Exception('Failed to load shows');
  }
}
