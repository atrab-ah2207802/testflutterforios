class Product{
  String id;
  String title;
  String category;
  String description;
  double price;
  int rating;
  String imageName;
  bool isFavorited;


  Product({
    this.id="",
    this.title = "",
    this.category = "",
    this.description = "",
    this.price=0.0,
    this.rating = 0,
    this.imageName = "",
    this.isFavorited = false
  });

  factory Product.fromJson(Map<String, dynamic> map){
    return Product(
      id: map['id'] ?? '',
      title : map['title'] ?? '',
      category : map['category'] ?? '',
      description : map['description'] ?? '',
      price : map['price'] ?? 0.0,
      rating : map['rating'] ?? 0,
      imageName : map['imageName'] ?? '',
    );
  }
}