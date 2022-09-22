import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

// ignore: depend_on_referenced_packages
import 'package:collection/collection.dart';

import '../provider/cart_provider.dart';
import '../provider/product_class.dart';
import '../provider/wish_provider.dart';

class CartModel extends StatelessWidget {
  const CartModel({
    Key? key,
    required this.product,
    required this.cart,
  }) : super(key: key);

  final Product product;
  final Cart cart;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Card(
        child: SizedBox(
          height: 100,
          child: Row(
            children: [
              SizedBox(
                height: 100,
                width: 100,
                child: Image.network(product.imagesUrl[0]),
              ),
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        product.name,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey.shade700,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Text(
                              '${product.price.toStringAsFixed(0)} сом',
                              style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red),
                            ),
                          ),
                          Container(
                            height: 35,
                            decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(15)),
                            child: Row(
                              children: [
                                product.qty == 1
                                    ? IconButton(
                                        onPressed: () {
                                          showCupertinoModalPopup<void>(
                                            context: context,
                                            builder: (BuildContext context) =>
                                                CupertinoActionSheet(
                                              actions: <
                                                  CupertinoActionSheetAction>[
                                                CupertinoActionSheetAction(
                                                  /// This parameter indicates the action would be a default
                                                  /// defualt behavior, turns the action's text to bold text.
                                                  isDefaultAction: true,
                                                  onPressed: () async {
                                                    context
                                                                .read<Wish>()
                                                                .getWishItems
                                                                .firstWhereOrNull(
                                                                    (element) =>
                                                                        element
                                                                            .documentId ==
                                                                        product
                                                                            .documentId) !=
                                                            null
                                                        ? context
                                                            .read<Cart>()
                                                            .removeItem(product)
                                                        : await context
                                                            .read<Wish>()
                                                            .addWishItem(
                                                              product.name,
                                                              product.price,
                                                              1,
                                                              product.qntty,
                                                              product.imagesUrl,
                                                              product
                                                                  .documentId,
                                                              product.suppId,
                                                            );
                                                    // ignore: use_build_context_synchronously
                                                    context
                                                        .read<Cart>()
                                                        .removeItem(product);
                                                    // ignore: use_build_context_synchronously
                                                    Navigator.pop(context);
                                                  },
                                                  child: const Text(
                                                      'Добавить в избранное'),
                                                ),
                                                CupertinoActionSheetAction(
                                                  onPressed: () {
                                                    context
                                                        .read<Cart>()
                                                        .removeItem(product);
                                                    Navigator.pop(context);
                                                  },
                                                  child: const Text(
                                                      'Удалить продукт'),
                                                ),
                                                CupertinoActionSheetAction(
                                                  /// This parameter indicates the action would perform
                                                  /// a destructive action such as delete or exit and turns
                                                  /// the action's text color to red.
                                                  isDestructiveAction: true,
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: const Text('Отмена'),
                                                )
                                              ],
                                            ),
                                          );
                                        },
                                        icon: const Icon(Icons.delete_forever,
                                            size: 18))
                                    : IconButton(
                                        onPressed: () {
                                          cart.decrement(product);
                                        },
                                        icon: const Icon(FontAwesomeIcons.minus,
                                            size: 18)),
                                Text(product.qty.toString(),
                                    style: product.qty == product.qntty
                                        ? const TextStyle(
                                            fontSize: 20, color: Colors.red)
                                        : const TextStyle(fontSize: 20)),
                                IconButton(
                                    onPressed: product.qty == product.qntty
                                        ? null
                                        : () {
                                            cart.increment(product);
                                          },
                                    icon: const Icon(FontAwesomeIcons.plus,
                                        size: 18)),
                              ],
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
