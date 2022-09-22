import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:haidarkan_app/minor_screen/payment_screen.dart';

import 'package:provider/provider.dart';

import '../provider/cart_provider.dart';

import '../widgets/app_bar_widgets.dart';


class PlaceOrderScreen extends StatefulWidget {
  const PlaceOrderScreen({Key? key}) : super(key: key);

  @override
  State<PlaceOrderScreen> createState() => _PlaceOrderScreenState();
}

class _PlaceOrderScreenState extends State<PlaceOrderScreen> {
  CollectionReference customers =
      FirebaseFirestore.instance.collection('customers');

  @override
  Widget build(BuildContext context) {
    double totalPrice = context.watch<Cart>().totalPrice;
    return FutureBuilder<DocumentSnapshot>(
        future: customers.doc(FirebaseAuth.instance.currentUser!.uid).get(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text("Something went wrong");
          }

          if (snapshot.hasData && !snapshot.data!.exists) {
            return const Text("Document does not exist");
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Material(
              child: Center(
                child: CircularProgressIndicator(color: Colors.black,),
              ),
            );
          }

          if (snapshot.connectionState == ConnectionState.done) {
            Map<String, dynamic> data =
                snapshot.data!.data() as Map<String, dynamic>;
            return Material(
              color: Colors.grey.shade200,
              child: SafeArea(
                child: Scaffold(
                  backgroundColor: Colors.grey.shade200,
                  appBar: AppBar(
                    elevation: 0,
                    backgroundColor: Colors.grey.shade200,
                    leading: const AppBarBackButton(),
                    title: const AppBarTitle(
                      title: 'Разместить заказ',
                    ),
                  ),
                  body: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.black12, Colors.black],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 60),
                      child: Column(
                        children: [
                          Container(
                            height: 90,
                            width: double.infinity,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15)),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 4, horizontal: 16),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Text('Имя: ${data['name']}'),
                                    Text('Телефон: ${data['phone']}'),
                                  ]),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(15)),
                              child: Consumer<Cart>(
                                builder: (context, cart, child) {
                                  return ListView.builder(
                                      itemCount: cart.getItems.length,
                                      itemBuilder: (context, index) {
                                        final order = cart.getItems[index];
                                        return Padding(
                                          padding: const EdgeInsets.all(6.0),
                                          child: Container(
                                            height: 100,
                                            decoration: BoxDecoration(
                                              border: Border.all(width: 0.3),
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                            ),
                                            child: Row(
                                              children: [
                                                ClipRRect(
                                                  borderRadius:
                                                      const BorderRadius.only(
                                                          topLeft:
                                                              Radius.circular(15),
                                                          bottomLeft:
                                                              Radius.circular(
                                                                  15)),
                                                  child: SizedBox(
                                                    height: 100,
                                                    width: 100,
                                                    child: Image.network(
                                                        order.imagesUrl.first),
                                                  ),
                                                ),
                                                Flexible(
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceAround,
                                                    children: [
                                                      Text(order.name,
                                                          maxLines: 2,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight.w600,
                                                              fontSize: 16,
                                                              color: Colors.grey
                                                                  .shade600)),
                                                      Padding(
                                                        padding: const EdgeInsets
                                                                .symmetric(
                                                            vertical: 4,
                                                            horizontal: 12),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Text(
                                                                order.price
                                                                    .toStringAsFixed(
                                                                        2),
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    fontSize: 16,
                                                                    color: Colors
                                                                        .grey
                                                                        .shade600)),
                                                            Text(
                                                                'x ${order.qty.toString()}',
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    fontSize: 16,
                                                                    color: Colors
                                                                        .grey
                                                                        .shade600)),
                                                          ],
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        );
                                      });
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  bottomSheet: Container(

                    height: 60,
                    width: MediaQuery.of(context).size.width * 1,
                    color: Colors.black,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: MaterialButton(
                        color: Colors.white,
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const PaymentScreen()));
                        },
                        child: Text(
                            'Подтвердить ${totalPrice.toStringAsFixed(0)}', style:const  TextStyle(color: Colors.black),),
                      ),
                    ),
                  ),
                ),
              ),
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        });
  }
}
