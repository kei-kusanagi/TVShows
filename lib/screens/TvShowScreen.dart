import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter/material.dart';
import 'package:tv_show/api/api.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:tv_show/screens/Favorites.dart';
import 'package:tv_show/sql/sql_helper.dart';
import 'package:url_launcher/url_launcher.dart';

class TvShow extends StatefulWidget {
  @override
  State<TvShow> createState() => TvShowState();
}

class TvShowState extends State<TvShow> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Center(child: const Text("TV Shows")),
          backgroundColor: Colors.purple,
        ),
        body: FutureBuilder<List<Show>>(
          future: fetchShows(),
          builder: (context, listdata) {
            if (listdata.hasData) {
              return ListView.builder(
                itemCount: listdata.data!.length,
                itemBuilder: (context, index) {
                  Future<bool> isFavorite =
                      SQLHelper.getIMDB(listdata.data![index].imdb);
                  return FutureBuilder<bool>(
                    future: isFavorite,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        bool isFavorite = snapshot.data!;
                        if (isFavorite) {
                          return removeFavoritesSlidable(
                              listdata, index, context);
                        } else {
                          return addFavoritesSlidable(listdata, index, context);
                        }
                      } else {
                        return const Center(child: CircularProgressIndicator());
                      }
                    },
                  );
                },
              );
            } else if (listdata.hasError) {
              return Text("${listdata.error}");
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }

  Slidable removeFavoritesSlidable(
      AsyncSnapshot<List<Show>> listdata, int index, BuildContext context) {
    return Slidable(
      key: Key(listdata.data![index].toString()),
      endActionPane: ActionPane(
        motion: ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (BuildContext context) {
              setState(
                () {
                  SQLHelper.deleteItem(listdata.data![index].id as int);
                  // FavoritesState.deleteTVshow(context, listdata.data![index].id,
                  //     listdata.data![index].name, true);
                },
              );
            },
            backgroundColor: Colors.red,
            foregroundColor: Colors.black,
            icon: Icons.delete,
            label: 'Remove to Favorites',
          ),
        ],
      ),
      child: ListTile(
        onTap: () {
          NavigationHelper().detailPush(context, listdata, index, 'TV Shows');
        },
        title: Text(listdata.data![index].name),
        leading: Image.network(listdata.data![index].imageMedium),
        trailing:
            const Icon(Icons.arrow_forward_ios_rounded, color: Colors.grey),
      ),
    );
  }

  Slidable addFavoritesSlidable(
      AsyncSnapshot<List<Show>> listdata, int index, BuildContext context) {
    return Slidable(
      key: Key(listdata.data![index].toString()),
      endActionPane: ActionPane(
        motion: ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (BuildContext context) {
              setState(
                () {
                  SQLHelper.createItem(
                      listdata.data![index].id as int,
                      listdata.data![index].name as String,
                      listdata.data![index].summary as String,
                      listdata.data![index].imageOriginal as String,
                      listdata.data![index].imageMedium as String,
                      listdata.data![index].imdb as String,
                      listdata.data![index].rating as double);
                },
              );
            },
            backgroundColor: Colors.green,
            foregroundColor: Colors.black,
            icon: Icons.save,
            label: 'Add to Favorites',
          ),
        ],
      ),
      child: ListTile(
        onTap: () {
          setState(() {
            NavigationHelper().detailPush(context, listdata, index, 'TV Shows');
          });
        },
        title: Text(listdata.data![index].name),
        leading: Image.network(listdata.data![index].imageMedium),
        trailing:
            const Icon(Icons.arrow_forward_ios_rounded, color: Colors.grey),
      ),
    );
  }
}

class NavigationHelper {
  Future<dynamic> detailPush(
    BuildContext context,
    AsyncSnapshot<List<Show>> listdata,
    int index,
    String previousPageName,
  ) async {
    return Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) {
          return Scaffold(
            appBar: AppBar(
              actions: [
                IconButton(
                    onPressed: () {
                      SQLHelper.createItem(
                          listdata.data![index].id as int,
                          listdata.data![index].name as String,
                          listdata.data![index].summary as String,
                          listdata.data![index].imageOriginal as String,
                          listdata.data![index].imageMedium as String,
                          listdata.data![index].imdb as String,
                          listdata.data![index].rating as double);

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Added to favorites'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    },
                    icon: Icon(Icons.favorite))
              ],
              leading: IconButton(
                icon: Icon(Icons.arrow_back_ios),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              backgroundColor: Colors.orangeAccent,
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    previousPageName,
                    style: TextStyle(fontSize: 16),
                  ),
                  Text(
                    listdata.data![index].name,
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
                              image: NetworkImage(
                                listdata.data![index].imageMedium,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Row(
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      InkWell(
                                        child: Text(
                                          'IMDb: ${listdata.data![index].imdb}',
                                          style: const TextStyle(
                                            decoration:
                                                TextDecoration.underline,
                                            color: Colors.blue,
                                          ),
                                        ),
                                        onTap: () {
                                          launch(Uri.parse(
                                                  'https://www.imdb.com/title/${listdata.data![index].imdb}')
                                              .toString());
                                        },
                                      ),
                                    ],
                                  ),
                                  Spacer(),
                                  Text(
                                      'Rating: ${listdata.data![index].rating}'),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: HtmlWidget(
                                  listdata.data![index].summary,
                                  // style: const TextStyle(fontSize: 20.0),
                                ),
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
                        Image(
                          image:
                              NetworkImage(listdata.data![index].imageMedium),
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
                                      'IMDb: ${listdata.data![index].imdb}',
                                      style: const TextStyle(
                                        decoration: TextDecoration.underline,
                                        color: Colors.blue,
                                      ),
                                    ),
                                    onTap: () {
                                      launch(Uri.parse(
                                              'https://www.imdb.com/title/${listdata.data![index].imdb}')
                                          .toString());
                                    },
                                  ),
                                ],
                              ),
                              Spacer(),
                              Text('Rating: ${listdata.data![index].rating}'),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: HtmlWidget(
                            listdata.data![index].summary,
                            // style: const TextStyle(fontSize: 20.0),
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
