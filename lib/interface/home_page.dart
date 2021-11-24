import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gif_finder/interface/gif_page.dart';
import 'package:http/http.dart' as http;
import 'package:share/share.dart';
import 'package:transparent_image/transparent_image.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _search = '';
  int _offSet = 0;

  Future<Map> _getGifs() async {
    http.Response response;

    if (_search.isEmpty)
      response = await http.get(Uri.parse(
          'https://api.giphy.com/v1/gifs/trending?api_key=VJVWpCJPRvprpEwEkCAyMwH2Db5PYelV&limit=20&rating=g'));
    else {
      response = await http.get(Uri.parse(
          'https://api.giphy.com/v1/gifs/search?api_key=VJVWpCJPRvprpEwEkCAyMwH2Db5PYelV&q=$_search&limit=19&offset=$_offSet&rating=g&lang=en'));
    }

    return json.decode(response.body);
  }

  @override
  void initState() {
    super.initState();

    _getGifs().then(
      (map) => {
        print(map),
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        title: Image.network(
            'https://developers.giphy.com/branch/master/static/header-logo-0fec0225d189bc0eae27dac3e3770582.gif'),
      ),
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: TextField(
              decoration: const InputDecoration(
                  labelText: 'Pesquise aqui',
                  labelStyle: TextStyle(color: Colors.white),
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.search, color: Colors.white),
                  prefixStyle: TextStyle(color: Colors.amber)),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
              textAlign: TextAlign.center,
              onSubmitted: (text) {
                setState(() {
                  _search = text;
                  _offSet = 0;
                });
              },
            ),
          ),
          Expanded(
            child: FutureBuilder(
              future: _getGifs(),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                  case ConnectionState.none:
                    return Container(
                      width: 200,
                      height: 200,
                      alignment: Alignment.center,
                      child: const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        strokeWidth: 2,
                      ),
                    );
                  default:
                    if (snapshot.hasError) {
                      return const Text(
                          'Encontramos um erro ao carregar os gifs');
                    } else {
                      return _createGrid(context, snapshot);
                    }
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  int _getCount(List data) {
    if (_search.isEmpty) {
      return data.length;
    } else {
      return data.length + 1;
    }
  }

  Widget _createGrid(BuildContext context, AsyncSnapshot snapshot) {
    return GridView.builder(
      padding: const EdgeInsets.all(15),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, crossAxisSpacing: 10, mainAxisSpacing: 10),
      itemCount: _getCount(snapshot.data['data']),
      itemBuilder: (context, index) {
        if (_search.isEmpty || index < snapshot.data['data'].length) {
          return GestureDetector(
              child: FadeInImage.memoryNetwork(
                  placeholder: kTransparentImage,
                  image: snapshot.data['data'][index]['images']['fixed_height']
                      ['url'],
                  height: 300,
                  fit: BoxFit.cover),
              onTap: () => {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            GifPage(snapshot.data['data'][index]),
                      ),
                    ),
                  },
              onLongPress: () {
                Share.share(
                  snapshot.data['data'][index]['images']['fixed_height']['url'],
                );
              });
        } else {
          return Container(
            child: GestureDetector(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.add, color: Colors.white, size: 70),
                    Text(
                      'Carregar mais...',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
                onTap: () => {
                      setState(() => {
                            _offSet += 19,
                          }),
                    }),
          );
        }
      },
    );
  }
}
