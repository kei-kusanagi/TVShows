import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../api/api.dart';
import 'package:tv_show/screens/TvShowScreen.dart';
import '../sql/sql_helper.dart';

class Favorites extends StatefulWidget {
  const Favorites({Key? key}) : super(key: key);

  @override
  State<Favorites> createState() => FavoritesState();
}

class FavoritesState extends State<Favorites> {
  List<Map<String, dynamic>> _favorites = [];

  bool _isLoading = true;

  void _refreshFavorites() async {
    final data = await SQLHelper.getItems();
    setState(() {
      _favorites = data;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    _refreshFavorites();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
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
                    // onPressed: (BuildContext context) {
                    //   SQLHelper.deleteItem(_favorites[index]['id']);
                    // },
                    onPressed: (BuildContext context) {
                      deleteTVshow(context, _favorites[index]);
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
                  NavigationHelper().detailPush(
                      context,
                      AsyncSnapshot<List<Show>>.withData(ConnectionState.none,
                          _favorites[index]['id'] as List<Show>),
                      index,
                      'TV Shows');
                  // NavigationHelper().detailPush(
                  //     context,
                  //     AsyncSnapshot<List<Show>>.withData(
                  //         ConnectionState.none, _favorites as List<Show>),
                  //     index,
                  //     'Favorites');
                },
                leading: Image(
                  image: NetworkImage(_favorites[index]['imageMedium']),
                ),
                title: Text(_favorites[index]['name']),
                // subtitle: Text(favorites[index].imdb),
                trailing: const Icon(Icons.arrow_forward_ios_rounded,
                    color: Colors.grey),
              ),
            );
          },
        ),
      ),
    );
  }

  deleteTVshow(BuildContext context, _favorites) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Remove to Favorites"),
          content: Text(
              '${"Are you sure you want to remove " + _favorites['name']} from favorites?'),
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
                    SQLHelper.deleteItem(_favorites['id'] as int);
                  });
                }
                Navigator.pop(context);
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
  }
}
