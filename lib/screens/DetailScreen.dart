// ignore_for_file: deprecated_member_use

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:url_launcher/url_launcher.dart';

import '../sql/sql_helper.dart';

class ShowDetailPage extends StatelessWidget {
  final Map<String, dynamic> showData;

  const ShowDetailPage({Key? key, required this.showData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isFavorite = showData['favorite'] == 1;

    return Scaffold(
      appBar: AppBar(
        actions: [
          ElevatedButton(
            onPressed: () async {
              if (isFavorite) {
                SQLHelper.updateFavorite(showData['id'], false);
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('Removed to Favorites'),
                      duration: Duration(seconds: 1)),
                );
              } else {
                SQLHelper.updateFavorite(showData['id'], true);
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('Added to Favorites',
                          textAlign: TextAlign.right),
                      duration: Duration(seconds: 1)),
                );
              }

              isFavorite = !isFavorite;
            },
            style: ButtonStyle(
              shape: MaterialStateProperty.all(const StadiumBorder()),
              elevation: MaterialStateProperty.all<double>(0),
              backgroundColor:
                  MaterialStateProperty.all<Color>(Colors.orangeAccent),
            ),
            child: isFavorite
                ? const Icon(Icons.delete)
                : const Icon(Icons.favorite),
          ),
        ],
        backgroundColor: Colors.orangeAccent,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'TV Shows',
              style: TextStyle(fontSize: 16),
            ),
            Text(
              showData['name'],
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            final double screenWidth = constraints.maxWidth;

            if (screenWidth > 600) {
              // Pantalla grande
              return Row(
                children: [
                  Expanded(
                    child: CachedImage(),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 30.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    InkWell(
                                      child: showData['imdb'].isEmpty
                                          ? const Text(
                                              'Dont have IMDBb',
                                              style: TextStyle(
                                                color: Colors.red,
                                              ),
                                            )
                                          : Text(
                                              'IMDb: ${showData['imdb']}',
                                              style: const TextStyle(
                                                decoration:
                                                    TextDecoration.underline,
                                                color: Colors.blue,
                                              ),
                                            ),
                                      onTap: () {
                                        launch(Uri.parse(
                                                'https://www.imdb.com/title/${showData['imdb']}')
                                            .toString());
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              const Spacer(),
                              Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Text('Rating: ${showData['rating']}'),
                              ),
                            ],
                          ),
                          HtmlWidget(
                            '<div style="text-align: justify;">${showData['summary']}</div>',
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            } else {
              // Pantalla pequeña
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    CachedImage(),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              InkWell(
                                child: showData['imdb'].isEmpty
                                    ? const Text(
                                        'Dont have IMDBb',
                                        style: TextStyle(
                                          color: Colors.red,
                                        ),
                                      )
                                    : Text(
                                        'IMDb: ${showData['imdb']}',
                                        style: const TextStyle(
                                          decoration: TextDecoration.underline,
                                          color: Colors.blue,
                                        ),
                                      ),
                                onTap: () {
                                  launch(Uri.parse(
                                          'https://www.imdb.com/title/${showData['imdb']}')
                                      .toString());
                                },
                              ),
                            ],
                          ),
                          const Spacer(),
                          Text('Rating: ${showData['rating']}'),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: SingleChildScrollView(
                        child: HtmlWidget(
                          '<div style="text-align: justify;">${showData['summary']}</div>',
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }
          },
        ),
      ),
      bottomNavigationBar: null,
    );
  }

  CachedNetworkImage CachedImage() {
    return CachedNetworkImage(
      imageUrl: showData['imageMedium'],
      // width: 250,
      height: 250,
      placeholder: (context, url) => const CircularProgressIndicator(),
      errorWidget: (context, url, error) =>
          const Icon(Icons.network_check_outlined),
    );
  }
}
