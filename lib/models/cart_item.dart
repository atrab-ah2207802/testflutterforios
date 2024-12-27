class CartItem{
  String productId;
  // String productName;
  int quantity;
  static double total=0;

  CartItem({
    this.productId="",
    // this.productName="",
    this.quantity=0,
    // this.unitPrice=0.0,
  });

  factory CartItem.fromJson(Map<String, dynamic> map){
    return CartItem(
      productId: map['productId'] ?? '',
      // productName: map['productName'] ?? '',
      quantity: map['quantity'] ?? '',
      // unitPrice : map['unitPrice'] ?? '',
    );
  }
}