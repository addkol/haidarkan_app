
import 'package:flutter/material.dart';

import '../provider/auth_repo.dart';
import '../widgets/app_bar_widgets.dart';
import '../widgets/yellow_button.dart';


class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.black,
      appBar: AppBar(
          leading: const AppBarBackButton(),
          elevation: 0,
          backgroundColor: Colors.black12,
          title: const AppBarTitle(
            title: 'Забыл пароль ?',
          )),
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.black12, Colors.black],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'для сброса пароля \n введите свой адрес электронной почты \n и нажмите кнопку ниже',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 24,
                        color: Colors.white,
                        letterSpacing: 1.2,

                       ),
                  ),
                  const SizedBox(height: 50),
                  TextFormField(
                    cursorColor: Colors.white,
                    controller: emailController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'пожалуйста, введите свой адрес электронной почты ';
                      } else if (!value.isValidEmailAddress()) {
                        return 'неверный адрес электронной почты';
                      } else if (value.isValidEmailAddress()) {
                        return null;
                      }
                      return null;
                    },
                    keyboardType: TextInputType.emailAddress,
                    decoration: emailFormDecoration.copyWith(
                      labelText: 'email адрес',
                      hintText: 'Введите email',
                        labelStyle: const TextStyle(color: Colors.white)
                    ),
                  ),
                  const SizedBox(height: 80),
                  YellowButton(
                      label: 'Сброс пароля',
                      onPressed: () async {
                        if (formKey.currentState!.validate()) {
                          try {
                            AuthRepo.sendPasswordResetEmail(emailController.text);
                          } catch (e) {
                            print(e);
                          }
                        } else {
                          print('Форма не правильная');
                        }
                      },
                      width: 0.7),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

var emailFormDecoration = InputDecoration(
  labelText: 'Имя',
  hintText: 'введите имя',
    labelStyle: const TextStyle(color: Colors.white),
  border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
  enabledBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.white, width: 1),
      borderRadius: BorderRadius.circular(6)),
  focusedBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.white, width: 2),
      borderRadius: BorderRadius.circular(6)),
);

extension EmailValidator on String {
  bool isValidEmailAddress() {
    return RegExp(
        r'^([a-zA-Z0-9]+)([\-\_\.]*)([a-zA-Z0-9]*)([@])([a-zA-Z0-9]{2,})([\.][a-zA-Z]{2,3})$')
        .hasMatch(this);
  }
}
