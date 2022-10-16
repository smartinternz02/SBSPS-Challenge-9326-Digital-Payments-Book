import 'package:flutter/material.dart';

class CustomerBills extends StatelessWidget {
  const CustomerBills(
      {Key? key, required this.customerName, required this.customerBillDetails})
      : super(key: key);
  final String customerName;
  final List<dynamic> customerBillDetails;
  @override
  Widget build(BuildContext context) {
    List<DataRow> rowList = [];
    for (int i = 0; i < customerBillDetails.length; i++) {
      rowList.add(
        DataRow(
          cells: [
            DataCell(
              Text(
                customerBillDetails[i]['BILL_ID'].toString(),
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
            DataCell(
              Text(
                customerBillDetails[i]['BILLAMT'].toString(),
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
            DataCell(
              Text(
                customerBillDetails[i]['ISSUE_DATE']
                        .toString()
                        .substring(5, 17) +
                    '\n' +
                    customerBillDetails[i]['ISSUE_DATE']
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
      appBar: AppBar(title: Text(customerName + '\'s Bills')),
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: rowList.isEmpty
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 120),
                    child: Text(
                      "No Bills !!!",
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
                'ISSUE DATE',
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
