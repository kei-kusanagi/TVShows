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

List<Show> favorites = [];

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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Center(child: const Text('Favorites')),
          backgroundColor: Colors.purple,
        ),
        body: ListView.builder(
          itemCount: favorites.length,
          itemBuilder: (context, index) {
            return Slidable(
              key: Key(favorites[index].toString()),
              endActionPane: ActionPane(
                motion: ScrollMotion(),
                children: [
                  SlidableAction(
                    onPressed: (BuildContext context) {
                      deleteTVshow(context, favorites[index]);
                    },
                    backgroundColor: Color(0xFFFE4A49),
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
                      AsyncSnapshot<List<Show>>.withData(
                          ConnectionState.none, favorites),
                      index,
                      'Favorites',
                      favorites);
                },
                leading: Image(
                  image: NetworkImage(favorites[index].imageMedium),
                ),
                title: Text(favorites[index].name),
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

  deleteTVshow(BuildContext context, TVshow) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Remove to Favorites"),
          content: Text(
              '${"Are you sure you want to remove " + TVshow.name} from favorites?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                'Cancel',
              ),
            ),
            TextButton(
              onPressed: () {
                if (mounted) {
                  setState(() {
                    favorites.remove(TVshow);
                  });
                }
                Navigator.pop(context);
              },
              child: Text(
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
