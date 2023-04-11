import 'package:flutter/material.dart';
import 'package:tv_show/screens/Favorites.dart';
import 'package:tv_show/sql/sql_helper.dart';
import 'screens/TvShowScreen.dart';
import 'package:tv_show/screens/DetailScreen.dart';

bool _isDark = false;
get isDark => _isDark;

void toggleDarkMode() {
  _isDark = !_isDark;
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final database = await SQLHelper.db();
  bool isDatabaseCreated = await SQLHelper.isDatabaseCreated();
  if (!isDatabaseCreated) {
    await SQLHelper.createTables(database);
    await SQLHelper.populateDatabase();
    await SQLHelper.setDatabaseCreated();
  }
  int initialIndex = 0;

  runApp(MyApp(initialIndex: initialIndex));
}

class MyApp extends StatefulWidget {
  final int initialIndex;

  MyApp({required this.initialIndex});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      darkTheme: ThemeData.dark(),
      themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
      home: SafeArea(
        child: Scaffold(
          // appBar: MainAppBar(),
          appBar: AppBar(
            title: Center(
              child: Text(_selectedIndex == 0 ? 'Tv Shows' : 'Favorites'),
            ),
            backgroundColor: Colors.purple,
            actions: [
              IconButton(
                icon: isDark ? Icon(Icons.sunny) : Icon(Icons.nights_stay),
                onPressed: () {
                  setState(() {
                    toggleDarkMode();
                  });
                },
                // onPressed: () => toggleDarkMode(),
              ),
            ],
          ),
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
                  icon: Icon(Icons.favorite), label: 'Favorites'),
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

  AppBar MainAppBar() {
    return AppBar(
      title: Center(
        child: Text(_selectedIndex == 0 ? 'Tv Shows' : 'Favorites'),
      ),
      backgroundColor: Colors.purple,
      actions: [
        IconButton(
          icon: isDark ? Icon(Icons.sunny) : Icon(Icons.nights_stay),
          onPressed: () {
            setState(() {
              toggleDarkMode();
            });
          },
          // onPressed: () => toggleDarkMode(),
        ),
      ],
    );
  }
}

// AppBar DetailScreenAppBar(bool isFavorite, BuildContext context) {
//   return AppBar(
//     actions: [
//       Padding(
//         padding: const EdgeInsets.all(15.0),
//         child: LikeButton(
//           bubblesSize: 75,
//           animationDuration: const Duration(milliseconds: 1500),
//           bubblesColor: isFavorite
//               ? const BubblesColor(
//               dotPrimaryColor: Colors.purpleAccent,
//               dotSecondaryColor: Colors.greenAccent)
//               : const BubblesColor(
//             dotPrimaryColor: Colors.white,
//             dotSecondaryColor: Colors.redAccent,
//           ),
//           likeBuilder: (isTapped) {
//             return isFavorite
//                 ? const Icon(
//               Icons.favorite,
//               color: Colors.purple,
//               size: 30,
//             )
//                 : const Icon(
//               size: 30,
//               Icons.favorite_border,
//             );
//           },
//           onTap: (isLiked) async {
//             if (isFavorite) {
//               SQLHelper.updateFavorite(showData['id'], false);
//               ScaffoldMessenger.of(context).hideCurrentSnackBar();
//               ScaffoldMessenger.of(context).showSnackBar(
//                 const SnackBar(
//                     content: Text('Removed to Favorites'),
//                     duration: Duration(seconds: 1)),
//               );
//             } else {
//               SQLHelper.updateFavorite(showData['id'], true);
//               ScaffoldMessenger.of(context).hideCurrentSnackBar();
//               ScaffoldMessenger.of(context).showSnackBar(
//                 const SnackBar(
//                     content: Text('Added to Favorites',
//                         textAlign: TextAlign.right),
//                     duration: Duration(seconds: 1)),
//               );
//             }
//             return !isLiked;
//           },
//         ),
//       ),
//     ],
//     backgroundColor: Colors.orangeAccent,
//     title: Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text(
//           'TV Shows',
//           style: TextStyle(fontSize: 16),
//         ),
//         Text(
//           showData['name'],
//           style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//         ),
//       ],
//     ),
//   );
// }
