import 'package:flutter/material.dart';
import 'package:tv_show/screens/Favorites.dart';
import 'screens/TvShowScreen.dart';

void main() {
  runApp(MyApp());
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
      home: Scaffold(
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
    );
  }
}
