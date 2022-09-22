import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';

class MyMessageHandler{
  static void showSnackBar(var scaffoldKey, String message){
    scaffoldKey.currentState!.hideCurrentSnackBar();
    scaffoldKey.currentState!.showSnackBar( SnackBar(
        backgroundColor: Colors.white,
        duration: const Duration(seconds: 2),
        content: Text(message, textAlign: TextAlign.center, style: const TextStyle(fontSize: 18, color: Colors.black),)));
  }
}

class MyMessagePayment{
  static void showSnackBar(var scaffoldKey, String message){
    scaffoldKey.currentState!.hideCurrentSnackBar();
    scaffoldKey.currentState!.showSnackBar(
        SnackBar(
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          content: AwesomeSnackbarContent(
            title: 'On Snap!',
            message:
            message,
            contentType: ContentType.failure,
          ),
        )

    );
  }
}