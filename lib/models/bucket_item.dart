class BucketItem {
  final String url;
  String? title;
  String? description;
  String? imageUrl;

  BucketItem({required this.url, this.title, this.description, this.imageUrl});

  void updateOGPInfo(String title, String description, String imageUrl) {
    this.title = title;
    this.description = description;
    this.imageUrl = imageUrl;
  }
}
