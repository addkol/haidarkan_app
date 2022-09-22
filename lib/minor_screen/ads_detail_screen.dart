import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter_launch/flutter_launch.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


class AdsDetailsScreen extends StatefulWidget {
  final dynamic adsList;

  const AdsDetailsScreen({Key? key, required this.adsList}) : super(key: key);

  @override
  State<AdsDetailsScreen> createState() => _AdsDetailsScreenState();
}

class _AdsDetailsScreenState extends State<AdsDetailsScreen> {
  late final Stream<QuerySnapshot> _adsStream = FirebaseFirestore.instance
      .collection('ads')
      .where('maincateg', isEqualTo: widget.adsList['maincateg'])
      .snapshots();

  late List<dynamic> imagesList = widget.adsList['proimages'];

  @override
  Widget build(BuildContext context) {

    return Material(
      child: SafeArea(
        child: Scaffold(

          body: SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.black87, Colors.black],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Column(children: [
                Stack(
                  children: [
                    SizedBox(
                      width: double.maxFinite,
                      height: MediaQuery.of(context).size.height /2.5,
                      child: Swiper(
                        itemBuilder: (context, index) {
                          return Image(
                            image: NetworkImage(imagesList[index]),
                            fit: BoxFit.cover,
                          );
                        },
                        indicatorLayout: PageIndicatorLayout.COLOR,
                        itemCount: imagesList.length,
                        pagination: const SwiperPagination(),
                      ),
                    ),
                    Positioned(
                        left: 15,
                        top: 20,
                        child: CircleAvatar(
                          backgroundColor: Colors.white,
                          child: IconButton(
                            icon: const Icon(Icons.arrow_back_ios_new,
                                color: Colors.black),
                            onPressed: () {
                              Navigator.pop(context);

                              var appleInBytes = utf8.encode("apple");
                              String value = sha256.convert(appleInBytes).toString();
                              debugPrint(value.toString());
                            },
                          ),
                        )),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      widget.adsList['price'].toStringAsFixed(0) + ' сом',
                      style: const TextStyle(
                        fontSize: 22,
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      children: [
                        const Icon(
                          FontAwesomeIcons.whatsapp,
                          color: Colors.green,
                        ),
                        GestureDetector(
                          onTap: () async {
                            final number = widget.adsList['phonenumber'];
                            await FlutterLaunch.launchWhatsapp(
                                phone: '$number', message: '');
                          },
                          child: Text(
                            widget.adsList['phonenumber'],
                            style: const TextStyle(
                                color: Colors.green,
                                fontSize: 16,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  width: double.infinity,
                  child: Text(
                    widget.adsList['name'],
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                    softWrap: true,
                  ),
                ),
                const SizedBox(height: 10),
                const AdsDetailsHeader(
                  label: 'Описание',
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  width: double.infinity,
                  child: Text(
                    widget.adsList['desc'],
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 22, color: Colors.white70),

                    softWrap: true,
                  ),
                ),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}

class AdsDetailsHeader extends StatelessWidget {
  final String label;

  const AdsDetailsHeader({Key? key, required this.label}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            height: 40,
            width: 50,
            child: Divider(
              color: Colors.white54,
              thickness: 1,
            ),
          ),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(
            height: 40,
            width: 50,
            child: Divider(
              color: Colors.white54,
              thickness: 1,
            ),
          ),
        ],
      ),
    );
  }
}