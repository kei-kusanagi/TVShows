import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:provider/provider.dart';
import 'package:tv_show/main.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:like_button/like_button.dart';

import '../sql/sql_helper.dart';

class ShowDetailPage extends StatelessWidget {
  final Map<String, dynamic> showData;

  const ShowDetailPage({Key? key, required this.showData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isFavorite = showData['favorite'] == 1;

    return Scaffold(
      appBar: DetailScreenAppBar(isFavorite, context),
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
    );
  }

  AppBar DetailScreenAppBar(bool isFavorite, BuildContext context) {
    return AppBar(
      actions: [
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: LikeButton(
            bubblesSize: 75,
            animationDuration: const Duration(milliseconds: 1500),
            bubblesColor: isFavorite
                ? const BubblesColor(
                    dotPrimaryColor: Colors.purpleAccent,
                    dotSecondaryColor: Colors.greenAccent)
                : const BubblesColor(
                    dotPrimaryColor: Colors.white,
                    dotSecondaryColor: Colors.redAccent,
                  ),
            likeBuilder: (isTapped) {
              return isFavorite
                  ? const Icon(
                      Icons.favorite,
                      color: Colors.purple,
                      size: 30,
                    )
                  : const Icon(
                      size: 30,
                      Icons.favorite_border,
                    );
            },
            onTap: (isLiked) async {
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
              return !isLiked;
            },
          ),
        ),
      ],
      backgroundColor: Colors.orangeAccent,
      leading: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {
          Provider.of<ScreenModel>(context, listen: false).isFullScreen = false;
          Navigator.of(context).pop();
        },
      ),
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
