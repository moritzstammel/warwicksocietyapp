class TestHolder {

  final String title;
  final String imageUrl;
  final int order;

  TestHolder({required this.title, required this.imageUrl,required this.order});

  factory TestHolder.fromJson(Map<String, dynamic> json) {

    return TestHolder(title: json["title"], imageUrl: json["image_url"], order: json["order"]);
  }

  @override
  String toString() {
    return title;
  }
}