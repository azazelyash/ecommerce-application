import 'dart:developer';

Map<int, int> CartItems = {};

class Cart {
  void addItemToCart(int id, int quantity) {
    // check if the cart already has the item then increase the quantity
    if (CartItems.containsKey(id)) {
      CartItems[id] = CartItems[id]! + quantity;
      return;
    }
    CartItems[id] = quantity;
  }

  void decreaseItemQuantity(int id) {
    // check if the cart already has only 1 item then decrease the quantity
    if (CartItems[id] == 1) {
      CartItems.remove(id);
      return;
    }
    CartItems[id] = CartItems[id]! - 1;
  }

  void increaseItemQuantity(int id) {
    CartItems[id] = CartItems[id]! + 1;
  }

  void removeItemFromCart(int id) {
    CartItems.remove(id);
  }

  void clearCart() {
    CartItems.clear();
  }

  void printCart() {
    log(CartItems.toString());
  }
}
