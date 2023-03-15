import 'dart:convert';
import 'package:http/http.dart' as http;

class Show {
  final int id;
  final String name;
  final String summary;
  final String imageOriginal;
  final String imageMedium;

  Show(
      {required this.id,
      required this.name,
      required this.summary,
      required this.imageOriginal,
      required this.imageMedium});

  factory Show.fromJson(Map<String, dynamic> json) {
    return Show(
      id: json['id'],
      name: json['name'],
      summary: json['summary'],
      imageOriginal: json['image']['original'],
      imageMedium: json['image']['medium'],
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
