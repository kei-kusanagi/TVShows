import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:like_button/like_button.dart';
import 'package:provider/provider.dart';
import 'package:tv_show/main.dart';
import '../sql/sql_helper.dart';
import 'package:url_launcher/url_launcher.dart';

class Favorites extends StatefulWidget {
  const Favorites({Key? key}) : super(key: key);

  @override
  State<Favorites> createState() => FavoritesState();
}

class FavoritesState extends State<Favorites> {
  late Future<List<Map<String, dynamic>>> favoritesFuture;

  late bool slidable;

  @override
  void initState() {
    super.initState();
    favoritesFuture = SQLHelper.getFavorites();
  }

  // final GlobalVariables globalVariables = GlobalVariables();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      darkTheme: ThemeData.dark(),
      themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
      home: SafeArea(
        child: Scaffold(
          // appBar: MainAppBar(),
          body: FutureBuilder<List<Map<String, dynamic>>>(
            future: favoritesFuture,
            builder: (BuildContext context,
                AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
              if (snapshot.hasData) {
                final favorites = snapshot.data!;

                return ListView.builder(
                  itemCount: favorites.length,
                  itemBuilder: (context, index) {
                    final favorite = favorites[index];
                    return Slidable(
                      key: Key(favorite.toString()),
                      endActionPane: ActionPane(
                        motion: const ScrollMotion(),
                        children: [
                          SlidableAction(
                            onPressed: (BuildContext context) {
                              deleteTVshow(context, favorites[index]['id'],
                                  favorites[index]['name'], true);
                            },
                            backgroundColor: const Color(0xFFFE4A49),
                            foregroundColor: Colors.white,
                            icon: Icons.delete,
                            label: 'Remove from Favorites',
                          ),
                        ],
                      ),
                      child: ListTile(
                        // onTap: () {
                        //   Navigator.of(context).push(MaterialPageRoute(
                        //     builder: (context) => _showDetail(favorite),
                        //   ));
                        // },
                        onTap: () {
                          Provider.of<ScreenModel>(context, listen: false)
                              .isFullScreen = true;
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => _showDetail(favorite)));
                        },
                        title: Text(favorite['name']),
                        leading: CachedImage(favorite),
                        trailing: const Icon(Icons.arrow_forward_ios_rounded,
                            color: Colors.grey),
                      ),
                    );
                  },
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('Error: ${snapshot.error}'),
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
        ),
      ),
    );
  }

  late String showName;
  deleteTVshow(context, id, showName, bool slidable) async {
    if (Theme.of(context).platform == TargetPlatform.iOS) {
      await showDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title:
              const Text("Remove to Favorites\n", textAlign: TextAlign.center),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text('Are you sure you want to remove\n'),
              RichText(
                text: TextSpan(
                  style: DefaultTextStyle.of(context).style,
                  children: <TextSpan>[
                    TextSpan(
                      text: '$showName',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.purpleAccent),
                    ),
                  ],
                ),
              ),
              const Text('\n from favorites?'),
            ],
          ),
          actions: [
            CupertinoDialogAction(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                'Cancel',
              ),
            ),
            CupertinoDialogAction(
              isDestructiveAction: true,
              onPressed: () async {
                await SQLHelper.updateFavorite(id, false);
                setState(() {
                  favoritesFuture = SQLHelper.getFavorites();
                });
                if (slidable == false) {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) => MaterialApp(
                                home: MyApp(
                              initialIndex: 1,
                            ))),
                  );
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
        ),
      );
    } else {
      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Remove to Favorites", textAlign: TextAlign.center),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text('Are you sure you want to remove\n'),
              RichText(
                text: TextSpan(
                  style: DefaultTextStyle.of(context).style,
                  children: <TextSpan>[
                    TextSpan(
                      text: '$showName',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.purpleAccent),
                    ),
                  ],
                ),
              ),
              const Text('\n from favorites?'),
            ],
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'Cancel',
                    ),
                  ),
                ),
                Expanded(
                  child: TextButton(
                    onPressed: () async {
                      await SQLHelper.updateFavorite(id, false);
                      setState(() {
                        favoritesFuture = SQLHelper.getFavorites();
                      });
                      if (slidable == false) {
                        Navigator.pop(context);
                        Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (context) => MaterialApp(
                                      home: MyApp(
                                    initialIndex: 1,
                                  ))),
                        );
                      } else {
                        Navigator.pop(context);
                      }
                    },
                    child: const Text(
                      'Remove',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }
  }

  _showDetail(Map<String, dynamic> showData) {
    return SafeArea(
      child: Scaffold(
        appBar: FavoriteAppBar(showData),
        body: SingleChildScrollView(
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              final double screenWidth = constraints.maxWidth;

              if (screenWidth > 600) {
                // Pantalla grande
                return Row(
                  children: [
                    Expanded(
                      child: CachedImage(showData),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
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
                            Padding(
                              padding: const EdgeInsets.only(right: 12.0),
                              child: SingleChildScrollView(
                                child: HtmlWidget(
                                  '<div style="text-align: justify;">${showData['summary']}</div>',
                                  // style: const TextStyle(fontSize: 20.0),
                                ),
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
                      CachedImage(showData),
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
      ),
    );
  }

  AppBar FavoriteAppBar(Map<String, dynamic> showData) {
    return AppBar(
      actions: [
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: LikeButton(
            bubblesSize: 75,
            animationDuration: const Duration(milliseconds: 1500),
            bubblesColor: const BubblesColor(
              dotPrimaryColor: Colors.red,
              dotSecondaryColor: Colors.white,
            ),
            likeBuilder: (isTapped) {
              return Icon(
                Icons.delete,
                color: Colors.red[800],
                size: 30,
              );
            },
            onTap: (isLiked) async {
              await deleteTVshow(
                  context, showData['id'], showData['name'], false);
              Provider.of<ScreenModel>(context, listen: false).isFullScreen =
                  false;
              return true;
            },
          ),
        ),
      ],
      backgroundColor: Colors.orangeAccent,
      leading: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {
          Provider.of<ScreenModel>(context, listen: false).isFullScreen = false;
          Navigator.of(context).push(
            MaterialPageRoute(
                builder: (context) => MaterialApp(
                        home: MyApp(
                      initialIndex: 1,
                    ))),
          );
        },
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Favorites',
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

  CachedNetworkImage CachedImage(Map<String, dynamic> showData) {
    return CachedNetworkImage(
      imageUrl: showData['imageMedium'],
      height: 250,
      placeholder: (context, url) => const CircularProgressIndicator(),
      errorWidget: (context, url, error) =>
          const Icon(Icons.network_check_outlined),
    );
  }

  AppBar MainAppBar() {
    return AppBar(
      title: const Center(
        child: Text('Favorites'),
      ),
      backgroundColor: Colors.purple,
      actions: [
        IconButton(
          icon: isDark ? Icon(Icons.sunny) : Icon(Icons.nights_stay),
          onPressed: () {
            setState(() {
              MyApp(
                initialIndex: 1,
              ).toggleDarkMode();
            });
          },
          // onPressed: () => toggleDarkMode(),
        ),
      ],
      // forceMaterialTransparency: true,
      // automaticallyImplyLeading: false,
    );
  }
}
