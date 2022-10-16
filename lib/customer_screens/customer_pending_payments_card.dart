import 'package:flutter/material.dart';
import 'package:kanakku_book/customer_screens/mydues_customer_details.dart';

class CustomerPendingPaymentCard extends StatelessWidget {
  CustomerPendingPaymentCard(this.customerPendingPayments, {Key? key})
      : super(key: key);

  List<dynamic> customerPendingPayments;

  @override
  Widget build(BuildContext context) {
    List<Widget> cardList = [];
    for (int i = 0; i < customerPendingPayments.length; i++) {
      cardList.add(
        GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => MyDuesCustomerDetails(
                          dues: customerPendingPayments[i]['DUES'],
                          shopID: customerPendingPayments[i]['SHOP_ID'],
                          shopName: customerPendingPayments[i]['SHOPNAME'],
                        )));
          },
          child: Card(
            elevation: 5.0,
            margin: const EdgeInsets.all(10),
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: ListTile(
                title: Text(
                  customerPendingPayments[i]['SHOPNAME'],
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
                      '₹' + customerPendingPayments[i]['DUES'].toString(),
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
        ),
      );
    }
    return Column(
      children: cardList,
    );
  }
}
