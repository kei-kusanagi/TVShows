import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter/material.dart';
import 'package:tv_show/api/api.dart';

class TvShow extends StatefulWidget {
  @override
  State<TvShow> createState() => TvShowState();
}

class TvShowState extends State<TvShow> {
  String urlString =
      "https://api.giphy.com/v1/gifs/trending?api_key=GbT1BcYH7nEBK6r9bcmLwWIXLQKB1kTc&limit=10&rating=g";

  // List<Show> shows = [
  //   Show(
  //       name: 'The Last of Us',
  //       image:
  //           'https://m.media-amazon.com/images/M/MV5BZGUzYTI3M2EtZmM0Yy00NGUyLWI4ODEtN2Q3ZGJlYzhhZjU3XkEyXkFqcGdeQXVyNTM0OTY1OQ@@._V1_UX67_CR0,0,67,98_AL_.jpg',
  //       rating: 9.3,
  //       synopsis: 'Synopsis 1',
  //       imdb: 'tt3581920'),
  //   Show(
  //       name: 'El menu',
  //       image:
  //           'https://m.media-amazon.com/images/M/MV5BMzdjNjI5MmYtODhiNS00NTcyLWEzZmUtYzVmODM5YzExNDE3XkEyXkFqcGdeQXVyMTAyMjQ3NzQ1._V1_QL75_UX280_CR0,3,280,414_.jpg',
  //       rating: 7.2,
  //       synopsis: 'Synopsis 2',
  //       imdb: 'tt9764362'),
  //   Show(
  //       name: 'TOP GUN MAVERICK',
  //       image:
  //           'https://m.media-amazon.com/images/M/MV5BZWYzOGEwNTgtNWU3NS00ZTQ0LWJkODUtMmVhMjIwMjA1ZmQwXkEyXkFqcGdeQXVyMjkwOTAyMDU@._V1_QL75_UX280_CR0,0,280,414_.jpg',
  //       rating: 8.3,
  //       synopsis: 'Synopsis 3',
  //       imdb: 'tt1745960'),
  //   Show(
  //       name: 'Avatar: El sentido del agua',
  //       image:
  //           'https://m.media-amazon.com/images/M/MV5BYjhiNjBlODctY2ZiOC00YjVlLWFlNzAtNTVhNzM1YjI1NzMxXkEyXkFqcGdeQXVyMjQxNTE1MDA@._V1_QL75_UY414_CR5,0,280,414_.jpg',
  //       rating: 7.8,
  //       synopsis: 'Synopsis 4',
  //       imdb: 'tt1630029'),
  //   Show(
  //       name: 'Miercoles',
  //       image:
  //           'https://m.media-amazon.com/images/M/MV5BMjllNDU5YjAtOGM1Zi00ZTRiLWI0OWItYjc5ZmUxODBiYTJmXkEyXkFqcGdeQXVyMTU2Mjg2NjE2._V1_QL75_UX280_CR0,0,280,414_.jpg',
  //       rating: 8.2,
  //       synopsis: 'Synopsis 5',
  //       imdb: 'tt13443470'),
  // ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Center(child: const Text("TV Shows")),
          backgroundColor: Colors.purple,
        ),
        // body: FutureBuilder(
        //     future: fetchShows(),
        //     builder: (context, snapshot) {
        //       if (snapshot.hasData) {
        //         return GridView.count(
        //           crossAxisCount: 2,
        //         );
        //       } else if (snapshot.hasError) {
        //         print(snapshot.error);
        //         return Text("Error");
        //       }
        //       return ListView.builder(
        //         itemCount: shows.length,
        //         itemBuilder: (context, index) {
        //           var labelColor = Colors.green;
        //           var labelText = 'Add to Favorites';
        //           return Slidable(
        //             key: Key(shows[index].toString()),
        //             endActionPane: ActionPane(
        //               motion: ScrollMotion(),
        //               children: [
        //                 SlidableAction(
        //                   onPressed: (BuildContext context) {
        //                     setState(
        //                       () {
        //                         // var check = shows[index].imdb;
        //                         if (!favorites.contains(shows[index])) {
        //                           print(shows[index]);
        //                           // print(check);
        //                           // favorites.forEach((show) => print(show.imdb));
        //                           favorites.add(shows[index]);
        //                         } else {
        //                           ScaffoldMessenger.of(context).showSnackBar(
        //                             SnackBar(
        //                               content: Text(
        //                                   'This item is already in your favorites list.'),
        //                               duration: Duration(seconds: 2),
        //                             ),
        //                           );
        //                         }
        //                       },
        //                     );
        //                   },
        //                   // backgroundColor: Colors.green,
        //                   backgroundColor: labelColor,
        //                   foregroundColor: Colors.black,
        //                   icon: Icons.save,
        //                   // label: 'Añadir a Favoritos',
        //                   label: labelText,
        //                 ),
        //               ],
        //             ),
        //             child: ListTile(
        //               onTap: () {
        //                 Navigator.push(
        //                   context,
        //                   MaterialPageRoute(
        //                     fullscreenDialog: true,
        //                     builder: (BuildContext context) {
        //                       return FullScreenDialog(shows[index].synopsis);
        //                     },
        //                   ),
        //                 );
        //               },
        //               leading: Image(
        //                 image: NetworkImage(snapshot.data![index].imageMedium),
        //               ),
        //               title: Text(snapshot.data![index].name),
        //               trailing: const Icon(Icons.arrow_forward_ios_rounded,
        //                   color: Colors.grey),
        //             ),
        //           );
        //         },
        //       );
        //     }),
        body: Center(
          child: FutureBuilder<List<Show>>(
            future: fetchShows(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                        title: Text(snapshot.data![index].name),
                        leading:
                            Image.network(snapshot.data![index].imageMedium),
                      ),
                    );
                  },
                );
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }
              return CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }
}

class FullScreenDialog extends StatelessWidget {
  final String synopsis;

  FullScreenDialog(this.synopsis);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Resumen"),
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: Text(synopsis),
      ),
    );
  }
}
