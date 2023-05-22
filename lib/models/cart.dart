import 'dart:developer';

List<CartDetails> cartItems = [];

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
    // check if the cart already has the item then increase the quantity
    if (cartItems.contains(item)) {
      cartItems[cartItems.indexOf(item)].quantity += 1;
      return;
    }
    cartItems.add(item);
  }

  void decreaseItemQuantity(CartDetails item) {
    // check if the cart already has only 1 item then decrease the quantity
    if (cartItems[cartItems.indexOf(item)].quantity == 1) {
      cartItems.remove(item);
      return;
    }
    cartItems[cartItems.indexOf(item)].quantity -= 1;
  }

  void increaseItemQuantity(CartDetails item) {
    cartItems[cartItems.indexOf(item)].quantity += 1;
  }

  void removeItemFromCart(CartDetails item) {
    cartItems.remove(item);
  }

  void clearCart() {
    cartItems.clear();
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

  // void addItemToCart(int id) {
  //   // check if the cart already has the item then increase the quantity
  //   if (cartItems.containsKey(id)) {
  //     cartItems[id] = cartItems[id]! + 1;
  //     return;
  //   }
  //   cartItems[id] = 1;
  // }

  // void decreaseItemQuantity(int id) {
  //   // check if the cart already has only 1 item then decrease the quantity
  //   if (cartItems[id] == 1) {
  //     cartItems.remove(id);
  //     return;
  //   }
  //   cartItems[id] = cartItems[id]! - 1;
  // }

  // void increaseItemQuantity(int id) {
  //   cartItems[id] = cartItems[id]! + 1;
  // }

  // void removeItemFromCart(int id) {
  //   cartItems.remove(id);
  // }

  // void clearCart() {
  //   cartItems.clear();
  // }

  // void printCart() {
  //   log(cartItems.toString());
  // }
}
