import 'dart:developer';

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
  }

  void decreaseItemQuantity(CartDetails item) {
    // check if the cart already has only 1 item then decrease the quantity
    if (cartItems[cartItems.indexOf(item)].quantity == 1) {
      cartItems.remove(item);
      return;
    }
    cartItems[cartItems.indexOf(item)].quantity -= 1;
    updateCartLength();
  }

  void increaseItemQuantity(CartDetails item) {
    cartItems[cartItems.indexOf(item)].quantity += 1;
    updateCartLength();
  }

  void removeItemFromCart(CartDetails item) {
    cartItems.remove(item);
    updateCartLength();
  }

  void clearCart() {
    cartItems.clear();
    updateCartLength();
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
