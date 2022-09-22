import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppBarTitle extends StatelessWidget {
  final String label;
  const AppBarTitle({Key? key, required this.label}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        label,
        style: GoogleFonts.combo(fontWeight: FontWeight.bold, fontSize: 30, color: Colors.black),
      ),
    );
  }
}
