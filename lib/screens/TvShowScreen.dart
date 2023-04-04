import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:tv_show/sql/sql_helper.dart';
import 'package:url_launcher/url_launcher.dart';

class TvShow extends StatefulWidget {
  @override
  State<TvShow> createState() => TvShowState();
}

class TvShowState extends State<TvShow> {
  List<Map<String, dynamic>> _tvShows = [];

  late Future<List<Map<String, dynamic>>> favoritesFuture;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final items = await SQLHelper.getItems();
    setState(() {
      _tvShows = items;
    });
  }

  @override
  Widget build(BuildContext context) {
    _loadData();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: const Center(child: Text("TV Shows")),
            backgroundColor: Colors.purple,
          ),
          body: ListView.builder(
            itemCount: _tvShows.length,
            itemBuilder: (context, index) {
              return Slidable(
                key: Key(_tvShows[index].toString()),
                endActionPane: ActionPane(
                  motion: const ScrollMotion(),
                  children: [
                    SlidableAction(
                      onPressed: (BuildContext context) async {
                        await SQLHelper.updateFavorite(
                            _tvShows[index]['id'], true);
                      },
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      icon: Icons.favorite_border,
                      label: 'Add Favorites',
                    ),
                  ],
                ),
                child: ListTile(
                  onTap: () {
                    _showDetail(_tvShows[index]);
                  },
                  title: Text(_tvShows[index]['name']),
                  leading: Image.network(_tvShows[index]['imageMedium']),
                  trailing: const Icon(Icons.arrow_forward_ios_rounded,
                      color: Colors.grey),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void _showDetail(Map<String, dynamic> showData) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return Scaffold(
            appBar: AppBar(
              actions: [
                IconButton(
                    icon: const Icon(Icons.favorite),
                    onPressed: () {
                      SQLHelper.updateFavorite(showData['id'], true);
                      favoritesFuture = SQLHelper.getFavorites();
                    }),
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
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold),
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
                            child: Image(
                              image: NetworkImage(showData['imageMedium']),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      InkWell(
                                        child: Text(
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
                        Image(
                          image: NetworkImage(showData['imageMedium']),
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
        },
      ),
    );
  }
}
