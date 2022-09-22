import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:haidarkan_app/provider/auth_repo.dart';

import '../widgets/auth_widgets.dart';
import '../widgets/snackbar.dart';

class CustomerRegister extends StatefulWidget {
  const CustomerRegister({Key? key}) : super(key: key);

  @override
  State<CustomerRegister> createState() => _CustomerRegisterState();
}

class _CustomerRegisterState extends State<CustomerRegister> {
  late String name;
  late String address;
  late String phone;
  late String email;
  late String password;
  late String _uid;
  bool processing = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();
  bool passwordVisible = true;

  CollectionReference customers =
      FirebaseFirestore.instance.collection('customers');

  void sigUp() async {
    setState(() {
      processing = true;
    });
    if (_formKey.currentState!.validate()) {
      try {
        await AuthRepo.signUpWithEmailAndPassword(email, password);
        await AuthRepo.sendEmailVerification();
        _uid = AuthRepo.uid;
        AuthRepo.updateUserName(name);
        await customers.doc(_uid).set({
          'name': name,
          'email': email,
          'phone': phone,
          'address': address,
          'cid': _uid
        });
        _formKey.currentState!.reset();
        await Future.delayed(const Duration(microseconds: 100)).whenComplete(
            () => Navigator.pushReplacementNamed(context, '/customer_login'));
      } on FirebaseAuthException catch (e) {
        setState(() {
          processing = false;
        });
        MyMessageHandler.showSnackBar(_scaffoldKey, e.message.toString());
      }
    } else {
          setState(() {
            processing = false;
          });
          MyMessageHandler.showSnackBar(_scaffoldKey, 'заполните все поля');
        }
      }


  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: _scaffoldKey,
      child: Scaffold(
        body: Container(
          width: double.maxFinite,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.black12, Colors.black],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                reverse: true,
                child: Form(
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.all(25.0),
                    child: Column(
                      children: [
                        const AuthHeaderLabel(headerLabel: 'Регистрация'),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          child: TextFormField(
                            cursorColor: Colors.white,
                            // controller: _nameController,
                            validator: (value) {
                              if (value!.isEmpty) {
                                MyMessageHandler.showSnackBar(
                                    _scaffoldKey, 'заполните имя');
                              }
                              return null;
                            },
                            onChanged: (value) {
                              name = value;
                            },
                            style: const TextStyle(color: Colors.white),
                            decoration: textFormDecoration.copyWith(
                                labelText: 'имя', hintText: 'введите имя', labelStyle: const TextStyle(color: Colors.white)),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          child: TextFormField(
                            cursorColor: Colors.white,
                            keyboardType: TextInputType.phone,
                            // controller: _nameController,
                            validator: (value) {
                              if (value!.isEmpty) {
                                MyMessageHandler.showSnackBar(
                                    _scaffoldKey, 'заполните номер мобильного');
                              }
                              return null;
                            },
                            onChanged: (value) {
                              phone = value;
                            },
                            style: const TextStyle(color: Colors.white),
                            decoration: textFormDecoration.copyWith(
                                labelText: 'номер', hintText: 'введите номер', labelStyle: const TextStyle(color: Colors.white)),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          child: TextFormField(
                            // controller: _nameController,
                            cursorColor: Colors.white,
                            validator: (value) {
                              if (value!.isEmpty) {
                                MyMessageHandler.showSnackBar(
                                    _scaffoldKey, 'улица, д. кв.');
                              }
                              return null;
                            },
                            onChanged: (value) {
                              address = value;
                            },
                            style: const TextStyle(color: Colors.white),
                            decoration: textFormDecoration.copyWith(
                                labelText: 'адрес', hintText: 'введите адрес',labelStyle: const TextStyle(color: Colors.white)),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          child: TextFormField(
                            cursorColor: Colors.white,
                            keyboardType: TextInputType.emailAddress,
                            // controller: _emailController,
                            validator: (value) {
                              if (value!.isEmpty) {
                                MyMessageHandler.showSnackBar(
                                    _scaffoldKey, 'заполните email');
                              } else if (value.isValidEmail() == false) {
                                MyMessageHandler.showSnackBar(
                                    _scaffoldKey, 'неправильный email');
                              } else if (value.isValidEmail() == true) {
                                return null;
                              }
                              return null;
                            },
                            onChanged: (value) {
                              email = value;
                            },
                            style: const TextStyle(color: Colors.white),
                            decoration: textFormDecoration.copyWith(
                                labelText: 'email', hintText: 'введите email', labelStyle: const TextStyle(color: Colors.white)),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          child: TextFormField(
                            cursorColor: Colors.white,
                            // controller: _passwordController,
                            validator: (value) {
                              if (value!.isEmpty) {
                                MyMessageHandler.showSnackBar(
                                    _scaffoldKey, 'заполните пароль');
                              }
                              return null;
                            },
                            onChanged: (value) {
                              password = value;
                            },
                            obscureText: passwordVisible,
                            style: const TextStyle(color: Colors.white),
                            decoration: textFormDecoration.copyWith(
                                suffixIcon: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        passwordVisible = !passwordVisible;
                                      });
                                    },
                                    icon: Icon(
                                      passwordVisible
                                          ? Icons.visibility_off
                                          : Icons.visibility,
                                      color: Colors.white60,
                                    )),
                                labelText: 'пароль',
                                hintText: 'введите пароль', labelStyle: const TextStyle(color: Colors.white)),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 15),
                          child: HaveAccount(
                            haveAccount: 'уже есть аккаунт?',
                            actionLabel: 'Войти',
                            onPressed: () {
                              Navigator.pushReplacementNamed(
                                  context, '/customer_login');
                            },
                          ),
                        ),
                        processing == true
                            ? const Center(
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                              )
                            : AuthMainButton(
                                mainButtonLabel: 'Зарегистрироваться',
                                onPressed: () {
                                  sigUp();
                                },
                              )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
