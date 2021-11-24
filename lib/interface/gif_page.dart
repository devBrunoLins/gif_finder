import 'package:flutter/material.dart';
import 'package:share/share.dart';

class GifPage extends StatelessWidget {
  final Map _gif;

  const GifPage(this._gif);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.black,
        title: Text(_gif['title']),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () => {
              Share.share(
                _gif['images']['fixed_height']['url'],
              ),
            },
          ),
        ],
      ),
      backgroundColor: Colors.black,
      body: Center(
        child: Image.network(_gif['images']['fixed_height']['url']),
      ),
    );
  }
}
