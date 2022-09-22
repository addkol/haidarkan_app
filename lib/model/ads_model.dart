
import 'package:flutter/material.dart';

import '../minor_screen/ads_detail_screen.dart';



class AdsModel extends StatefulWidget {
  final dynamic ads;
  const AdsModel({
    Key? key,
    required this.ads,
  }) : super(key: key);

  @override
  State<AdsModel> createState() => _AdsModelState();
}

class _AdsModelState extends State<AdsModel> {
  @override
  Widget build(BuildContext context) {

    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => AdsDetailsScreen(
                  adsList: widget.ads,
                )));
      },
      child: Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15),
                    ),
                    image: DecorationImage(
                        image: NetworkImage(widget.ads['proimages'][0]),
                        // fit: BoxFit.cover,
                        fit: BoxFit.fill)),
              ),
            ),
            Text(
              widget.ads['name'],
              style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
            ),
            Text(
              '${widget.ads['price'].toStringAsFixed(0)} сом',
              style: const TextStyle(
                  color: Colors.red, fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(
              widget.ads['create'].toString(),
              style: const TextStyle(fontSize: 12),
            ),
            const SizedBox(
              height: 10,
            ),

          ],
        ),
      ),
    );
  }
}
