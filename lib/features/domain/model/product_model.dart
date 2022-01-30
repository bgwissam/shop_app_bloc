class Product {
  String id;
  String name;
  String description;
  String imageUrl;
  double price;
  int quantity;

  Product({
    this.id,
    this.name,
    this.description,
    this.imageUrl,
    this.price,
    this.quantity,
  });
}

class StoreProducts {
  List<Product> items;
  StoreProducts({
    this.items,
  });
}
