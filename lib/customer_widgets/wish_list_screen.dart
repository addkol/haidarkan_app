import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/wishlist_model.dart';
import '../provider/wish_provider.dart';

import '../widgets/alert_dialog.dart';
import '../widgets/app_bar_widgets.dart';


class WishlistScreen extends StatefulWidget {
  const WishlistScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: Scaffold(

          appBar: AppBar(

            elevation: 0,
            backgroundColor: Colors.black12,
            leading: const AppBarBackButton(),
            title: const Text(
              'Отмеченные',
              style: TextStyle(
                fontSize: 40, color: Colors.black ),
            ),
            centerTitle: true,
            actions: [
              context.watch<Wish>().getWishItems.isEmpty
                  ? const SizedBox()
                  : IconButton(
                  onPressed: () {
                    MyAlertDialog.showMyDialog(
                      context: context,
                      title: 'Очистить список желаемых?',
                      content:
                      'Вы уверены что хотите удлить из списка желаемых?',
                      tabNo: () {
                        Navigator.pop(context);
                      },
                      tabYes: () {
                        context.read<Wish>().clearWishlist();
                        Navigator.pop(context);
                      },
                    );
                  },
                  icon: const Icon(
                    Icons.delete_forever,
                    color: Colors.black,
                  ))
            ],
          ),
          body: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.black12, Colors.black],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child:
          context.watch<Wish>().getWishItems.isNotEmpty
              ? const WishItems()
              : const EmptyWishlist(),),
        ),
      ),
    );
  }
}

class EmptyWishlist extends StatelessWidget {
  const EmptyWishlist({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Text(
            'список желаний пуст',
            style: TextStyle(fontSize: 30, color: Colors.white),
          ),
        ],
      ),
    );
  }
}

class WishItems extends StatelessWidget {
  const WishItems({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<Wish>(
      builder: (context, wish, child) {
        return ListView.builder(
            itemCount: wish.getWishItems.length,
            itemBuilder: (context, index) {
              final product = wish.getWishItems[index];
              return WishlistModel(product: product);
            });
      },
    );
  }
}
