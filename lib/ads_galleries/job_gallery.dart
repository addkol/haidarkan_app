import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../model/ads_model.dart';



class JobGalleryScreen extends StatefulWidget {
  const JobGalleryScreen({Key? key}) : super(key: key);

  @override
  State<JobGalleryScreen> createState() => _JobGalleryScreenState();
}

class _JobGalleryScreenState extends State<JobGalleryScreen> {
  final Stream<QuerySnapshot> _adsStream = FirebaseFirestore.instance
      .collection('ads')
      .where('maincateg', isEqualTo: 'rabota')
      .orderBy('create', descending: true)
      .snapshots();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _adsStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text('Перезапустите приложение');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator(color: Colors.black));
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
                crossAxisCount: 2, childAspectRatio: 0.75),
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
