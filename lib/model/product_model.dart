import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../minor_screen/product_detail_screen.dart';
import '../provider/wish_provider.dart';
import 'package:collection/collection.dart';

class ProductModel extends StatefulWidget {
  final dynamic products;

  const ProductModel({Key? key, required this.products}) : super(key: key);

  @override
  State<ProductModel> createState() => _ProductModelState();
}

class _ProductModelState extends State<ProductModel> {
  @override
  Widget build(BuildContext context) {
    var onSale = widget.products['discount'];
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ProductsDetailsScreen(
                  proList: widget.products,
                )));
      },
      child: Stack(
        children: [
          Card(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(15),
                          topRight: Radius.circular(15),
                        ),
                        image: DecorationImage(
                            image:
                                NetworkImage(widget.products['proimages'][0]),
                            // fit: BoxFit.cover,
                            fit: BoxFit.fill)),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.products['name'],
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                ),
                          ),
                         const SizedBox(height: 5),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.products['price'].toStringAsFixed(0) +
                                    (' сом'),
                                style: onSale != 0
                                    ? const TextStyle(
                                        color: Colors.grey,
                                        fontSize: 14,
                                        decoration: TextDecoration.lineThrough,
                                        fontWeight: FontWeight.w600,
                                      )
                                    : const TextStyle(
                                        color: Colors.redAccent,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w900,
                                      ),
                              ),
                              const SizedBox(width: 16),
                              onSale != 0
                                  ? Text(
                                      ((1 - (onSale / 100)) *
                                                  widget.products['price'])
                                              .toStringAsFixed(0) +
                                          (' сом'),
                                      style: const TextStyle(
                                        color: Colors.red,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    )
                                  : const Text(''),
                            ],
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                        onPressed: () {
                          var existingItemWishlist = context
                              .read<Wish>()
                              .getWishItems
                              .firstWhereOrNull((product) =>
                          product.documentId ==
                              widget.products['proid']);
                          existingItemWishlist != null
                              ? context.read<Wish>().removeThis(
                              widget.products['proid'])
                              : context.read<Wish>().addWishItem(
                            widget.products['name'],
                            onSale != 0
                                ? ((1 -
                                (widget.products[
                                'discount'] /
                                    100)) *
                                widget
                                    .products['price'])
                                : widget.products['price'],
                            1,
                            widget.products['instock'],
                            widget.products['proimages'],
                            widget.products['proId'],
                            widget.products['sid'],
                          );
                        },
                        icon:
                            context
                                .watch<Wish>()
                                .getWishItems
                                .firstWhereOrNull((product) =>
                            product.documentId ==
                                widget.products['proId']) !=
                                null
                                ? const Icon(
                              Icons.favorite,
                              color: Colors.red,
                              size: 30,
                            )
                                :
                            const Icon(
                          Icons.favorite_outline,
                          color: Colors.red,
                          size: 30,
                        )),
                  ],
                ),
                const SizedBox(
                  height: 10,
                )
              ],
            ),
          ),
          widget.products['discount'] != 0
              ? Positioned(
                  top: 20,
                  left: 5,
                  child: Container(
                    height: 25,
                    width: 80,
                    decoration: const BoxDecoration(
                        color: Color.fromARGB(255, 202, 199, 33),
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(15),
                            bottomRight: Radius.circular(15))),
                    child: Center(
                      child: Text(
                          'скидка ${widget.products['discount'].toString()} %'),
                    ),
                  ),
                )
              : Container(
                  color: Colors.transparent,
                ),
        ],
      ),
    );
  }
}
