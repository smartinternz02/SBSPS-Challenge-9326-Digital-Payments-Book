import 'package:flutter/material.dart';

class ViewCustomersCard extends StatelessWidget {
  const ViewCustomersCard({Key? key, required this.myCustomers})
      : super(key: key);
  final List<dynamic> myCustomers;
  @override
  Widget build(BuildContext context) {
    List<Widget> cardList = [];
    for (int i = 0; i < myCustomers.length; i++) {
      String customerName = myCustomers[i]['CUST_NAME'];
      var customerNameBuffer = StringBuffer();
      customerNameBuffer.write(customerName[0].toUpperCase());
      for (int j = 1; j < customerName.length; j++) {
        customerNameBuffer.write(customerName[j].toLowerCase());
      }
      cardList.add(
        Card(
          elevation: 5.0,
          margin: const EdgeInsets.all(10),
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: ListTile(
              title: Text(
                customerNameBuffer.toString(),
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 23,
                ),
              ),
              subtitle: Row(
                children: [
                  const Icon(
                    Icons.offline_bolt_outlined,
                    color: Colors.green,
                  ),
                  Text(
                    myCustomers[i]["KPOINTS"].toString(),
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.grey,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
              trailing: Container(
                width: 100,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      '₹' + myCustomers[i]['DUES'].toString(),
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  color: Color.fromRGBO(53, 143, 48, 100),
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
