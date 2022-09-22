import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../model/product_model.dart';
import '../widgets/appbar_widgets.dart';


class AllGallery extends StatefulWidget {
  const AllGallery({Key? key}) : super(key: key);

  @override
  State<AllGallery> createState() => _AllGalleryState();
}

class _AllGalleryState extends State<AllGallery> {
  final Stream<QuerySnapshot> _productStream =
  FirebaseFirestore.instance.collection('products').snapshots();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _productStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text('Перезапустите приложение');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator(color: Colors.black));
        }

        if (snapshot.data!.docs.isEmpty) {
          return Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.black12, Colors.black],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: const Center(
              child: Text(
                'Здесь пока пусто',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 26, color: Colors.white),
              ),
            ),
          );
        }
        return Scaffold(appBar: AppBar(
          elevation: 0,
          title: const AppBarTitle(label: 'Онлайн Магазин'),
          backgroundColor: Colors.black12,
          centerTitle: true,
        ),
        body: Container(
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.black12, Colors.black],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: SingleChildScrollView(
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, childAspectRatio: 0.60),
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (BuildContext context, int index) {
                return ProductModel(products: snapshot.data!.docs[index]);
              },
            ),
          ),
        ),);

      },
    );
  }
}
