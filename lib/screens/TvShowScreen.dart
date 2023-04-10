import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter/material.dart';
import 'package:tv_show/screens/DetailScreen.dart';
import 'package:tv_show/sql/sql_helper.dart';

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
                    _tvShows[index]['favorite'] == 1
                        ? SlidableAction(
                            onPressed: (BuildContext context) async {
                              await SQLHelper.updateFavorite(
                                  _tvShows[index]['id'], false);
                            },
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                            icon: Icons.delete,
                            label: 'Remove from Favorites',
                          )
                        : SlidableAction(
                            onPressed: (BuildContext context) async {
                              await SQLHelper.updateFavorite(
                                  _tvShows[index]['id'], true);
                            },
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                            icon: Icons.favorite,
                            label: 'Add to Favorites',
                          ),
                  ],
                ),
                child: ListTile(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) =>
                          ShowDetailPage(showData: _tvShows[index]),
                    ));
                  },
                  title: Text(_tvShows[index]['name']),
                  // leading: Image.network(_tvShows[index]['imageMedium']),
                  leading: CachedNetworkImage(
                    imageUrl: _tvShows[index]['imageMedium'],
                    placeholder: (context, url) => CircularProgressIndicator(),
                    errorWidget: (context, url, error) =>
                        Icon(Icons.network_check_outlined),
                  ),

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
}
