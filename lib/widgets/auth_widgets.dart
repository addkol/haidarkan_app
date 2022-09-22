
import 'package:flutter/material.dart';

class AuthMainButton extends StatelessWidget {
  final String mainButtonLabel;
  final Function() onPressed;

  const AuthMainButton(
      {Key? key, required this.mainButtonLabel, required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(

      borderRadius: BorderRadius.circular(15),
      color: Colors.white,
      child: MaterialButton(
        onPressed: onPressed,
        child: Text(
          mainButtonLabel,
          style: const TextStyle(
              fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black54),
        ),
      ),
    );
  }
}

class HaveAccount extends StatelessWidget {
  final String haveAccount;
  final String actionLabel;
  final Function() onPressed;

  const HaveAccount(
      {Key? key,
        required this.haveAccount,
        required this.actionLabel,
        required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          haveAccount,
          style: const TextStyle(
              fontSize: 16, fontStyle: FontStyle.italic, color: Colors.white60),
        ),
        TextButton(
            onPressed: onPressed,
            child: Text(
              actionLabel,
              style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20),
            )),
      ],
    );
  }
}

class AuthHeaderLabel extends StatelessWidget {
  final String headerLabel;

  const AuthHeaderLabel({
    Key? key,
    required this.headerLabel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Text(
        headerLabel,
        style: const TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
      ),
    );
  }
}


var textFormDecoration = InputDecoration(
  labelText: 'имя',
  labelStyle: const TextStyle(color: Colors.white),
  hintText: 'введите имя',
  border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(15),
  ),

  enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(15),
    borderSide: const BorderSide(color: Colors.white, width: 2),
  ),
  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(15),
    borderSide: const BorderSide(color: Colors.white),
  ),
);

extension EmailValidator on String {
  bool isValidEmail() {
    return RegExp(
        r'^([a-zA-Z0-9]+)([\-\_\.]*)([a-zA-Z0-9]*)([@])([a-zA-Z0-9]{2,})([\.][a-zA-Z]{2,3})$')
        .hasMatch(this);
  }
}