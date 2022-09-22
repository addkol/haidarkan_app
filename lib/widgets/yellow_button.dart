import 'package:flutter/material.dart';

class YellowButton extends StatelessWidget {
  final String label;
  final Function() onPressed;
  final double width;
  const YellowButton(
      {Key? key,
        required this.label,
        required this.onPressed,
        required this.width})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 40,
        width: MediaQuery.of(context).size.width * width,
        decoration: BoxDecoration(
            border: Border.all(color: Colors.white),
            color: Colors.black, borderRadius: BorderRadius.circular(15)),
        child: MaterialButton(
          onPressed: onPressed,
          child: Text(label, style:const  TextStyle(color: Colors.white),),
        ));
  }
}
