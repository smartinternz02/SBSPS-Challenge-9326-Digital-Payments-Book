import 'package:flutter/material.dart';

class ViewShopCard extends StatelessWidget {
  const ViewShopCard({Key? key, required this.customerShops}) : super(key: key);
  final List<dynamic> customerShops;
  @override
  Widget build(BuildContext context) {
    List<Widget> cardList = [];
    for (int i = 0; i < customerShops.length; i++) {
      cardList.add(
        Card(
          elevation: 5.0,
          margin: const EdgeInsets.all(10),
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: ListTile(
              title: Text(
                customerShops[i]['SHOPNAME'],
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 23,
                ),
              ),
              trailing: Container(
                width: 100,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text(
                    '₹' + customerShops[i]['DUES'].toString(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  color: Colors.purple,
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
            ),
          ),
        ),
      );
    }
    return Column(
      children: cardList,
    );
  }
}
