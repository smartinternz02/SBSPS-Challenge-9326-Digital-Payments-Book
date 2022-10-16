import 'package:flutter/material.dart';
import 'package:kanakku_book/http_requests.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomerViewAllPayments extends StatefulWidget {
  const CustomerViewAllPayments({Key? key}) : super(key: key);

  @override
  State<CustomerViewAllPayments> createState() =>
      _CustomerViewAllPaymentsState();
}

late SharedPreferences logindata;
late int? id;
late List<dynamic> customerViewAllPayments = [];
Future<List<dynamic>> fetchData() async {
  logindata = await SharedPreferences.getInstance();
  id = logindata.getInt('ID');
  return await HTTPRequests().customerViewAllPayments(id.toString());
}

class _CustomerViewAllPaymentsState extends State<CustomerViewAllPayments> {
  @override
  void initState() {
    super.initState();
    fetchData().then((value) {
      setState(() {
        customerViewAllPayments = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final textScale = MediaQuery.of(context).textScaleFactor;
    List<DataRow> rowList = [];
    for (int i = 0; i < customerViewAllPayments.length; i++) {
      rowList.add(
        DataRow(
          cells: [
            DataCell(
              Text(
                customerViewAllPayments[i]['BILL_ID'].toString(),
                style: TextStyle(
                  fontSize: 20 * textScale,
                ),
              ),
            ),
            DataCell(
              Text(
                customerViewAllPayments[i]['CUST_NAME'].toString(),
                style: TextStyle(
                  fontSize: 20 * textScale,
                ),
              ),
            ),
            DataCell(
              Text(
                customerViewAllPayments[i]['BILLAMT'].toString(),
                style: TextStyle(
                  fontSize: 20 * textScale,
                ),
              ),
            ),
            DataCell(
              Text(
                customerViewAllPayments[i]['PAID_DATE']
                        .toString()
                        .substring(5, 17) +
                    '\n' +
                    customerViewAllPayments[i]['PAID_DATE']
                        .toString()
                        .substring(17, 22),
                style: TextStyle(
                  fontSize: 20 * textScale,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
          title: Text(
        'View All Payments',
        style: TextStyle(fontFamily: 'OpenSans-SemiBold'),
      )),
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: rowList.isEmpty
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 120),
                    child: Text(
                      "No  Payments !!!",
                      style: TextStyle(
                          fontSize: 22, fontFamily: 'OpenSans-SemiBold'),
                    ),
                  ),
                ],
              )
            : DataTable(
                columns: [
                  DataColumn(
                    label: Text(
                      'BILL ID',
                      style: TextStyle(
                          fontSize: 22 * textScale,
                          fontFamily: 'OpenSans-SemiBold'),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'NAME',
                      style: TextStyle(
                          fontSize: 22 * textScale,
                          fontFamily: 'OpenSans-SemiBold'),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'AMOUNT',
                      style: TextStyle(
                          fontSize: 22 * textScale,
                          fontFamily: 'OpenSans-SemiBold'),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'PAID DATE',
                      style: TextStyle(
                          fontSize: 22 * textScale,
                          fontFamily: 'OpenSans-SemiBold'),
                    ),
                  ),
                ],
                rows: rowList,
              ),
      ),
    );
  }
}
