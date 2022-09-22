import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:haidarkan_app/ads_galleries/all_ads_screen.dart';
import 'package:haidarkan_app/ads_galleries/animal_gallery.dart';
import 'package:haidarkan_app/ads_galleries/car_gallery.dart';
import 'package:haidarkan_app/ads_galleries/electronics_gallery.dart';
import 'package:haidarkan_app/ads_galleries/job_gallery.dart';
import 'package:haidarkan_app/ads_galleries/nedvijimost_screen.dart';
import 'package:haidarkan_app/ads_galleries/others_gallery.dart';
import 'package:haidarkan_app/ads_galleries/services_gallery.dart';

import '../widgets/appbar_widgets.dart';

class AdsScreen extends StatefulWidget {
  const AdsScreen({Key? key}) : super(key: key);

  @override
  State<AdsScreen> createState() => _AdsScreenState();
}

class _AdsScreenState extends State<AdsScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 8,
      child: Scaffold(
        appBar: AppBar(
          title: const AppBarTitle(label: 'Объявления'),

          centerTitle: true,
          backgroundColor: Colors.black12,
          bottom:  const TabBar(
            isScrollable: true,
            indicatorColor: Colors.black54,
            indicatorWeight: 5,
            tabs: [
              RepeatedTab(label: 'Все'),
              RepeatedTab(label: 'Транспорт'),
              RepeatedTab(label: 'Недвижимость'),
              RepeatedTab(label: 'Животные'),
              RepeatedTab(label: 'Электроника'),
              RepeatedTab(label: 'Услуги'),
              RepeatedTab(label: 'Работа'),
              RepeatedTab(label: 'Другие'),
            ],
          ),
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
              AllAdsScreen(),
              CarGalleryScreen(),
              NedvijimostGalleryScreen(),
              AnimalGalleryScreen(),
              ElectronicsGalleryScreen(),
              ServicesGalleryScreen(),
              JobGalleryScreen(),
              OthersGalleryScreen(),
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