import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
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

  Color _colorTheme = Colors.purple;
  Color get colorTheme => _colorTheme;

  set colorTheme(Color newColor) {
    _colorTheme = newColor;
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
    Color pickerColor =
        Provider.of<ScreenModel>(context, listen: false).colorTheme;
    Color currentColor =
        Provider.of<ScreenModel>(context, listen: false).colorTheme;

    void changeColor(Color color) {
      setState(() => pickerColor = color);
    }

    final Color colorProvider = Provider.of<ScreenModel>(context).colorTheme;
    Color colorBackGround = Provider.of<ScreenModel>(context).colorTheme;
    return MaterialApp(
      darkTheme: ThemeData.dark(),
      themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
      theme: ThemeData.from(
        colorScheme: ColorScheme.fromSeed(seedColor: colorProvider),
      ),
      home: SafeArea(
        child: Consumer<ScreenModel>(builder: (context, screenModel, child) {
          return Scaffold(
            extendBodyBehindAppBar: true,
            appBar:
                Provider.of<ScreenModel>(context, listen: false).isFullScreen ==
                        true
                    ? null
                    : AppBar(
                        backgroundColor: isDark ? colorBackGround : null,
                        title: Center(
                          child: Text(
                            _selectedIndex == 0 ? 'Tv Shows' : 'Favorites',
                          ),
                        ),
                        actions: [
                          IconButton(
                            iconSize: 20,
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text('Pick a color!'),
                                    content: SingleChildScrollView(
                                      child: BlockPicker(
                                        pickerColor: pickerColor,
                                        onColorChanged: changeColor,
                                      ),
                                    ),
                                    actions: <Widget>[
                                      ElevatedButton(
                                        child: const Text('Got it'),
                                        onPressed: () {
                                          setState(
                                              () => currentColor = pickerColor);
                                          Provider.of<ScreenModel>(context,
                                                  listen: false)
                                              .colorTheme = pickerColor;

                                          Navigator.of(context).pop();
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              Provider.of<ScreenModel>(context)
                                                  .colorTheme,
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            icon: Icon(Icons.color_lens),
                          ),
                          IconButton(
                            icon: isDark
                                ? Icon(Icons.sunny)
                                : Icon(Icons.nights_stay),
                            onPressed: () {
                              setState(() {
                                MyApp(
                                  initialIndex: _selectedIndex,
                                ).toggleDarkMode();
                              });
                            },
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
              selectedItemColor:
                  Provider.of<ScreenModel>(context, listen: false).colorTheme,
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
}
