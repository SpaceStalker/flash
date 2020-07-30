import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/ImageModel.dart';
import 'package:http/http.dart' as http;

void main() => runApp(ImageApp());

class ImageApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Image App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ImageShowPage(),
    );
  }
}

class ImageShowPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Images List'),
      ),
      body: FutureBuilder<List<ImageModel>>(
        future: fetchImages(http.Client(), 1),
        builder: (context, snapshot) {
          if (snapshot.hasError) print(snapshot.error);
          return snapshot.hasData
              ? ImagesList(images: snapshot.data)
              : Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

class ImagesList extends StatelessWidget {
  final List<ImageModel> images;

  ImagesList({Key key, this.images}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate:
          SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount:3),
      itemCount: images.length,
      itemBuilder: (context, index) {
        return images[index].urls.thumb == null ? Center(child: Text('not loaded'),) : Image.network(images[index].urls.thumb,);
      },
    );
  }
}

Future<List<ImageModel>> fetchImages(http.Client client, int page) async {
  final response = await client.get(
      'https://api.unsplash.com/photos?page=$page&per_page=30&order_by=popular&client_id=RmjqqPe-x1ygZCc4JDr-K-7QQU7WLolfcPTYO5XlDNY');
  return compute(parseImages, response.body);
}

List<ImageModel> parseImages(String responseBody) {
  return imagesFromJson(responseBody);
}
