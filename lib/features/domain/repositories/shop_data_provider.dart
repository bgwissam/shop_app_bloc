import 'package:shop_app/features/data/demodata/demo_data.dart';
import 'package:shop_app/features/domain/model/product_model.dart';

class ShopDataProvider {
  //Will get all the products
  Future<StoreProducts> getAllProducts() async {
    var storeDate = DemoData().demoProducts;
    return StoreProducts(items: storeDate);
  }

  //will get the items in the cart
  Future<StoreProducts> getCartItems() async {
    List<Product> demoProducts = [];
    return StoreProducts(items: demoProducts);
  }
}
