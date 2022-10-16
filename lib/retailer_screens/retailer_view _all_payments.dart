import 'package:flutter/material.dart';
import 'package:kanakku_book/http_requests.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RetailerViewAllPayments extends StatefulWidget {
  const RetailerViewAllPayments({Key? key}) : super(key: key);

  @override
  State<RetailerViewAllPayments> createState() =>
      _RetailerViewAllPaymentsState();
}

late SharedPreferences logindata;
late int? id;
late List<dynamic> retailerViewAllPayments = [];
Future<List<dynamic>> fetchData() async {
  logindata = await SharedPreferences.getInstance();
  id = logindata.getInt('ID');
  return await HTTPRequests().retailerViewAllPayments(id.toString());
}

class _RetailerViewAllPaymentsState extends State<RetailerViewAllPayments> {
  @override
  void initState() {
    super.initState();
    fetchData().then((value) {
      setState(() {
        retailerViewAllPayments = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final textScale = MediaQuery.of(context).textScaleFactor;
    List<DataRow> rowList = [];
    for (int i = 0; i < retailerViewAllPayments.length; i++) {
      rowList.add(
        DataRow(
          cells: [
            DataCell(
              Text(
                retailerViewAllPayments[i]['BILL_ID'].toString(),
                style: TextStyle(
                  fontSize: 20 * textScale,
                ),
              ),
            ),
            DataCell(
              Text(
                retailerViewAllPayments[i]['CUST_NAME'].toString(),
                style: TextStyle(
                  fontSize: 20 * textScale,
                ),
              ),
            ),
            DataCell(
              Text(
                retailerViewAllPayments[i]['BILLAMT'].toString(),
                style: TextStyle(
                  fontSize: 20 * textScale,
                ),
              ),
            ),
            DataCell(
              Text(
                retailerViewAllPayments[i]['PAID_DATE']
                        .toString()
                        .substring(5, 17) +
                    '\n' +
                    retailerViewAllPayments[i]['PAID_DATE']
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
                    margin: EdgeInsets.only(left: 150),
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
