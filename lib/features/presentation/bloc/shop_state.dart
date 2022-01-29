part of 'shop_bloc.dart';

abstract class ShopState extends Equatable {
  const ShopState();

  @override
  List<Object> get props => [];
}

class ShopInitial extends ShopState {}

class PageLoaded extends ShopState {
  StoreProducts allProducts;
  StoreProducts cartProducts;

  PageLoaded({this.allProducts, this.cartProducts});
}

class ItemAddingState extends ShopState {
  StoreProducts cartProducts;
  List<Product> cartItems;

  ItemAddingState({this.cartProducts, this.cartItems});
}

class ItemAddedState extends ShopState {
  List<Product> cartItems;

  ItemAddedState({this.cartItems});
}

class ItemDeletedState extends ShopState {
  List<Product> cartItems;

  ItemDeletedState({this.cartItems});
}
