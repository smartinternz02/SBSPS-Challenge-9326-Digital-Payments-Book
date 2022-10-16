import 'package:flutter/material.dart';
import 'package:kanakku_book/http_requests.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomerViewAllBills extends StatefulWidget {
  const CustomerViewAllBills({Key? key}) : super(key: key);

  @override
  State<CustomerViewAllBills> createState() => _CustomerViewAllBillsState();
}

late SharedPreferences logindata;
late int? id;
late List<dynamic> customerViewAllBills = [];
Future<List<dynamic>> fetchData() async {
  logindata = await SharedPreferences.getInstance();
  id = logindata.getInt('ID');
  print('fun call');
  return await HTTPRequests().customerViewAllBills(id.toString());
}

class _CustomerViewAllBillsState extends State<CustomerViewAllBills> {
  @override
  void initState() {
    super.initState();
    fetchData().then((value) {
      setState(() {
        customerViewAllBills = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    print('in build: $customerViewAllBills');
    final textScale = MediaQuery.of(context).textScaleFactor;
    List<DataRow> rowList = [];
    for (int i = 0; i < customerViewAllBills.length; i++) {
      rowList.add(
        DataRow(
          cells: [
            DataCell(
              Text(
                customerViewAllBills[i]['BILL_ID'].toString(),
                style: TextStyle(
                  fontSize: 20 * textScale,
                ),
              ),
            ),
            DataCell(
              Text(
                customerViewAllBills[i]['CUST_NAME'].toString(),
                style: TextStyle(
                  fontSize: 20 * textScale,
                ),
              ),
            ),
            DataCell(
              Text(
                customerViewAllBills[i]['BILLAMT'].toString(),
                style: TextStyle(
                  fontSize: 20 * textScale,
                ),
              ),
            ),
            DataCell(
              Text(
                customerViewAllBills[i]['ISSUE_DATE']
                        .toString()
                        .substring(5, 17) +
                    '\n' +
                    customerViewAllBills[i]['ISSUE_DATE']
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
                          fontSize: 26, fontFamily: 'OpenSans-SemiBold'),
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
