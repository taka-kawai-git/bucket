import 'package:bucket/models/bucket_item.dart';
import 'package:bucket/views/bucket_list_view.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const BucketApp());
}

class BucketApp extends StatelessWidget {
  const BucketApp({super.key});

  @override
  Widget build(BuildContext context) {
    // サンプルデータを作成
    final List<BucketItem> bucketItems = [
      BucketItem(url: 'https://tabelog.com/tokyo/A1301/A130101/13002522/'),
      BucketItem(url: 'https://flutter.dev'),
      BucketItem(url: 'https://github.com'),
    ];

    return MaterialApp(
      title: 'Bucket List',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BucketGridView(bucketItems: bucketItems),
    );
  }
}
