import 'package:badges/badges.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';
import 'package:provider/provider.dart';

import '../main_screen/cart_screen.dart';
import '../provider/cart_provider.dart';
import '../provider/wish_provider.dart';
import '../widgets/snackbar.dart';
import 'package:collection/collection.dart';

class ProductsDetailsScreen extends StatefulWidget {
  final dynamic proList;

  const ProductsDetailsScreen({Key? key, required this.proList})
      : super(key: key);

  @override
  State<ProductsDetailsScreen> createState() => _ProductsDetailsScreenState();
}

class _ProductsDetailsScreenState extends State<ProductsDetailsScreen> {
  late final Stream<QuerySnapshot> _productsStream = FirebaseFirestore.instance
      .collection('products')
      .where('storecateg', isEqualTo: widget.proList['storecateg'])
      .snapshots();

  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();
  late List<dynamic> imagesList = widget.proList['proimages'];

  @override
  Widget build(BuildContext context) {
    var onSale = widget.proList['discount'];
    var existingItemCart = context.read<Cart>().getItems.firstWhereOrNull(
            (product) => product.documentId == widget.proList['proId']);
    return SafeArea(
      child: ScaffoldMessenger(
        key: _scaffoldKey,
        child: Scaffold(
          backgroundColor: Colors.black,
          body: SingleChildScrollView(
            child: Column(children: [
              Stack(
                children: [
                  SizedBox(
                    width: double.maxFinite,
                    height: MediaQuery.of(context).size.height / 2.5,
                    child: Swiper(
                      itemBuilder: (context, index) {
                        return Image(
                          image: NetworkImage(imagesList[index]),
                          fit: BoxFit.cover,
                        );
                      },
                      indicatorLayout: PageIndicatorLayout.COLOR,
                      itemCount: imagesList.length,
                      pagination: const SwiperPagination(),
                    ),
                  ),
                  Positioned(
                      left: 15,
                      top: 20,
                      child: CircleAvatar(
                        backgroundColor: Colors.black,
                        child: IconButton(
                          icon: const Icon(Icons.arrow_back_ios_new,
                              color: Colors.white),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      )),
                ],
              ),
              Container(
                height: MediaQuery.of(context).size.height,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.black87, Colors.black],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(8.0, 8, 8, 50),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.proList['name'],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Text(
                                widget.proList['price'].toStringAsFixed(0) +
                                    (' сом'),
                                style: onSale != 0
                                    ? const TextStyle(
                                        color: Colors.white60,
                                        fontSize: 16,
                                        decoration: TextDecoration.lineThrough,
                                        fontWeight: FontWeight.w600,
                                      )
                                    : const TextStyle(
                                        color: Colors.red,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600,
                                      ),
                              ),
                              const SizedBox(
                                width: 6,
                              ),
                              onSale != 0
                                  ? Text(
                                      ((1 - (onSale / 100)) *
                                              widget.proList['price'])
                                          .toStringAsFixed(0),
                                      style: const TextStyle(
                                        color: Colors.red,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    )
                                  : const Text('')
                            ],
                          ),
                          IconButton(
                              onPressed: () {
                                var existingItemWishlist = context
                                    .read<Wish>()
                                    .getWishItems
                                    .firstWhereOrNull((product) =>
                                product.documentId ==
                                    widget.proList['proId']);
                                existingItemWishlist != null
                                    ? context
                                    .read<Wish>()
                                    .removeThis(widget.proList['proId'])
                                    : context.read<Wish>().addWishItem(
                                  widget.proList['name'],
                                  onSale != 0
                                      ? ((1 - (onSale / 100)) *
                                      widget.proList['price'])
                                      : widget.proList['price'],
                                  1,
                                  widget.proList['instock'],
                                  widget.proList['proimages'],
                                  widget.proList['proId'],
                                  widget.proList['sid'],
                                );
                              },
                              icon: context
                                  .watch<Wish>()
                                  .getWishItems
                                  .firstWhereOrNull((product) =>
                              product.documentId ==
                                  widget.proList['proId']) !=
                                  null
                                  ? const Icon(
                                Icons.favorite,
                                color: Colors.red,
                                size: 30,
                              )
                                  : const Icon(
                                Icons.favorite_outline,
                                color: Colors.red,
                                size: 30,
                              )),
                        ],
                      ),
                      widget.proList['instock'] == 0
                          ? const Text('Товара нет в наличии',
                              style: TextStyle(
                                  fontSize: 16, color: Colors.blueGrey))
                          : Text(
                              '${widget.proList['instock']} шт в наличии на складе',
                              style: const TextStyle(
                                  fontSize: 16, color: Colors.blueGrey),
                            ),
                      const ProDetailsHeader(
                        label: 'Описание товара',
                      ),
                      Text(
                        widget.proList['desc'],
                        textScaleFactor: 1.1,
                        style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Colors.white70),
                      ),
                    ],
                  ),
                ),
              ),
            ]),
          ),
          bottomNavigationBar: Container(
            // color: Colors.white70,
            height: 100,
            padding: const EdgeInsets.only(
              top: 20,
              bottom: 20,
              left: 20,
              right: 20,
            ),
            decoration: const BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                )),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CircleAvatar(
                  backgroundColor: Colors.black,
                  child: IconButton(
                    color: Colors.white,
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const
                              CartScreen(
                                // back: AppBarBackButton(),
                              )));
                    },
                    icon: Badge(
                        showBadge: context.read<Cart>().getItems.isEmpty
                            ? false
                            : true,
                        padding: const EdgeInsets.all(2),
                        badgeColor: Colors.white,
                        badgeContent: Text(

                          context.watch<Cart>().getItems.length.toString(),
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                        child: const Icon(Icons.shopping_cart_outlined)),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    if (widget.proList['instock'] == 0) {
                      MyMessageHandler.showSnackBar(
                          _scaffoldKey, 'Товара нет в наличии');
                    } else if (existingItemCart != null) {
                      MyMessageHandler.showSnackBar(
                          _scaffoldKey, 'Товар уже в корзине');
                    } else {
                      context.read<Cart>().addItem(
                        widget.proList['name'],
                        onSale != 0
                            ? ((1 - (onSale / 100)) *
                            widget.proList['price'])
                            : widget.proList['price'],
                        1,
                        widget.proList['instock'],
                        widget.proList['proimages'],
                        widget.proList['proId'],
                        widget.proList['sid'],
                      );
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.only(
                      top: 20,
                      bottom: 20,
                      left: 20,
                      right: 20,
                    ),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color:  Colors.white),
                    child: Text(
                      existingItemCart != null
                          ? 'Товар уже в корзине'
                          :
                      'Добавить в корзину',
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ProDetailsHeader extends StatelessWidget {
  final String label;

  const ProDetailsHeader({Key? key, required this.label}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            height: 40,
            width: 50,
            child: Divider(
              color: Colors.white54,
              thickness: 1,
            ),
          ),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(
            height: 40,
            width: 50,
            child: Divider(
              color: Colors.white54,
              thickness: 1,
            ),
          ),
        ],
      ),
    );
  }
}
