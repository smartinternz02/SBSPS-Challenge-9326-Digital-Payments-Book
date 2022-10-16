import 'package:flutter/material.dart';
import 'package:kanakku_book/http_requests.dart';
import 'package:kanakku_book/customer_screens/view_shop_card.dart';

import 'package:shared_preferences/shared_preferences.dart';

class CustomerViewShops extends StatefulWidget {
  const CustomerViewShops({Key? key}) : super(key: key);

  @override
  State<CustomerViewShops> createState() => _CustomerViewShopsState();
}

late List<dynamic> customerShops = [];
late SharedPreferences logindata;
late int? id;
Future<List<dynamic>> fetchCustomerShopsData() async {
  logindata = await SharedPreferences.getInstance();
  id = logindata.getInt('ID');
  return await HTTPRequests().viewShops(id.toString());
}

class _CustomerViewShopsState extends State<CustomerViewShops> {
  @override
  void initState() {
    super.initState();
    fetchCustomerShopsData().then((value) {
      setState(() {
        customerShops = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Shops',
          style: TextStyle(fontFamily: 'OpenSans-SemiBold'),
        ),
      ),
      body: customerShops.isEmpty
          ? const Padding(
              padding: EdgeInsets.only(top: 100),
              child: Center(
                child: CircularProgressIndicator(
                  strokeWidth: 8,
                ),
              ),
            )
          : SingleChildScrollView(
              child: ViewShopCard(customerShops: customerShops),
            ),
    );
  }
}
