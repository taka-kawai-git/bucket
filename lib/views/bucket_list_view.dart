import 'package:bucket/models/ogp_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../models/bucket_item.dart';
import '../controllers/ogp_controller.dart';

class BucketGridView extends StatefulWidget {
  final List<BucketItem> bucketItems;

  const BucketGridView({super.key, required this.bucketItems});

  @override
  _BucketGridViewState createState() => _BucketGridViewState();
}

class _BucketGridViewState extends State<BucketGridView> {
  final OGPController ogpController = OGPController();

  @override
  Widget build(BuildContext context) {
    // 画面の幅を取得
    final screenWidth = MediaQuery.of(context).size.width;
    // デスクトップ環境かどうかを判定（幅が600以上の場合をデスクトップとみなす）
    final isDesktop = screenWidth >= 600;

    // コンテンツの最大幅を設定
    final contentMaxWidth = isDesktop ? screenWidth / 3 : screenWidth;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        leading: const Text(
          'Bucket List',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.black,
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: contentMaxWidth,
          ),
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // 1行に2つのアイテムを表示
              childAspectRatio: 0.75, // アイテムの縦横比を設定
              crossAxisSpacing: 10, // アイテム間の横スペース
              mainAxisSpacing: 10, // アイテム間の縦スペース
            ),
            shrinkWrap: true,
            itemCount: widget.bucketItems.length,
            padding: const EdgeInsets.all(10),
            itemBuilder: (context, index) {
              final item = widget.bucketItems[index];

              // FutureBuilderを使って非同期処理の結果を待つ
              return FutureBuilder<OGPData?>(
                future: ogpController.fetchOGPData(item.url),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Card(
                      child: Center(child: Text('Loading...')),
                    );
                  } else if (snapshot.hasError) {
                    return const Card(
                      child: Center(child: Text('Error loading data')),
                    );
                  } else if (snapshot.hasData) {
                    final ogpData = snapshot.data!;
                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      color: Colors.grey[50],
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          SizedBox(
                            height: 150,
                            child: ogpData.imageUrl.isNotEmpty
                                ? ClipRRect(
                                    borderRadius: const BorderRadius.vertical(
                                      top: Radius.circular(
                                          16.0), // カードの角丸と同じ値を使用
                                    ),
                                    child: Image.network(
                                      ogpData.imageUrl,
                                      fit: BoxFit.fitWidth,
                                    ),
                                  )
                                : const Icon(
                                    Icons.link,
                                    size: 80,
                                    color: Colors.grey,
                                  ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(
                              ogpData.title ?? 'No title',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 5.0),
                            child: Text(
                              ogpData.description ?? '',
                              style: const TextStyle(
                                fontSize: 12,
                              ),
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    );
                  } else {
                    return const Card(
                      child: Center(child: Text('No data')),
                    );
                  }
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
