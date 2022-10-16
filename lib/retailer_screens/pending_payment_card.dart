import 'package:flutter/material.dart';
import 'package:kanakku_book/retailer_screens/retailer_customer_due.dart';

class PendingPaymentCard extends StatelessWidget {
  PendingPaymentCard(this.pendingPayments, {Key? key}) : super(key: key);

  List<dynamic> pendingPayments;

  @override
  Widget build(BuildContext context) {
    List<Widget> cardList = [];
    for (int i = 0; i < pendingPayments.length; i++) {
      String customerName = pendingPayments[i]['CUST_NAME'];
      var customerNameBuffer = StringBuffer();
      customerNameBuffer.write(customerName[0].toUpperCase());
      for (int j = 1; j < customerName.length; j++) {
        customerNameBuffer.write(customerName[j].toLowerCase());
      }
      cardList.add(
        GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: ((context) => CustomerDue(
                        customerID: pendingPayments[i]['CUST_ID'],
                        customerName: customerNameBuffer.toString(),
                        dues: pendingPayments[i]['DUES'],
                        phoneNo: pendingPayments[i]['PHONE_NUMBER']))));
          },
          child: Card(
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
                      pendingPayments[i]['KPOINTS'].toString(),
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
                    child: Text(
                      '₹' + pendingPayments[i]['DUES'].toString(),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }
    ;
    return Column(
      children: cardList,
    );
  }
}
