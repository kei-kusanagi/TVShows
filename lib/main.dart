import 'package:flutter/material.dart';
import 'package:tv_show/screens/Favorites.dart';
import 'package:tv_show/sql/sql_helper.dart';
import 'screens/TvShowScreen.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';

class ScreenModel extends ChangeNotifier {
  bool _isFullScreen = false;

  bool get isFullScreen => _isFullScreen;

  set isFullScreen(bool value) {
    _isFullScreen = value;
    notifyListeners();
  }
}

bool _isDark = false;
get isDark => _isDark;

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

  runApp(
    ChangeNotifierProvider(
      create: (_) => ScreenModel(),
      child: MyApp(initialIndex: initialIndex),
    ),
  );
}

class MyApp extends StatefulWidget {
  void toggleDarkMode() {
    _isDark = !_isDark;
  }

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
        child: Consumer<ScreenModel>(builder: (context, screenModel, child) {
          return Scaffold(
            extendBodyBehindAppBar: true,
            appBar: Provider.of<ScreenModel>(context).isFullScreen
                ? null
                : MainAppbar(),
            // MainAppbar(),
            body: PageView(
              physics: BouncingScrollPhysics(),
              children: <Widget>[
                _selectedIndex == 0 ? TvShow() : Favorites(),
              ],
            ),
            bottomNavigationBar: BottomNavigationBar(
              // backgroundColor: Colors.grey,
              // unselectedItemColor: Colors.white,
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
                  Provider.of<ScreenModel>(context, listen: false)
                      .isFullScreen = false;
                });
              },
            ),
          );
        }),
      ),
    );
  }

  AppBar MainAppbar() {
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
              MyApp(
                initialIndex: _selectedIndex,
              ).toggleDarkMode();
            });
          },
        ),
      ],
    );
  }
}
