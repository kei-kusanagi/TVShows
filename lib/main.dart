import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tv_show/screens/Favorites.dart';
import 'package:tv_show/sql/sql_helper.dart';
import 'api/api.dart';
import 'screens/TvShowScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final database = await SQLHelper.db();
  await SQLHelper.createTables(database);
  await populateDatabase(database);
  runApp(MyApp());
}

Future<void> populateDatabase(Database database) async {
  final shows = await fetchShows();
  for (final show in shows) {
    await SQLHelper.createItem(
      show.id,
      show.name,
      show.summary,
      show.imageOriginal,
      show.imageMedium,
      show.imdb,
      show.rating,
    );
  }
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // home: TvShow(),
      home: SafeArea(
        child: Scaffold(
          body: PageView(
            physics: BouncingScrollPhysics(),
            children: <Widget>[
              _selectedIndex == 0 ? TvShow() : Favorites(),
            ],
          ),
          bottomNavigationBar: BottomNavigationBar(
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.live_tv_outlined),
                label: 'TV Shows',
              ),
              BottomNavigationBarItem(
                  icon: Icon(Icons.favorite), label: 'Favorites')
            ],
            currentIndex: _selectedIndex,
            selectedItemColor: Colors.purple[800],
            onTap: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
          ),
        ),
      ),
    );
  }
}
