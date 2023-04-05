import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:url_launcher/url_launcher.dart';

import '../sql/sql_helper.dart';

class ShowDetailPage extends StatelessWidget {
  final Map<String, dynamic> showData;

  ShowDetailPage({Key? key, required this.showData}) : super(key: key);

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
            child: isFavorite
                ? const Icon(Icons.delete)
                : const Icon(Icons.favorite, color: Colors.red),
            style: ButtonStyle(
              backgroundColor:
                  MaterialStateProperty.all<Color>(Colors.orangeAccent),
            ),
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
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final double screenWidth = constraints.maxWidth;

          if (screenWidth > 600) {
            // Pantalla grande
            return Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Center(
                      // child: Image(
                      //   image: NetworkImage(showData['imageMedium']),
                      // ),
                      child: CachedNetworkImage(
                        imageUrl: showData['imageMedium'],
                        placeholder: (context, url) =>
                            CircularProgressIndicator(),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      ),
                    ),
                  ),
                ),
                Expanded(
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
                                  child: Text(
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
                          ),
                          const Spacer(),
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Text('Rating: ${showData['rating']}'),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: SingleChildScrollView(
                          child: HtmlWidget(
                            showData['summary'],
                            // style: const TextStyle(fontSize: 20.0),
                          ),
                        ),
                      ),
                    ],
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
                  // Image(
                  //   image: NetworkImage(showData['imageMedium']),
                  // ),
                  CachedNetworkImage(
                    imageUrl: showData['imageMedium'],
                    placeholder: (context, url) => CircularProgressIndicator(),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            InkWell(
                              child: Text(
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
                        showData['summary'],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}

class ShowFavoritePage extends StatefulWidget {
  final Map<String, dynamic> showData;

  ShowFavoritePage({Key? key, required this.showData}) : super(key: key);

  @override
  State<ShowFavoritePage> createState() => _ShowFavoritePageState();
}

class _ShowFavoritePageState extends State<ShowFavoritePage> {
  late Future<List<Map<String, dynamic>>> favoritesFuture;

  late String showName;

  deleteTVshow(BuildContext context, id, showName, bool slidable) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Remove to Favorites"),
          content: Text(
              '${"Are you sure you want to remove " + showName} from favorites?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                'Cancel',
              ),
            ),
            TextButton(
              onPressed: () async {
                await SQLHelper.updateFavorite(id, false);
                setState(() {
                  favoritesFuture = SQLHelper.getFavorites();
                });
                if (slidable == false) {
                  Navigator.pop(context);
                  Navigator.pop(context);
                } else {
                  Navigator.pop(context);
                }
              },
              child: const Text(
                'Remove',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
    // Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              deleteTVshow(context, widget.showData['id'],
                  widget.showData['name'], false);
            },
          )
        ],
        backgroundColor: Colors.orangeAccent,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Favorites',
              style: TextStyle(fontSize: 16),
            ),
            Text(
              widget.showData['name'],
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final double screenWidth = constraints.maxWidth;

          if (screenWidth > 600) {
            // Pantalla grande
            return Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Center(
                      // child: Image(
                      //   image: NetworkImage(widget.showData['imageMedium']),
                      // ),
                      child: CachedNetworkImage(
                        imageUrl: widget.showData['imageMedium'],
                        placeholder: (context, url) =>
                            CircularProgressIndicator(),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      ),
                    ),
                  ),
                ),
                Expanded(
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
                                  child: Text(
                                    'IMDb: ${widget.showData['imdb']}',
                                    style: const TextStyle(
                                      decoration: TextDecoration.underline,
                                      color: Colors.blue,
                                    ),
                                  ),
                                  onTap: () {
                                    launch(Uri.parse(
                                            'https://www.imdb.com/title/${widget.showData['imdb']}')
                                        .toString());
                                  },
                                ),
                              ],
                            ),
                          ),
                          const Spacer(),
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Text('Rating: ${widget.showData['rating']}'),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: SingleChildScrollView(
                          child: HtmlWidget(
                            widget.showData['summary'],
                            // style: const TextStyle(fontSize: 20.0),
                          ),
                        ),
                      ),
                    ],
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
                  // Image(
                  //   image: NetworkImage(widget.showData['imageMedium']),
                  // ),
                  CachedNetworkImage(
                    imageUrl: widget.showData['imageMedium'],
                    placeholder: (context, url) => CircularProgressIndicator(),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            InkWell(
                              child: Text(
                                'IMDb: ${widget.showData['imdb']}',
                                style: const TextStyle(
                                  decoration: TextDecoration.underline,
                                  color: Colors.blue,
                                ),
                              ),
                              onTap: () {
                                launch(Uri.parse(
                                        'https://www.imdb.com/title/${widget.showData['imdb']}')
                                    .toString());
                              },
                            ),
                          ],
                        ),
                        const Spacer(),
                        Text('Rating: ${widget.showData['rating']}'),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: SingleChildScrollView(
                      child: HtmlWidget(
                        widget.showData['summary'],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
