import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/features/domain/model/product_model.dart';
import 'package:shop_app/features/presentation/bloc/shop_bloc.dart';
import 'package:shop_app/features/presentation/widgets/snack_bar.dart';

import 'cart_page.dart';

class ProductDetail extends StatefulWidget {
  const ProductDetail({Key key, this.item}) : super(key: key);
  final Product item;
  @override
  _ProductDetailState createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  List<Product> cartItems = [];
  SnackBarWidget _snackBarWidget = SnackBarWidget();
  bool _isLoading = true;
  int quantity = 1;
  Size _size;

  @override
  Widget build(BuildContext context) {
    _size = MediaQuery.of(context).size;
    _snackBarWidget.context = context;
    return BlocBuilder<ShopBloc, ShopState>(
      builder: (context, state) {
        if (state is PageLoaded) {
          _isLoading = false;
          cartItems = state.cartProducts.items;
        }
        if (state is ItemAddingState) {
          cartItems = state.cartItems;
          _isLoading = false;
        }
        return Scaffold(
          appBar: AppBar(
            title: Text(widget.item.name),
            backgroundColor: Colors.purpleAccent,
            actions: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 7),
                child: Stack(
                  children: [
                    Center(
                      child: IconButton(
                        onPressed: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => BlocProvider.value(
                                value: BlocProvider.of<ShopBloc>(context)
                                  ..add(
                                      AddingToCartEvent(cartItems: cartItems)),
                                child: CartDetails(),
                              ),
                            ),
                          );
                        },
                        icon: const Icon(
                          Icons.shopping_bag_outlined,
                          size: 40,
                        ),
                      ),
                    ),
                    Positioned(
                      right: 15,
                      bottom: 10,
                      child: cartItems != null
                          ? Container(
                              padding: const EdgeInsets.all(2),
                              child: Text(
                                '${cartItems.length}',
                                style: TextStyle(fontSize: 13),
                                textAlign: TextAlign.center,
                              ),
                            )
                          : SizedBox.shrink(),
                    )
                  ],
                ),
              )
            ],
          ),
          body: !_isLoading
              ? _buildItemDetailsWidget()
              : const Center(child: CircularProgressIndicator()),
        );
      },
    );
  }

  Widget _buildItemDetailsWidget() {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(18),
        height: _size.height,
        width: _size.width,
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          SizedBox(
              height: _size.height / 2,
              child: Image.asset(widget.item.imageUrl)),
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Text(
              widget.item.description,
            ),
          ),
          Container(
            padding: const EdgeInsets.all(4.0),
            height: 60,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text('Price'),
                SizedBox(
                  width: 60,
                ),
                Text('\$${widget.item.price}'),
              ],
            ),
          ),
          Container(
            height: 60,
            padding: const EdgeInsets.all(4.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Text('Quantity'),
                const SizedBox(
                  width: 60,
                ),
                Container(
                  decoration: BoxDecoration(
                      border: Border.all(),
                      borderRadius: BorderRadius.circular(40)),
                  child: Row(children: [
                    IconButton(
                        onPressed: () {
                          if (widget.item.quantity > 0) {
                            setState(() {
                              quantity--;
                            });
                          }
                        },
                        icon: const Icon(Icons.remove)),
                    SizedBox(
                        width: 30, child: Center(child: Text('$quantity'))),
                    IconButton(
                        onPressed: () {
                          setState(() {
                            quantity++;
                          });
                        },
                        icon: Icon(Icons.add)),
                  ]),
                ),
              ],
            ),
          ),
          SizedBox(
            width: _size.width,
            child: ElevatedButton(
              style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(35))),
                  backgroundColor: MaterialStateColor.resolveWith(
                      (states) => Colors.purpleAccent)),
              child: Text('Add'),
              onPressed: () {
                setState(() {
                  if (cartItems != null || cartItems.isNotEmpty) {
                    if (cartItems.contains(widget.item)) {
                      _updateItem();
                    } else {
                      _addItems();
                    }
                  } else {
                    _addItems();
                  }
                });
              },
            ),
          )
        ]),
      ),
    );
  }

  //add new item
  void _addItems() {
    if (quantity > 0) {
      widget.item.quantity = quantity;
      cartItems.add(widget.item);
    } else {
      _snackBarWidget.content = 'Quantity should be more than 0';
      _snackBarWidget.showSnack();
    }
  }

  //update current item
  void _updateItem() {
    for (var item in cartItems) {
      if (item.id == widget.item.id) {
        if (quantity > 0) {
          item.quantity += quantity;
        } else {
          _snackBarWidget.content = 'Quantity should be more than 0';
          _snackBarWidget.showSnack();
        }
      }
    }
  }
}
