class Coupon {
  int? id;
  String? code;
  String? amount;
  String? discountType;
  String? dateExpires;
  dynamic productCategories;
  String? minimumAmount;
  String? maximumAmount;

  Coupon({
    this.id,
    this.code,
    this.amount,
    this.discountType,
    this.dateExpires,
    this.productCategories,
    this.minimumAmount,
    this.maximumAmount,
  });

  factory Coupon.fromJson(Map<String, dynamic> json) {
    return Coupon(
      id: json['id'],
      code: json['code'],
      amount: json['amount'],
      discountType: json['discount_type'],
      dateExpires: json['date_expires'],
      productCategories: json['product_categories'],
      minimumAmount: json['minimum_amount'],
      maximumAmount: json['maximum_amount'],
    );
  }
}
