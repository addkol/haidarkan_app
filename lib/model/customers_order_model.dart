import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CustomerOrderModel extends StatelessWidget {
  final dynamic order;

  const CustomerOrderModel({Key? key, required this.order}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(

        decoration: BoxDecoration(
            border: Border.all(color: Colors.white),
            borderRadius: BorderRadius.circular(15)),
        child: ExpansionTile(
          title: Container(

            constraints: const BoxConstraints(maxHeight: 80),
            width: double.infinity,
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 15),
                  child: Container(
                    constraints:
                    const BoxConstraints(maxHeight: 80, maxWidth: 80),
                    child: Image.network(order['orderimage']),
                  ),
                ),
                Flexible(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          order['ordername'],
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style:const TextStyle(
                              fontSize: 12,
                              color: Colors.black,
                              fontWeight: FontWeight.w600),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text((order['orderprice'].toStringAsFixed(2))+ ' сом'),
                              Text(('x ') + (order['orderqty'].toString())),
                            ],
                          ),
                        )
                      ],
                    ))
              ],
            ),
          ),
          subtitle: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('больше ...'),
              Text(order['deliverystatus']),
            ],
          ),
          children: [
            Container(
              // height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                  color: order['deliverystatus'] == 'delivered'
                      ? Colors.brown.withOpacity(0.2)
                      : Colors.yellow.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(15)),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(('Имя: ') + (order['custname']),
                        style: const TextStyle(fontSize: 15)),
                    Text(('Номер тел: ') + (order['phone'].toString()),
                        style: const TextStyle(fontSize: 15)),
                    Row(
                      children: [
                        const Text(('Статус оплаты: '),
                            style: TextStyle(fontSize: 15)),
                        Text((order['paymentstatus']),
                            style: const TextStyle(
                                fontSize: 15, color: Colors.purpleAccent)),
                      ],
                    ),
                    Row(
                      children: [
                        const Text(('Статус доставки: '),
                            style: TextStyle(fontSize: 15)),
                        Text((order['deliverystatus']),
                            style: const TextStyle(
                                fontSize: 15, color: Colors.green)),
                      ],
                    ),
                    order['deliverystatus'] == 'перевозка'
                        ? Text(
                        ('День доставки: ') +
                            (DateFormat('dd-MM-yyyy')
                                .format(order['deliverydate'].toDate()))
                                .toString(),
                        style: const TextStyle(fontSize: 15, color: Colors.blueAccent))
                        : const Text(''),
                    order['deliverystatus'] == 'доставлен' &&
                        order['orederreview'] == false
                        ? TextButton(
                        onPressed: () {},
                        child: const Text('Написать отзыв'))
                        : const Text(''),
                    order['deliverystatus'] == 'доставлен' &&
                        order['orederreview'] == true
                        ? Row(
                      children: const [
                        Icon(Icons.check, color: Colors.blue),
                        Text(
                          'Отзыв добавлен',
                          style: TextStyle(
                              color: Colors.blue,
                              fontStyle: FontStyle.italic),
                        ),
                      ],
                    )
                        : const Text(''),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
