import 'package:flutter/material.dart';

class AppBarBackButton extends StatelessWidget {
  const AppBarBackButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
        icon: const Icon(
          Icons.arrow_back_ios_new,
          color: Colors.black,
        ),
        onPressed: () {
          Navigator.pop(context);
        });
  }
}

class AppBarYellowButton extends StatelessWidget {
  const AppBarYellowButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
        icon: const Icon(
          Icons.arrow_back_ios_new,
          color: Colors.yellow,
        ),
        onPressed: () {
          Navigator.pop(context);
        });
  }
}

class AppBarTitle extends StatelessWidget {
  const AppBarTitle({
    Key? key,
    required this.title,
  }) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.black,
          fontFamily: 'Comfortaa',
          fontSize: 28,
          letterSpacing: 1.5,
        ),
      ),
    );
  }
}