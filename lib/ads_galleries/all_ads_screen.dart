import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../model/ads_model.dart';


class AllAdsScreen extends StatefulWidget {
  const AllAdsScreen({Key? key}) : super(key: key);

  @override
  State<AllAdsScreen> createState() => _AllAdsScreenState();
}

class _AllAdsScreenState extends State<AllAdsScreen> {
  final Stream<QuerySnapshot> _adsStream =
  FirebaseFirestore.instance.collection('ads').orderBy('create', descending: true).snapshots();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _adsStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator(color: Colors.black,));
        }

        if (snapshot.data!.docs.isEmpty) {
          return const Center(
            child: Text(
              'Здесь пока пусто',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 26, color: Colors.white),
            ),
          );
        }

        return SingleChildScrollView(
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, childAspectRatio: 0.68),
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (BuildContext context, int index) {
                return AdsModel(ads: snapshot.data!.docs[index]);
              },
            ),
        );
      },
    );
  }
}
