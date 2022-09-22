import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:haidarkan_app/minor_screen/forgot_password.dart';
import 'package:haidarkan_app/widgets/yellow_button.dart';

import '../provider/auth_repo.dart';
import '../widgets/auth_widgets.dart';
import '../widgets/snackbar.dart';

class CustomerLogin extends StatefulWidget {
  const CustomerLogin({Key? key}) : super(key: key);

  @override
  State<CustomerLogin> createState() => _CustomerLoginState();
}

class _CustomerLoginState extends State<CustomerLogin> {
  CollectionReference customers =
      FirebaseFirestore.instance.collection('customers');

  Future<bool> checkIfDocExists(String docId) async {
    try {
      var doc = await customers.doc(docId).get();
      return doc.exists;
    } catch (e) {
      return false;
    }
  }

  bool docExists = false;

  Future<UserCredential> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    return await FirebaseAuth.instance
        .signInWithCredential(credential)
        .whenComplete(() async {
      User user = FirebaseAuth.instance.currentUser!;
      docExists = await checkIfDocExists(user.uid);

      docExists == false
          ? await customers.doc(user.uid).set({
              'name': user.displayName,
              'email': user.email,
              'phone': '',
              'address': '',
              'cid': user.uid
            }).then((value) => navigate())
          : navigate();
    });
  }

  late String email;
  late String password;
  bool processing = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();
  bool passwordVisible = true;
  bool sendEmailVerification = false;

  void navigate() {
    Navigator.pushReplacementNamed(context, '/customer_home');
  }

  void logIn() async {
    setState(() {
      processing = true;
    });
    if (_formKey.currentState!.validate()) {
      try {
        await AuthRepo.signInWithEmailAndPassword(email, password);
        await AuthRepo.reloadUserData();
        if (await AuthRepo.checkEmailVerification()) {
          _formKey.currentState!.reset();
          await Future.delayed(const Duration(microseconds: 100)).whenComplete(
              () => Navigator.pushReplacementNamed(context, '/customer_home'));
        } else {
          MyMessageHandler.showSnackBar(
              _scaffoldKey, 'пожалуйста подтвердите email');
          setState(() {
            processing = false;
            sendEmailVerification = true;
          });
        }
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          setState(() {
            processing = false;
          });
          MyMessageHandler.showSnackBar(_scaffoldKey, 'пользователь не найден');
        } else if (e.code == 'wrong-password') {
          setState(() {
            processing = false;
          });
          MyMessageHandler.showSnackBar(_scaffoldKey, 'неправильный пароль');
        }
      } catch (e) {
        setState(() {
          processing = false;
        });
        debugPrint(e.toString());
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
                        const AuthHeaderLabel(headerLabel: 'Вход'),
                        SizedBox(
                            height: 40,
                            child: sendEmailVerification == true
                                ? Center(
                                    child: YellowButton(
                                        label: 'отправить подтверждение',
                                        onPressed: () async {
                                          try {
                                            await FirebaseAuth
                                                .instance.currentUser!
                                                .sendEmailVerification();
                                          } catch (e) {
                                            debugPrint(e.toString());
                                          }
                                          Future.delayed(
                                                  const Duration(seconds: 3))
                                              .whenComplete(() {
                                            setState(() {
                                              sendEmailVerification = false;
                                            });
                                          });
                                        },
                                        width: 0.6),
                                  )
                                : const SizedBox()),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          child: TextFormField(
                            cursorColor: Colors.white,

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
                                labelText: 'email',
                                hintText: 'введите email',
                                labelStyle:
                                    const TextStyle(color: Colors.white)),
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
                                hintText: 'введите пароль',
                                labelStyle:
                                    const TextStyle(color: Colors.white)),
                          ),
                        ),
                        TextButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const ForgotPassword()));
                            },
                            child: const Text(
                              'Забыли пароль?',
                              style: TextStyle(color: Colors.white),
                            )),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 15.0),
                          child: HaveAccount(
                            haveAccount: 'нету аккаунта?',
                            actionLabel: 'Регистрация',
                            onPressed: () {
                              Navigator.pushReplacementNamed(
                                  context, '/customer_signup');
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
                                mainButtonLabel: 'Войти',
                                onPressed: () {
                                  logIn();
                                },
                              ),
                        const SizedBox(height: 20),
                        googleLogInButton(),
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

  Widget googleLogInButton() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(50, 50, 50, 20),
      child: Material(
        elevation: 3,
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        child: MaterialButton(
          onPressed: () {
            signInWithGoogle();
          },
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
            SvgPicture.asset('assets/icons/google.svg'),
            const Text(
              'Sign In With Google',
              style: TextStyle(color: Colors.black, fontSize: 16),
            )
          ]),
        ),
      ),
    );
  }
}
