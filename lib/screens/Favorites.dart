import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import '../sql/sql_helper.dart';
import 'package:url_launcher/url_launcher.dart';

class Favorites extends StatefulWidget {
  const Favorites({Key? key}) : super(key: key);

  @override
  State<Favorites> createState() => FavoritesState();
}

class FavoritesState extends State<Favorites> {
  List<Map<String, dynamic>> _favorites = [];

  // bool _isLoading = true;
  late bool slidable;
  // void _refreshFavorites() async {
  //   final data = await _initDatabase();
  //   setState(() {
  //     _favorites = data;
  //     _isLoading = false;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: const Center(child: Text('Favorites')),
            backgroundColor: Colors.purple,
          ),
          body: ListView.builder(
            itemCount: _favorites.length,
            itemBuilder: (context, index) {
              return Slidable(
                key: Key(_favorites[index].toString()),
                endActionPane: ActionPane(
                  motion: const ScrollMotion(),
                  children: [
                    SlidableAction(
                      onPressed: (BuildContext context) {
                        deleteTVshow(context, _favorites[index]['id'],
                            _favorites[index]['name'], true);
                      },
                      backgroundColor: const Color(0xFFFE4A49),
                      foregroundColor: Colors.white,
                      icon: Icons.delete,
                      label: 'Delete',
                    ),
                  ],
                ),
                child: ListTile(
                  onTap: () {
                    _showDetail(_favorites[index]);
                  },
                  title: Text(_favorites[index]['name']),
                  leading: Image.network(_favorites[index]['imageMedium']),
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
              onPressed: () {
                if (mounted) {
                  setState(() {
                    // SQLHelper.delete(id);
                  });
                  if (slidable == false) {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  } else {
                    Navigator.pop(context);
                  }
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

  void _showDetail(Map<String, dynamic> showData) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return Scaffold(
            appBar: AppBar(
              actions: [
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    deleteTVshow(
                        context, showData['id'], showData['name'], false);
                  },
                )
              ],
              backgroundColor: Colors.orangeAccent,
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Favorites',
                    style: TextStyle(fontSize: 16),
                  ),
                  Text(
                    showData['name'],
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
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
                                Spacer(),
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
                              Spacer(),
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
