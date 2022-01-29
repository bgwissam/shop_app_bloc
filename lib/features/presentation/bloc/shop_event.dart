part of 'shop_bloc.dart';

abstract class ShopEvent extends Equatable {
  const ShopEvent();

  @override
  List<Object> get props => [];
}

class InitialPageEvent extends ShopEvent {}

class AddingToCartEvent extends ShopEvent {
  List<Product> cartItems;

  AddingToCartEvent({this.cartItems});
}

class AddedToCartEvent extends ShopEvent {
  List<Product> cartItems;

  AddedToCartEvent({this.cartItems});
}

class DeleteFromCart extends ShopEvent {
  List<Product> cartItems;
  int index;

  DeleteFromCart({this.cartItems, this.index});
}
