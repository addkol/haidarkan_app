import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_launch/flutter_launch.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:haidarkan_app/auth/customer_login.dart';
import 'package:haidarkan_app/gallery/all_store_gallery.dart';
import 'package:haidarkan_app/main_screen/ads_screen.dart';
import 'package:haidarkan_app/main_screen/profile_screen.dart';


import '../minor_screen/search_screen.dart';


class CustomerHomeScreen extends StatefulWidget {
  const CustomerHomeScreen({Key? key}) : super(key: key);

  @override
  State<CustomerHomeScreen> createState() => _CustomerHomeScreenState();
}

class _CustomerHomeScreenState extends State<CustomerHomeScreen> {
  int _selectedIndex = 0;
  final List<Widget> _tabs = [
    const AdsScreen(),
    const AllGallery(),
    const SearchScreen(),
   const ProfileScreen()

  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _tabs[_selectedIndex],
      bottomNavigationBar: GNav(

        onTabChange: (index) {
          setState(() {
            _selectedIndex = index;
            print(index);
          });
        },
        iconSize: 24,
        gap: 2,
        padding: const EdgeInsets.all(10),
        backgroundColor: Colors.black,
        color: Colors.white,
        activeColor: Colors.white,
        tabs: const [
          GButton(
            icon: Icons.list_outlined,
            text: 'Объявления',
          ),
          GButton(
            icon: Icons.store_rounded,
            text: 'Магазины',
          ),
          GButton(
            icon: Icons.search,
            text: 'Поиск',
          ),
          GButton(
            icon: Icons.person,
            text: 'Профиль',
          )
        ],
      ),
      floatingActionButton:

      FloatingActionButton(
        backgroundColor: Colors.green,
        child: const Icon(
          FontAwesomeIcons.whatsapp,
          color: Colors.white,
          size: 40,
        ),
        onPressed: () async{
              const number = '+996776149999';
              await FlutterLaunch.launchWhatsapp(
                  phone: number, message: '');
        },
      ),
    );
  }
}
