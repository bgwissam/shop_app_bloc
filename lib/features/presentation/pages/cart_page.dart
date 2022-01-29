import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/features/domain/model/product_model.dart';
import 'package:shop_app/features/presentation/bloc/shop_bloc.dart';

class CartDetails extends StatefulWidget {
  const CartDetails({Key key}) : super(key: key);

  @override
  _CartDetailsState createState() => _CartDetailsState();
}

class _CartDetailsState extends State<CartDetails> {
  List<Product> cartItems = [];
  bool _isLoading = true;
  Size _size;
  double totalValue = 0.0;
  @override
  Widget build(BuildContext context) {
    _size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
          title: Text('Cart Details'), backgroundColor: Colors.purpleAccent),
      body: _buildCartDetailsWidget(),
      bottomNavigationBar: _buildBottomNavigator(),
    );
  }

  Widget _buildCartDetailsWidget() {
    return BlocBuilder<ShopBloc, ShopState>(
      builder: (context, state) {
        if (state is PageLoaded) {
          cartItems = state.cartProducts.items;
          _isLoading = false;
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
                                  BlocProvider.of<ShopBloc>(context)
                                    ..add(DeleteFromCart(
                                        cartItems: state.cartProducts.items));
                                }
                                if (state is ItemAddedState) {
                                  state.cartItems.removeAt(index);
                                  BlocProvider.of<ShopBloc>(context)
                                    ..add(DeleteFromCart(
                                        cartItems: state.cartItems));
                                }
                                if (state is ItemDeletedState) {
                                  state.cartItems.removeAt(index);

                                  BlocProvider.of<ShopBloc>(context)
                                    ..add(DeleteFromCart(
                                        cartItems: state.cartItems));
                                }
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      duration: Duration(milliseconds: 500),
                                      content: Text(
                                          '${item.name} has been removed')));
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
                                leading: Image.asset(cartItems[index].imageUrl),
                                title: Text(cartItems[index].name),
                                subtitle: Padding(
                                  padding: const EdgeInsets.only(top: 10),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        padding: EdgeInsets.all(4),
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
                                                    if (cartItems[index]
                                                            .quantity >
                                                        0) {
                                                      setState(() {
                                                        cartItems[index]
                                                            .quantity--;
                                                      });
                                                    }
                                                  },
                                                  icon: Icon(Icons.remove)),
                                              SizedBox(
                                                  width: 30,
                                                  child: Center(
                                                      child: Text(
                                                          '${cartItems[index].quantity}'))),
                                              IconButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      cartItems[index]
                                                          .quantity++;
                                                    });
                                                  },
                                                  icon: Icon(Icons.add))
                                            ],
                                          ),
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.only(left: 15),
                                        child: Text(
                                            '\$${cartItems[index].price * cartItems[index].quantity}',
                                            style: TextStyle(
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
                : Center(
                    child: Text('You cart is empty'),
                  ),
          ),
        );
      },
    );
  }

  void _totalValueCalculation() {
    totalValue = 0.0;
    for (var item in cartItems) {
      totalValue += item.quantity * item.price;
    }
  }

  //Will show the item total
  Widget _buildBottomNavigator() {
    print('the cartItems: $cartItems');
    return cartItems != null && cartItems.isNotEmpty
        ? Container(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 25),
            height: 80,
            decoration: BoxDecoration(
                color: Colors.black12,
                border: Border.all(color: Colors.black38),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [Text('Total Value:'), Text('$totalValue')],
            ),
          )
        : SizedBox.shrink();
  }
}
