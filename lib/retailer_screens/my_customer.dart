import 'package:flutter/material.dart';
import 'package:kanakku_book/customer_screens/view_customers_card.dart';
import 'package:kanakku_book/http_requests.dart';

import 'package:shared_preferences/shared_preferences.dart';

class MyCustomers extends StatefulWidget {
  final String customerID;
  const MyCustomers({Key? key, required this.customerID}) : super(key: key);

  @override
  State<MyCustomers> createState() => _MyCustomersState();
}

late List<dynamic> myCustomers = [];
late SharedPreferences logindata;
late int? id;
Future<List<dynamic>> fetchCustomerData() async {
  logindata = await SharedPreferences.getInstance();
  id = logindata.getInt('ID');
  return HTTPRequests().viewCustomers(id.toString());
}

class _MyCustomersState extends State<MyCustomers> {
  @override
  void initState() {
    super.initState();
    fetchCustomerData().then((value) {
      setState(() {
        myCustomers = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    List<dynamic> singleCustomer = [];
    if (widget.customerID != "all" && widget.customerID != "") {
      for (int i = 0; i < myCustomers.length; i++) {
        if (myCustomers[i]['CUST_ID'] == int.parse(widget.customerID)) {
          singleCustomer.add(myCustomers[i]);

          break;
        }
      }
    }

    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'My Customers',
            style: TextStyle(fontFamily: 'OpenSans-SemiBold'),
          ),
        ),
        body: widget.customerID == "all"
            ? SingleChildScrollView(
                child: ViewCustomersCard(
                myCustomers: myCustomers,
              ))
            : singleCustomer.isEmpty
                ? const Center(
                    child: Text('Please Enter Valid ID !!!',
                        style: TextStyle(
                          fontSize: 20,
                        )))
                : ViewCustomersCard(myCustomers: singleCustomer));
  }
}
