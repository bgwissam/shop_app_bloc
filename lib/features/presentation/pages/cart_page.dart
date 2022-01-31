import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/features/domain/model/product_model.dart';
import 'package:shop_app/features/presentation/bloc/shop_bloc.dart';
import 'package:shop_app/features/presentation/widgets/snack_bar.dart';

class CartDetails extends StatefulWidget {
  const CartDetails({Key key}) : super(key: key);

  @override
  _CartDetailsState createState() => _CartDetailsState();
}

class _CartDetailsState extends State<CartDetails> {
  final SnackBarWidget _snackBarWidget = SnackBarWidget();
  List<Product> cartItems = [];
  bool _isLoading = true;
  Size _size;
  double totalValue = 0.0;
  @override
  Widget build(BuildContext context) {
    _size = MediaQuery.of(context).size;
    _snackBarWidget.context = context;
    return BlocBuilder<ShopBloc, ShopState>(
      builder: (context, state) {
        if (state is PageLoaded) {
          cartItems = state.cartProducts.items;
          _isLoading = false;
          _totalValueCalculation();
        }
        if (state is ItemAddingState) {
          cartItems = state.cartItems;
          _isLoading = false;
          _totalValueCalculation();
        }
        if (state is ItemAddedState) {
          cartItems = state.cartItems;
          _isLoading = false;
          _totalValueCalculation();
        }
        if (state is ItemDeletedState) {
          cartItems = state.cartItems;
          _isLoading = false;
          _totalValueCalculation();
        }
        return Scaffold(
          appBar: AppBar(
              title: const Text('Cart Details'),
              backgroundColor: Colors.purpleAccent),
          body: _buildCartDetailsWidget(state),
          bottomNavigationBar: _buildBottomNavigator(),
        );
      },
    );
  }

  Widget _buildCartDetailsWidget(var state) {
    return SingleChildScrollView(
      child: SizedBox(
        height: _size.height,
        child: cartItems != null && cartItems.isNotEmpty
            ? ListView.builder(
                itemCount: cartItems.length,
                itemBuilder: (context, index) {
                  final item = cartItems[index];
                  return Padding(
                      padding: const EdgeInsets.all(25),
                      child: Dismissible(
                        key: Key(cartItems[index].id),
                        onDismissed: (direction) {
                          setState(() {
                            cartItems.removeAt(index);
                            if (state is PageLoaded) {
                              state.cartProducts.items.removeAt(index);
                              BlocProvider.of<ShopBloc>(context).add(
                                  DeleteFromCart(
                                      cartItems: state.cartProducts.items));
                              _totalValueCalculation();
                            }
                            if (state is ItemAddedState) {
                              state.cartItems.removeAt(index);
                              BlocProvider.of<ShopBloc>(context).add(
                                  DeleteFromCart(cartItems: state.cartItems));
                              _totalValueCalculation();
                            }
                            if (state is ItemDeletedState) {
                              state.cartItems.removeAt(index);

                              BlocProvider.of<ShopBloc>(context).add(
                                  DeleteFromCart(cartItems: state.cartItems));
                              _totalValueCalculation();
                            }
                          });
                          _snackBarWidget.content =
                              '${item.name} has been removed';
                          _snackBarWidget.showSnack();
                        },
                        child: Container(
                          alignment: Alignment.center,
                          height: 120,
                          decoration: BoxDecoration(
                            color: Colors.white60,
                            border: Border.all(),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: ListTile(
                            leading: SizedBox(
                                width: 60,
                                child: Image.asset(cartItems[index].imageUrl)),
                            title: Text(cartItems[index].name),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(4),
                                    height: 50,
                                    decoration: BoxDecoration(
                                        border: Border.all(),
                                        borderRadius:
                                            BorderRadius.circular(40)),
                                    child: Center(
                                      child: Row(
                                        children: [
                                          IconButton(
                                              onPressed: () {
                                                if (cartItems[index].quantity >
                                                    0) {
                                                  setState(() {
                                                    cartItems[index].quantity--;
                                                  });
                                                }
                                              },
                                              icon: const Icon(Icons.remove)),
                                          SizedBox(
                                              width: 30,
                                              child: Center(
                                                  child: Text(
                                                      '${cartItems[index].quantity}'))),
                                          IconButton(
                                              onPressed: () {
                                                setState(() {
                                                  cartItems[index].quantity++;
                                                });
                                              },
                                              icon: const Icon(Icons.add))
                                        ],
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.only(left: 15),
                                    child: Text(
                                        '\$${cartItems[index].price * cartItems[index].quantity}',
                                        style: const TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold)),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ));
                })
            : const Center(
                child: Text('You cart is empty',
                    style: TextStyle(
                      fontSize: 25,
                    )),
              ),
      ),
    );
  }

  void _totalValueCalculation() {
    if (cartItems != null) {
      totalValue = 0.0;
      for (var item in cartItems) {
        totalValue += item.quantity * item.price;
      }
    }
  }

  //Will show the item total
  Widget _buildBottomNavigator() {
    return cartItems != null && cartItems.isNotEmpty
        ? Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
            height: 80,
            decoration: BoxDecoration(
                color: Colors.black12,
                border: Border.all(color: Colors.black38),
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const Text('Total Value:',
                    style: TextStyle(
                      fontSize: 18,
                    )),
                Text('$totalValue',
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold))
              ],
            ),
          )
        : const SizedBox.shrink();
  }
}
