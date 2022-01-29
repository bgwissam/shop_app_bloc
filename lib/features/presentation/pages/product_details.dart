import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/features/domain/model/product_model.dart';
import 'package:shop_app/features/presentation/bloc/shop_bloc.dart';

class ProductDetail extends StatefulWidget {
  const ProductDetail({Key key, this.item}) : super(key: key);
  final Product item;
  @override
  _ProductDetailState createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  List<Product> cartItems = [];
  bool _isLoading = true;
  int quantity = 0;
  Size _size;

  @override
  Widget build(BuildContext context) {
    _size = MediaQuery.of(context).size;
    return BlocBuilder<ShopBloc, ShopState>(
      builder: (context, state) {
        print('state: $state');
        if (state is PageLoaded) {
          _isLoading = false;
        }
        if (state is ItemAddingState) {
          cartItems = state.cartItems;
          _isLoading = false;
        }
        return Scaffold(
          appBar: AppBar(
            title: Text(widget.item.name),
            backgroundColor: Colors.purpleAccent,
          ),
          body: !_isLoading
              ? _buildItemDetailsWidget()
              : Center(child: const CircularProgressIndicator()),
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
                Text('Quantity'),
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
                              widget.item.quantity--;
                            });
                          }
                        },
                        icon: Icon(Icons.remove)),
                    SizedBox(
                        width: 30,
                        child: Center(child: Text('${widget.item.quantity}'))),
                    IconButton(
                        onPressed: () {
                          setState(() {
                            widget.item.quantity++;
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
              onPressed: () {},
            ),
          )
        ]),
      ),
    );
  }
}
