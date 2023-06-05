import 'dart:developer';

import 'package:abhyukthafoods/services/shared_services.dart';
import 'package:flutter/material.dart';

List<CartDetails> cartItems = [];
ValueNotifier<int> cartCount = ValueNotifier<int>(0);

class CartDetails {
  int id;
  String name;
  String? image;
  String? description;
  String? price;
  int quantity;

  CartDetails({
    required this.id,
    required this.name,
    required this.description,
    required this.image,
    required this.price,
    required this.quantity,
  });

  factory CartDetails.fromJson(Map<String, dynamic> json) {
    return CartDetails(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      image: json['image'],
      price: json['price'],
      quantity: json['quantity'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'image': image,
        'price': price,
        'quantity': quantity,
      };
}

class Cart {
  void addItemToCart(CartDetails item) {
    // check if the cart already has the item id then increase the quantity

    if (cartItems.any((cartObject) => cartObject.id == item.id)) {
      int itemIndex = cartItems.indexWhere((element) => element.id == item.id);
      cartItems[itemIndex].quantity += 1;
      return;
    }
    cartItems.add(item);
    updateCartLength();
    SharedService.setCartDetails(cartItems);
  }

  void decreaseItemQuantity(CartDetails item) {
    // check if the cart already has only 1 item then decrease the quantity
    if (cartItems[cartItems.indexOf(item)].quantity == 1) {
      cartItems.remove(item);
      updateCartLength();
      SharedService.setCartDetails(cartItems);

      return;
    }
    cartItems[cartItems.indexOf(item)].quantity -= 1;
    updateCartLength();
  }

  void increaseItemQuantity(CartDetails item) {
    cartItems[cartItems.indexOf(item)].quantity += 1;
    updateCartLength();
    SharedService.setCartDetails(cartItems);
  }

  void removeItemFromCart(CartDetails item) {
    cartItems.remove(item);
    updateCartLength();
    SharedService.setCartDetails(cartItems);
  }

  void clearCart() {
    cartItems.clear();
    updateCartLength();
    SharedService.setCartDetails(cartItems);
  }

  void printCart() {
    log(cartItems.length.toString());
    for (var item in cartItems) {
      log('------------------');
      log(item.id.toString());
      log(item.name);
      log(item.description.toString());
      log(item.image.toString());
      log(item.price.toString());
      log(item.quantity.toString());
      log('------------------');
    }
  }

  void updateCartLength() {
    cartCount.value = cartItems.length;
  }
}
