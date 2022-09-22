import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


import 'package:provider/provider.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';


import 'package:uuid/uuid.dart';

import '../provider/cart_provider.dart';
import '../widgets/app_bar_widgets.dart';

import '../widgets/yellow_button.dart';



class PaymentScreen extends StatefulWidget {
  const PaymentScreen({Key? key}) : super(key: key);

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  int selectedValue = 1;
  late String orderId;
  CollectionReference customers =
  FirebaseFirestore.instance.collection('customers');
  void showProgress() {
    ProgressDialog progress = ProgressDialog(context: context);
    progress.show(max: 100, msg: 'Ждите ...', progressBgColor: Colors.red);
  }

  @override
  Widget build(BuildContext context) {
    double totalPrice = context.watch<Cart>().totalPrice;
    double totalPaid = context.watch<Cart>().totalPrice + 100;
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
                child: CircularProgressIndicator(color: Colors.black),
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
                  backgroundColor: Colors.black,
                  appBar: AppBar(
                    centerTitle: true,
                    elevation: 0,
                    backgroundColor: Colors.grey.shade200,
                    leading: const AppBarBackButton(),
                    title: const AppBarTitle(
                      title: 'Оплата',
                    ),
                  ),
                  body: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 60),
                    child: Column(
                      children: [
                        Container(
                          height: 120,
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
                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        'Итого',
                                        style: TextStyle(fontSize: 20),
                                      ),
                                      SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Text(
                                            '${totalPaid.toStringAsFixed(0)} сом',
                                            style:
                                            const TextStyle(fontSize: 20)),
                                      ),
                                    ],
                                  ),
                                  const Divider(
                                      color: Colors.grey, thickness: 2),
                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        'Общий заказ',
                                        style: TextStyle(
                                            fontSize: 16, color: Colors.grey),
                                      ),
                                      SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Text(
                                            '${totalPrice.toStringAsFixed(0)} сом',
                                            style: const TextStyle(
                                                fontSize: 16,
                                                color: Colors.grey)),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: const [
                                      Text(
                                        'Доставка',
                                        style: TextStyle(
                                            fontSize: 16, color: Colors.grey),
                                      ),
                                      Text('100 сом',
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.grey)),
                                    ],
                                  ),
                                ]),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
height: 100,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,

                            children: const [

                               Padding(
                                 padding: EdgeInsets.all(10.0),
                                 child: Center(child: Text('Для оплаты товара нажмите подтвердить, наш оператор свяжется с вами')),
                               ),

                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  bottomSheet: Container(
                    color: Colors.black,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: YellowButton(
                          label: 'Подтвердить ${totalPaid.toStringAsFixed(0)}',
                          width: 1,
                          onPressed: () {

                              showModalBottomSheet(
                                  context: context,
                                  builder: (context) => SizedBox(
                                    height:
                                    MediaQuery.of(context).size.height *
                                        0.3,
                                    child: Padding(
                                      padding:
                                      const EdgeInsets.only(bottom: 80),
                                      child: Column(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                        children: [
                                          Center(
                                            child: Text(
                                              '${totalPaid.toStringAsFixed(0)} сом',
                                              style: const TextStyle(
                                                  fontSize: 20),
                                            ),
                                          ),
                                          YellowButton(
                                              label:
                                              'Подтвердить ${totalPaid.toStringAsFixed(0)} сом',
                                              onPressed: () async {
                                                showProgress();
                                                for (var item in context
                                                    .read<Cart>()
                                                    .getItems) {
                                                  CollectionReference
                                                  orderRef =
                                                  FirebaseFirestore
                                                      .instance
                                                      .collection(
                                                      'orders');
                                                  orderId =
                                                      const Uuid().v4();
                                                  await orderRef
                                                      .doc(orderId)
                                                      .set({
                                                    'cid': data['cid'],
                                                    'custname':
                                                    data['name'],
                                                    'phone':
                                                    data['numberPhone'],
                                                    'sid': item.suppId,
                                                    'proId':
                                                    item.documentId,
                                                    'orderid': orderId,
                                                    'ordername': item.name,
                                                    'orderimage': item
                                                        .imagesUrl.first,
                                                    'orderqty': item.qty,
                                                    'orderprice': item.qty *
                                                        item.price,
                                                    'deliverystatus':
                                                    'подготовка',
                                                    'deliverydate': '',
                                                    'orderdate':
                                                    DateTime.now(),
                                                    'paymentstatus':
                                                    'оплата при доставке',
                                                    'orederreview': false,
                                                  }).whenComplete(() async {
                                                    await FirebaseFirestore
                                                        .instance
                                                        .runTransaction(
                                                            (transaction) async {
                                                          DocumentReference
                                                          documentReference =
                                                          FirebaseFirestore
                                                              .instance
                                                              .collection(
                                                              'products')
                                                              .doc(item
                                                              .documentId);
                                                          DocumentSnapshot
                                                          snapshot2 =
                                                          await transaction.get(
                                                              documentReference);
                                                          transaction.update(
                                                              documentReference,
                                                              {
                                                                'instock':
                                                                snapshot2[
                                                                'instock'] -
                                                                    item.qty
                                                              });
                                                        });
                                                  });
                                                }
                                                await Future.delayed(
                                                    const Duration(
                                                        microseconds:
                                                        100))
                                                    .whenComplete(() {
                                                  context
                                                      .read<Cart>()
                                                      .clearCart();
                                                  Navigator.popUntil(
                                                      context,
                                                      ModalRoute.withName(
                                                          '/customer_home'));
                                                });
                                              },
                                              width: 0.9)
                                        ],
                                      ),
                                    ),
                                  ));

                          }),
                    ),
                  ),
                ),
              ),
            );
          }
          return const Center(
            child: CircularProgressIndicator(color: Colors.black,),
          );
        });
  }
}
