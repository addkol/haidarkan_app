import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:haidarkan_app/auth/customer_login.dart';
import 'package:provider/provider.dart';

import '../minor_screen/place_order.dart';
import '../model/cart_model.dart';
import '../provider/cart_provider.dart';
import '../widgets/alert_dialog.dart';

class CartScreen extends StatefulWidget {
  final Widget? back;

  const CartScreen({Key? key, this.back}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {

 void checkAuth() {
   if (FirebaseAuth.instance.currentUser?.uid ==null) {
     if(FirebaseAuth.instance.currentUser!.emailVerified) {
      return;
     }
   }
 }

  @override
  Widget build(BuildContext context) {



    double total = context.watch<Cart>().totalPrice;
    return Material(
      child: SafeArea(
        child: Scaffold(

          appBar: AppBar(
            backgroundColor: Colors.black12,
            leading: widget.back,
            title: const Text(
              'Корзина',
              style: TextStyle(
                fontSize: 40,
                color: Colors.white,
              ),
            ),
            centerTitle: true,
            actions: [
              context.watch<Cart>().getItems.isEmpty
                  ? const SizedBox()
                  : IconButton(
                      onPressed: () {
                        MyAlertDialog.showMyDialog(
                          context: context,
                          title: 'Очистить корзину?',
                          content: 'Вы уверены что хотите очистить корзину?',
                          tabNo: () {
                            Navigator.pop(context);
                          },
                          tabYes: () {
                            context.read<Cart>().clearCart();
                            Navigator.pop(context);
                          },
                        );
                      },
                      icon: const Icon(
                        Icons.delete_forever,
                        color: Colors.white,
                      ))
            ],
          ),
          body: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.black54, Colors.black],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: context.watch<Cart>().getItems.isNotEmpty
              ? const CartItems()
              : const EmptyCart(), ),

          bottomSheet: Padding(
            padding: const EdgeInsets.all(0.0),
            child: Container(
              color: Colors.black,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [

                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Text(
                          '${total.toStringAsFixed(0)} сом',
                          style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                  Container(

                    height: 35,
                    width: MediaQuery.of(context).size.width * 0.45,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.white),
                        color: Colors.black87,
                        borderRadius: BorderRadius.circular(15)),
                    child: (FirebaseAuth.instance.currentUser?.uid == null || FirebaseAuth.instance.currentUser!.emailVerified == false)
                        ? TextButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const CustomerLogin()));
                            },
                            child: const Text(
                              'Войти',
                              style: TextStyle(color: Colors.white),
                            ))
                        : MaterialButton(
                            onPressed: total == 0.0
                                ? null
                                : () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                            const PlaceOrderScreen()));
                                  },
                            child: const Text(
                              'Проверить',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class EmptyCart extends StatelessWidget {
  const EmptyCart({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Ваша корзина пуста',
            style: TextStyle(fontSize: 30, color: Colors.white),
          ),
          const SizedBox(
            height: 50,
          ),
          Material(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25),
              child: MaterialButton(
                minWidth: MediaQuery.of(context).size.width * 0.6,
                onPressed: () {
                  Navigator.canPop(context)
                      ? Navigator.pop(context)
                      : Navigator.pushReplacementNamed(
                          context, '/customer_home');
                },
                child: const Text(
                  'Продолжить покупку',
                  style: TextStyle(fontSize: 18, color: Colors.black),
                ),
              ))
        ],
      ),
    );
  }
}

class CartItems extends StatelessWidget {
  const CartItems({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<Cart>(
      builder: (context, cart, child) {
        return ListView.builder(
            itemCount: cart.getItems.length,
            itemBuilder: (context, index) {
              final product = cart.getItems[index];

              return CartModel(
                product: product,
                cart: context.read<Cart>(),
              );
            });
      },
    );
  }
}
