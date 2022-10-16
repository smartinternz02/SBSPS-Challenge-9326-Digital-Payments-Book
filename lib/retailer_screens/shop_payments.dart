import 'package:flutter/material.dart';

class CustomerPaymentsToShop extends StatelessWidget {
  const CustomerPaymentsToShop(
      {Key? key, required this.customerName, required this.customerPayments})
      : super(key: key);
  final String customerName;
  final List<dynamic> customerPayments;
  @override
  Widget build(BuildContext context) {
    List<DataRow> rowList = [];
    for (int i = 0; i < customerPayments.length; i++) {
      rowList.add(
        DataRow(
          cells: [
            DataCell(
              Text(
                customerPayments[i]['BILL_ID'].toString(),
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
            DataCell(
              Text(
                customerPayments[i]['BILLAMT'].toString(),
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
            DataCell(
              Text(
                customerPayments[i]['PAID_DATE'].toString().substring(5, 17) +
                    '\n' +
                    customerPayments[i]['PAID_DATE']
                        .toString()
                        .substring(17, 22),
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(customerName + '\'s paid details')),
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: rowList.isEmpty
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 120),
                    child: Text(
                      "No Payments !!!",
                      style: TextStyle(
                          fontSize: 22, fontFamily: 'OpenSans-SemiBold'),
                    ),
                  ),
                ],
              )
            :DataTable(
          columns: const [
            DataColumn(
              label: Text(
                'BILL ID',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
            DataColumn(
              label: Text(
                'AMOUNT',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
            DataColumn(
              label: Text(
                'PAID DATE',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
          ],
          rows: rowList,
        ),
      ),
    );
  }
}
