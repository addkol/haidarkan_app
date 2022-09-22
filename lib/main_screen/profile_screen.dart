import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:haidarkan_app/auth/customer_login.dart';
import 'package:haidarkan_app/widgets/auth_widgets.dart';

import '../customer_widgets/customers_orders.dart';
import '../customer_widgets/wish_list_screen.dart';
import '../provider/auth_repo.dart';
import '../widgets/alert_dialog.dart';
import '../widgets/app_bar_widgets.dart';
import '../widgets/snackbar.dart';
import 'cart_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();
  bool processing = false;
  late String? documentId = FirebaseAuth.instance.currentUser?.uid;
  CollectionReference customers =
      FirebaseFirestore.instance.collection('customers');

  void authCheck() async {
    setState(() {
      processing = true;
    });
    if (await AuthRepo.checkEmailVerification()) {
      await Future.delayed(const Duration(microseconds: 100)).whenComplete(
          () => Navigator.pushReplacementNamed(context, '/customer_home'));
    } else {
      MyMessageHandler.showSnackBar(
          _scaffoldKey, 'пожалуйста подтвердите email');
      setState(() {
        processing = false;
      });
    }
  }

  @override
  void initState() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user != null) {
        print(user.uid);
        setState(() {
          documentId = user.uid;
        });
      }
    });
    super.initState();
  }

  // @override
  // void dispose() {
  //
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future: customers.doc(documentId).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Center(
              child: Text(
            "Что-то пошло не так, перезапустите приложение",
            style: TextStyle(
                fontSize: 30,
                color: Colors.redAccent,
                fontWeight: FontWeight.bold),
          ));
        }

        if (snapshot.hasData && !snapshot.data!.exists) {

           return
           Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.black12, Colors.black],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  "Документ не существует или вы не вошли в систему",
                  style: TextStyle(
                      fontSize: 30,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 30),
                processing == true
                    ? const Center(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                )
                    :
                AuthMainButton(
                    mainButtonLabel: 'Войти',
                    onPressed: () async{
                      setState(() {
                        processing == true;
                      });
                      await Future.delayed(const Duration(microseconds: 100)).whenComplete(
                              () => Navigator.pushReplacementNamed(context, '/customer_login'));
                    }),
              ],
            ),
          );
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          return Scaffold(
            appBar: AppBar(
                automaticallyImplyLeading: false,
                elevation: 0,
                backgroundColor: Colors.black12,
                centerTitle: true,
                title: const AppBarTitle(
                  title: 'Профиль',
                )),
            body: SingleChildScrollView(
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.black12, Colors.black],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16)),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(15),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      ('Имя: ${data['name']}'),
                                      style: const TextStyle(
                                        color: Colors.black87,
                                        fontSize: 20,
                                      ),
                                    ),
                                    Text(
                                      ('Email: ${data['email']}'),
                                      style: const TextStyle(
                                        color: Colors.black87,
                                        fontSize: 20,
                                      ),
                                    ),
                                    Text(
                                      ('Номер: ${data['phone']}'),
                                      style: const TextStyle(
                                        color: Colors.black87,
                                        fontSize: 20,
                                      ),
                                    ),
                                    Text(
                                      ('Адрес: ${data['address']}'),
                                      style: const TextStyle(
                                        color: Colors.black87,
                                        fontSize: 20,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height,
                      color: Colors.black,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              children: [
                                RepeatedListTile(
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const CartScreen(
                                                    back: AppBarBackButton(),
                                                  )));
                                    },
                                    title: 'Корзина',
                                    icon: Icons.shopping_cart),
                                const YellowDivider(),
                                RepeatedListTile(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const CustomerOrders()));
                                  },
                                  title: 'Заказы',
                                  icon: Icons.store_mall_directory,
                                ),
                                const YellowDivider(),
                                RepeatedListTile(
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const WishlistScreen()));
                                    },
                                    title: 'Отмеченные',
                                    icon: Icons.favorite),
                                const YellowDivider(),
                                RepeatedListTile(
                                    title: 'Выход',
                                    icon: Icons.logout,
                                    onPressed: () {
                                      MyAlertDialog.showMyDialog(
                                          context: context,
                                          title: 'Выход',
                                          content:
                                              'Вы действительно хотите выйти?',
                                          tabYes: () async {
                                            await FirebaseAuth.instance
                                                .signOut();
                                            await Future.delayed(const Duration(
                                                    microseconds: 100))
                                                .whenComplete(() {
                                              Navigator.pop(context);
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          const CustomerLogin()));
                                            });
                                          },
                                          tabNo: () {
                                            Navigator.pop(context);
                                          });
                                    }),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        return const Center(
            child: CircularProgressIndicator(
          color: Colors.black,
        ));
      },
    );
  }
}

class YellowDivider extends StatelessWidget {
  const YellowDivider({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 40),
      child: Divider(
        color: Colors.white,
        thickness: 1,
      ),
    );
  }
}

class RepeatedListTile extends StatelessWidget {
  final String title;
  final String subTitle;
  final IconData icon;
  final Function()? onPressed;

  const RepeatedListTile(
      {Key? key,
      required this.title,
      this.subTitle = '',
      required this.icon,
      this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: ListTile(
        title: Text(title),
        tileColor: Colors.white,
        textColor: Colors.white,
        subtitle: Text(subTitle),
        leading: Icon(icon),
        iconColor: Colors.white,
      ),
    );
  }
}
