import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:haidarkan_app/gallery/all_store_gallery.dart';
import 'package:haidarkan_app/widgets/appbar_widgets.dart';

class StoresScreen extends StatefulWidget {
  const StoresScreen({Key? key}) : super(key: key);

  @override
  State<StoresScreen> createState() => _StoresScreenState();
}

class _StoresScreenState extends State<StoresScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 8,
      child: Scaffold(
        appBar: AppBar(
          title: const AppBarTitle(label: 'Магазины'),
          backgroundColor: Colors.black12,
          centerTitle: true,
          // bottom:  const TabBar(
          //   isScrollable: true,
          //   indicatorColor: Colors.black54,
          //   indicatorWeight: 5,
          //   tabs: [
          //     RepeatedTab(label: 'Все'),
          //     RepeatedTab(label: 'Одежды'),
          //     RepeatedTab(label: 'Электроника'),
          //     RepeatedTab(label: 'Аксессуары'),
          //     RepeatedTab(label: 'Обувь'),
          //     RepeatedTab(label: 'Для дома'),
          //     RepeatedTab(label: 'Красота'),
          //     RepeatedTab(label: 'Другие'),
          //   ],
          // ),
        ),
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.black12, Colors.black],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child:  const TabBarView(
            children: [
              AllGallery(),
              Center(child: Text('Одежды')),
              Center(child: Text('Электроника')),
              Center(child: Text('Аксессуары')),
              Center(child: Text('Обувь')),
              Center(child: Text('Для дома')),
              Center(child: Text('Красота')),
              Center(child: Text('Другие')),
            ],
          ),),
      ),
    );
  }
}

class RepeatedTab extends StatelessWidget {
  final String label;

  const RepeatedTab({
    Key? key,
    required this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Tab(
      child: Text(
        label,
        style: GoogleFonts.roboto(
            fontWeight: FontWeight.bold
        ),
      ),
    );
  }
}