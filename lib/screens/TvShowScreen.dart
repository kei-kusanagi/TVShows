import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter/material.dart';
import 'package:tv_show/screens/Favorites.dart';
import 'package:tv_show/api/api.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' show jsonDecode, utf8;

class TvShow extends StatefulWidget {
  const TvShow({Key? key}) : super(key: key);
  @override
  State<TvShow> createState() => TvShowState();
}

class TvShowState extends State<TvShow> {
  String urlString =
      "https://api.giphy.com/v1/gifs/trending?api_key=GbT1BcYH7nEBK6r9bcmLwWIXLQKB1kTc&limit=10&rating=g";

  // late Future<List<Gif>?> _listadoGifs;

  Future<List<Gif>?> getGifs() async {
    final response = await http.get(Uri.parse(urlString));

    List<Gif> gifs = [];

    if (response.statusCode == 200) {
      String body = utf8.decode(response.bodyBytes);

      final jsonData = jsonDecode(body);
      for (var item in jsonData["data"]) {
        gifs.add(Gif(item["title"], item["images"]["downsized"]["url"]));
      }
      return gifs;
    } else {
      throw Exception("F en el chat");
    }
  }

  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //   _listadoGifs = getGifs();
  // }

  List<Show> shows = [
    Show(
        name: 'The Last of Us',
        image:
            'https://m.media-amazon.com/images/M/MV5BZGUzYTI3M2EtZmM0Yy00NGUyLWI4ODEtN2Q3ZGJlYzhhZjU3XkEyXkFqcGdeQXVyNTM0OTY1OQ@@._V1_UX67_CR0,0,67,98_AL_.jpg',
        rating: 9.3,
        synopsis: 'Synopsis 1',
        imdb: 'tt3581920'),
    Show(
        name: 'El menu',
        image:
            'https://m.media-amazon.com/images/M/MV5BMzdjNjI5MmYtODhiNS00NTcyLWEzZmUtYzVmODM5YzExNDE3XkEyXkFqcGdeQXVyMTAyMjQ3NzQ1._V1_QL75_UX280_CR0,3,280,414_.jpg',
        rating: 7.2,
        synopsis: 'Synopsis 2',
        imdb: 'tt9764362'),
    Show(
        name: 'TOP GUN MAVERICK',
        image:
            'https://m.media-amazon.com/images/M/MV5BZWYzOGEwNTgtNWU3NS00ZTQ0LWJkODUtMmVhMjIwMjA1ZmQwXkEyXkFqcGdeQXVyMjkwOTAyMDU@._V1_QL75_UX280_CR0,0,280,414_.jpg',
        rating: 8.3,
        synopsis: 'Synopsis 3',
        imdb: 'tt1745960'),
    Show(
        name: 'Avatar: El sentido del agua',
        image:
            'https://m.media-amazon.com/images/M/MV5BYjhiNjBlODctY2ZiOC00YjVlLWFlNzAtNTVhNzM1YjI1NzMxXkEyXkFqcGdeQXVyMjQxNTE1MDA@._V1_QL75_UY414_CR5,0,280,414_.jpg',
        rating: 7.8,
        synopsis: 'Synopsis 4',
        imdb: 'tt1630029'),
    Show(
        name: 'Miercoles',
        image:
            'https://m.media-amazon.com/images/M/MV5BMjllNDU5YjAtOGM1Zi00ZTRiLWI0OWItYjc5ZmUxODBiYTJmXkEyXkFqcGdeQXVyMTU2Mjg2NjE2._V1_QL75_UX280_CR0,0,280,414_.jpg',
        rating: 8.2,
        synopsis: 'Synopsis 5',
        imdb: 'tt13443470'),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Tv Show's 🖥"),
          backgroundColor: Colors.purple,
        ),
        bottomNavigationBar: BottomAppBar(
          color: Colors.purple,
          child: Row(
            children: <Widget>[
              Expanded(
                child: ElevatedButton(
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.purple),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => TvShow()),
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const <Widget>[
                      Icon(Icons.tv),
                      SizedBox(
                        width: 10,
                        height: 50,
                      ),
                      Text("TV Show's"),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: ElevatedButton(
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.purple),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Favorites()),
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const <Widget>[
                      Icon(Icons.favorite),
                      SizedBox(
                        width: 10,
                        height: 50,
                      ),
                      Text("Favoritos"),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        body: FutureBuilder(
            // future: _listadoGifs,
            builder: (context, snapshot) {
          if (snapshot.hasData) {
            return GridView.count(
              crossAxisCount: 2,
              // children: _listGifs(snapshot.data),
            );
          } else if (snapshot.hasError) {
            print(snapshot.error);
            return Text("Error");
          }
          return ListView.builder(
            itemCount: shows.length,
            itemBuilder: (context, index) {
              return Slidable(
                key: Key(shows[index].toString()),
                endActionPane: ActionPane(
                  motion: ScrollMotion(),
                  children: [
                    SlidableAction(
                      onPressed: (BuildContext context) {
                        setState(() {
                          favorites.add(shows[index]);
                        });
                      },
                      backgroundColor: Colors.yellow,
                      foregroundColor: Colors.black,
                      icon: Icons.save,
                      label: 'Añadir a Favoritos',
                    ),
                  ],
                ),
                child: ListTile(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text("Mensaje"),
                          content: Text("desplegar pantalla de detalles"),
                          actions: <Widget>[
                            TextButton(
                              child: Text("Cerrar"),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                  leading: Image(
                    image: NetworkImage(shows[index].image),
                  ),
                  title: Text(shows[index].name),
                  subtitle: Text(shows[index].imdb),
                  trailing: const Icon(Icons.arrow_forward_ios_rounded,
                      color: Colors.grey),
                ),
              );
            },
          );
        }),
      ),
    );
  }

  // void deleteTVshow(BuildContext context, TVshow) {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: Text("Eliminar Show"),
  //         content:
  //             Text('${"¿Esta seguro de querer eliminar a " + TVshow.name}?'),
  //         actions: [
  //           TextButton(
  //             onPressed: () {
  //               Navigator.pop(context);
  //             },
  //             child: Text(
  //               'Cancelar',
  //             ),
  //           ),
  //           TextButton(
  //             onPressed: () {
  //               if (mounted) {
  //                 setState(() {
  //                   TVShows.remove(TVshow);
  //                 });
  //               }
  //               Navigator.pop(context);
  //             },
  //             child: Text(
  //               'Borrar',
  //               style: TextStyle(color: Colors.red),
  //             ),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  // List<Widget> _listGifs(data) {
  //   List<Widget> gifs = [];
  //
  //   for (var gif in data) {
  //     gifs.add(Card(
  //         child: Padding(
  //       padding: const EdgeInsets.all(8.0),
  //       child: Column(
  //         children: [
  //           Expanded(
  //               child: Image.network(
  //             gif.url,
  //             fit: BoxFit.fill,
  //           )),
  //         ],
  //       ),
  //     )));
  //   }
  //   return gifs;
  // }
}

// class Show {
//   late String name;
//   late String imdb;
//   late double rating;
//   late String image;
//   late String synopsis;
//
//   show(name, imdb, rating, ImageLink) {
//     this.name = name;
//     this.imdb = imdb;
//     this.rating = rating;
//     this.image = ImageLink;
//     this.synopsis;
//   }
// }
class Show {
  final String name;
  final String image;
  final double rating;
  final String synopsis;
  final String imdb;

  Show(
      {required this.name,
      required this.image,
      required this.rating,
      required this.synopsis,
      required this.imdb});
}

void doNothing(context) {}

toggleFavorite() {
  print('AGREGADO');
  // favorites.add(shows[index]);
}
