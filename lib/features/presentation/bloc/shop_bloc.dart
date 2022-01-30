import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:shop_app/features/domain/model/product_model.dart';
import 'package:shop_app/features/domain/repositories/shop_data_provider.dart';

part 'shop_event.dart';
part 'shop_state.dart';

class ShopBloc extends Bloc<ShopEvent, ShopState> {
  ShopDataProvider shopDataProvider = ShopDataProvider();
  ShopBloc() : super(ShopInitial()) {
    add(InitialPageEvent());
  }

  @override
  Stream<ShopState> mapEventToState(ShopEvent event) async* {
    if (event is InitialPageEvent) {
      StoreProducts allProducts = await shopDataProvider.getAllProducts();
      StoreProducts cartProducts = await shopDataProvider.getCartItems();

      yield PageLoaded(allProducts: allProducts, cartProducts: cartProducts);
    }
    if (event is AddingToCartEvent) {
      yield ItemAddingState(cartItems: event.cartItems);
    }
    if (event is AddedToCartEvent) {
      yield ItemAddedState(cartItems: event.cartItems);
    }
    if (event is DeleteFromCart) {
      yield ItemDeletedState(cartItems: event.cartItems);
    }
  }
}
