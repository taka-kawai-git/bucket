import 'package:bucket/models/ogp_data.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class OGPController {
  // OGP データを取得するメソッド
  Future<OGPData?> fetchOGPData(String url) async {
    final requestUrl =
        'https://api.microlink.io/?url=${Uri.encodeComponent(url)}';

    try {
      final response = await http.get(Uri.parse(requestUrl));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        final title = data['data']['title'] ?? 'No title';
        final description = data['data']['description'] ?? 'No description';
        final imageUrl =
            data['data']['image'] != null ? data['data']['image']['url'] : '';

        print(imageUrl);

        return OGPData(
          title: title,
          description: description,
          imageUrl: imageUrl,
        );
      } else {
        print('Failed to fetch OGP data: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error fetching OGP data: $e');
      return null;
    }
  }
}
