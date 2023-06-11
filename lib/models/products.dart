class Product {
  int id;
  String name;
  String slug;
  List<dynamic>? categories;
  List<dynamic>? tags;
  List<dynamic>? images;
  List<dynamic>? variations;
  String? status;
  bool? featured;
  String? description;
  String? shortDescription;
  String? price;
  String? regularPrice;
  String? salePrice;
  bool? onSale;
  bool? purchasable;
  // List<Attribute> attributes;
  // String permalink;
  // String dateCreated;
  // String dateCreatedGmt;
  // String dateModified;
  // String dateModifiedGmt;
  // String type;
  // String catalogVisibility;
  // String sku;
  // String dateOnSaleFrom;
  // String dateOnSaleFromGmt;
  // String dateOnSaleTo;
  // String dateOnSaleToGmt;
  // int totalSales;
  // bool virtual;
  // bool downloadable;
  // List<dynamic> downloads;
  // int downloadLimit;
  // int downloadExpiry;
  // String externalUrl;
  // String buttonText;
  // String taxStatus;
  // String taxClass;
  // bool manageStock;
  // int stockQuantity;
  // String backorders;
  // bool backordersAllowed;
  // bool backordered;
  // int lowStockAmount;
  // bool soldIndividually;
  // String weight;
  // Map<String, String> dimensions;
  // bool shippingRequired;
  // bool shippingTaxable;
  // String shippingClass;
  // int shippingClassId;
  // bool reviewsAllowed;
  // String averageRating;
  // int ratingCount;
  // List<int> upsellIds;
  // List<int> crossSellIds;
  // int parentId;
  // String purchaseNote;
  // List<int> defaultAttributes;
  // List<dynamic> groupedProducts;
  // int menuOrder;
  // String priceHtml;

  Product({
    required this.id,
    required this.name,
    required this.slug,
    required this.categories,
    required this.tags,
    required this.images,
    // required this.attributes,
    required this.variations,
    required this.status,
    required this.featured,
    required this.description,
    required this.shortDescription,
    required this.price,
    required this.regularPrice,
    required this.salePrice,
    required this.onSale,
    required this.purchasable,
    // required this.permalink,
    // required this.dateCreated,
    // required this.dateCreatedGmt,
    // required this.dateModified,
    // required this.dateModifiedGmt,
    // required this.type,
    // required this.catalogVisibility,
    // required this.sku,
    // required this.dateOnSaleFrom,
    // required this.dateOnSaleFromGmt,
    // required this.dateOnSaleTo,
    // required this.dateOnSaleToGmt,
    // required this.totalSales,
    // required this.virtual,
    // required this.downloadable,
    // required this.downloads,
    // required this.downloadLimit,
    // required this.downloadExpiry,
    // required this.externalUrl,
    // required this.buttonText,
    // required this.taxStatus,
    // required this.taxClass,
    // required this.manageStock,
    // required this.stockQuantity,
    // required this.backorders,
    // required this.backordersAllowed,
    // required this.backordered,
    // required this.lowStockAmount,
    // required this.soldIndividually,
    // required this.weight,
    // required this.dimensions,
    // required this.shippingRequired,
    // required this.shippingTaxable,
    // required this.shippingClass,
    // required this.shippingClassId,
    // required this.reviewsAllowed,
    // required this.averageRating,
    // required this.ratingCount,
    // required this.upsellIds,
    // required this.crossSellIds,
    // required this.parentId,
    // required this.purchaseNote,
    // required this.defaultAttributes,
    // required this.groupedProducts,
    // required this.menuOrder,
    // required this.priceHtml,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      slug: json['slug'],
      categories: json['categories'],
      tags: json['tags'],
      images: (json['images'] == null) ? image : json['images'],
      variations: json['variations'],
      status: json['status'],
      featured: json['featured'],
      description: json['description'],
      shortDescription: json['short_description'],
      price: json['price'],
      regularPrice: json['regular_price'],
      salePrice: json['sale_price'],
      onSale: json['on_sale'],
      purchasable: json['purchasable'],
    );
  }
}

var image = [
  {"src": "https://www.generationsforpeace.org/wp-content/uploads/2018/03/empty.jpg"}
];
