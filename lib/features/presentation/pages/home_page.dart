import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/features/domain/model/product_model.dart';
import 'package:shop_app/features/presentation/bloc/shop_bloc.dart';
import 'package:shop_app/features/presentation/pages/cart_page.dart';
import 'package:shop_app/features/presentation/pages/product_details.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Product> storeItems = [];
  List<Product> cartItems = [];
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return BlocListener<ShopBloc, ShopState>(
      listener: (context, state) {
        if (state is ShopInitial) {
          _isLoading = true;
        }
        if (state is PageLoaded) {
          storeItems = state.allProducts.items;
          cartItems = state.cartProducts.items;
          _isLoading = false;
        }
        if (state is ItemAddedState) {
          cartItems = state.cartItems;
          _isLoading = false;
        }
        if (state is ItemDeletedState) {
          cartItems = state.cartItems;
          _isLoading = false;
        }
      },
      child: BlocBuilder<ShopBloc, ShopState>(
        builder: (context, state) {
          return Scaffold(
              appBar: AppBar(
                title: const Text('Demo Shopping App'),
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
                                      ..add(AddingToCartEvent(
                                          cartItems: cartItems)),
                                    child: const CartDetails(),
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
                          child: Container(
                              padding: const EdgeInsets.all(2),
                              child: Text(
                                '${cartItems.length}',
                                style: const TextStyle(fontSize: 13),
                                textAlign: TextAlign.center,
                              )),
                        )
                      ],
                    ),
                  )
                ],
              ),
              backgroundColor: Colors.white,
              body: _isLoading
                  ? CircularProgressIndicator()
                  : _buildHomePageBody());
        },
      ),
    );
  }

  //Will contain all the widget of the home page body
  Widget _buildHomePageBody() {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 10),
            child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.7,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 5),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: storeItems.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () async {
                      await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => BlocProvider.value(
                                    value: BlocProvider.of<ShopBloc>(context)
                                      ..add(AddingToCartEvent(
                                          cartItems: cartItems)),
                                    child:
                                        ProductDetail(item: storeItems[index]),
                                  )));
                    },
                    child: Card(
                      elevation: 4,
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              flex: 2,
                              child: Center(
                                child: Image.asset(storeItems[index].imageUrl),
                              ),
                            ),
                            Text(storeItems[index].name),
                            Text('${storeItems[index].price}'),
                            ElevatedButton(
                              style: ButtonStyle(
                                  shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(35))),
                                  backgroundColor:
                                      MaterialStateColor.resolveWith(
                                          (states) => Colors.purpleAccent)),
                              child: Text('Add'),
                              onPressed: () {
                                setState(() {
                                  if (cartItems.isNotEmpty) {
                                    if (cartItems.contains(storeItems[index])) {
                                      for (var item in cartItems) {
                                        if (item.id == storeItems[index].id) {
                                          item.quantity++;
                                        }
                                      }
                                    } else {
                                      cartItems.add(storeItems[index]);
                                    }
                                  } else {
                                    cartItems.add(storeItems[index]);
                                  }
                                });
                              },
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                }),
          )
        ],
      ),
    );
  }
}
