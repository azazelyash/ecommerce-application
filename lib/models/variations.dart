class Variation {
  final int id;
  final String name;
  final String imageUrl;
  final String price;
  final String regularPrice;
  final String salePrice;

  Variation({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.price,
    required this.regularPrice,
    required this.salePrice,
  });

  factory Variation.fromJson(Map<String, dynamic> json) {
    return Variation(
      id: json['id'],
      name: json['attributes'][0]['option'],
      imageUrl: (json['image'] == null) ? "https://www.generationsforpeace.org/wp-content/uploads/2018/03/empty.jpg" : json['image']['src'],
      price: (json['price']),
      regularPrice: (json['regular_price']),
      salePrice: (json['sale_price']),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'imageUrl': imageUrl,
        'price': price,
        'regularPrice': regularPrice,
        'salePrice': salePrice,
      };
}
