import 'package:flutter/material.dart';
import 'package:kanakku_book/http_requests.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RetailerViewAllBills extends StatefulWidget {
  const RetailerViewAllBills({Key? key}) : super(key: key);

  @override
  State<RetailerViewAllBills> createState() => _RetailerViewAllBillsState();
}

late SharedPreferences logindata;
late int? id;
late List<dynamic> retailerViewAllBills = [];
Future<List<dynamic>> fetchData() async {
  logindata = await SharedPreferences.getInstance();
  id = logindata.getInt('ID');
  return await HTTPRequests().retailerViewAllBills(id.toString());
}

class _RetailerViewAllBillsState extends State<RetailerViewAllBills> {
  @override
  void initState() {
    super.initState();
    fetchData().then((value) {
      setState(() {
        retailerViewAllBills = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final textScale = MediaQuery.of(context).textScaleFactor;
    List<DataRow> rowList = [];
    for (int i = 0; i < retailerViewAllBills.length; i++) {
      rowList.add(
        DataRow(
          cells: [
            DataCell(
              Text(
                retailerViewAllBills[i]['BILL_ID'].toString(),
                style: TextStyle(
                  fontSize: 20 * textScale,
                ),
              ),
            ),
            DataCell(
              Text(
                retailerViewAllBills[i]['CUST_NAME'].toString(),
                style: TextStyle(
                  fontSize: 20 * textScale,
                ),
              ),
            ),
            DataCell(
              Text(
                retailerViewAllBills[i]['BILLAMT'].toString(),
                style: TextStyle(
                  fontSize: 20 * textScale,
                ),
              ),
            ),
            DataCell(
              Text(
                retailerViewAllBills[i]['ISSUE_DATE']
                        .toString()
                        .substring(5, 17) +
                    '\n' +
                    retailerViewAllBills[i]['ISSUE_DATE']
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
        'View All Bills',
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
                      "No Bills !!!",
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
                      'ISSUE DATE',
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
