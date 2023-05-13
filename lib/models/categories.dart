class ProductCategory {
  int id;
  String name;
  String slug;
  int parent;
  dynamic image;

  ProductCategory({
    required this.id,
    required this.name,
    required this.slug,
    required this.parent,
    required this.image,
  });

  factory ProductCategory.fromJson(Map<String, dynamic> json) {
    return ProductCategory(
      id: json['id'],
      name: json['name'],
      slug: json['slug'],
      parent: json['parent'],
      image: json['image'],
    );
  }
}

class ImageData {
  int id;
  String dateCreated;
  String dateModified;
  String src;
  String name;
  String alt;

  ImageData({
    required this.id,
    required this.dateCreated,
    required this.dateModified,
    required this.src,
    required this.name,
    required this.alt,
  });

  factory ImageData.fromJson(Map<String, dynamic> json) {
    return ImageData(
      id: json['id'],
      dateCreated: json['date_created'],
      dateModified: json['date_modified'],
      src: json['src'],
      name: json['name'],
      alt: json['alt'],
    );
  }
}
