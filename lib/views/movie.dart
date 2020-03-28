import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Movie extends StatelessWidget {
  Future getMovieData() async {
    http.Response data = await http.get(
        "http://api.themoviedb.org/3/movie/${movieData['id']}/videos?api_key=802b2c4b88ea1183e50e6b285a27696e");
    var moviesList = jsonDecode(data.body);
    print(moviesList);
    return moviesList;
  }

  var movieData;
  Movie({this.movieData});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Movie"),
      ),
      body: FutureBuilder(
          future: getMovieData(), // async work
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return Center(child: CircularProgressIndicator());
              default:
                if (snapshot.hasError)
                  return Center(child: Text('No Internet'));
                else
                  return ListView(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Hero(
                            tag: movieData["id"],
                            child: Container(
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage("assets/logo.png"),
                                      fit: BoxFit.fill)),
                              margin: EdgeInsets.all(10),
                              height: 250,
                              width: 130,
                              child: Image.network(
                                "https://image.tmdb.org/t/p/w1280${movieData['poster_path']}",
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                movieData["title"],
                                style: TextStyle(fontWeight: FontWeight.bold),
                                overflow: TextOverflow.visible,
                              ),
                              Container(
                                  height: 100,
                                  width:
                                      MediaQuery.of(context).size.width - 150,
                                  child: Text(
                                    movieData["overview"],
                                    overflow: TextOverflow.visible,
                                    maxLines: 10,
                                  ))
                            ],
                          ),
                        ],
                      ),
                      Center(
                        child: Text("key from second api : ${snapshot.data["results"][0]["key"]}"),
                      )
                    ],
                  );
            }
          }),
    );
  }
}
