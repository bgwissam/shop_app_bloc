import 'package:shop_app/features/domain/model/product_model.dart';

class ShopDataProvider {
  //Will get all the products
  Future<StoreProducts> getAllProducts() async {
    List<Product> demoProducts = [
      Product(
        id: '1',
        name: 'Coffee Tables',
        imageUrl: 'assets/images/coffee_table.jpeg',
        description:
            'A set of 3 coffee tables of three different sizes, they are made completely of wood material and finished with a high quality paint product',
        quantity: 1,
        price: 250,
      ),
      Product(
        id: '2',
        name: 'Rlaxon Chair',
        imageUrl: 'assets/images/chair.jpeg',
        description:
            'A high quality fibre with memory faom installed, Rlaxon chair is very comfortable and relaxing, made of the highest quality products from wood, metal and fabric.',
        quantity: 1,
        price: 250,
      ),
      Product(
        id: '3',
        name: 'Colors Mug',
        imageUrl: 'assets/images/mugs.jpeg',
        description:
            'A set of 6 colorful cups that is adequate for family and friends, the set features a variety of colors in which you can chose from',
        quantity: 1,
        price: 250,
      ),
      Product(
        id: '4',
        name: 'Welcome Rugs',
        imageUrl: 'assets/images/welcome_rug.jpeg',
        description:
            'High quality rugs made especially to keep your home clean from street dirt, our welcome rugs are perfect if you suffer from dirty shoes that contaminate your home. They come in different sizes and shapes for your choice.',
        quantity: 1,
        price: 250,
      ),
      Product(
        id: '5',
        name: 'Bruce Automaic Heaters',
        imageUrl: 'assets/images/heater.jpg',
        description:
            'Bruce a very convenient for cold weather, it features a set of functions that allows it to stand on top of it\'s line, where you can control your home heating from your wifi, and has a safety turn off function when tipped over.',
        quantity: 1,
        price: 250,
      ),
    ];

    return StoreProducts(items: demoProducts);
  }

  //will get the items in the cart
  Future<StoreProducts> getCartItems() async {
    List<Product> demoProducts = [
      Product(
        id: '1',
        name: 'Coffee Tables',
        imageUrl: 'assets/images/coffee_table.jpeg',
        description:
            'A set of 3 coffee tables of three different sizes, they are made completely of wood material and finished with a high quality paint product',
        quantity: 1,
        price: 250,
      ),
    ];

    return StoreProducts(items: demoProducts);
  }
}
