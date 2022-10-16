import 'package:flutter/material.dart';
import 'package:kanakku_book/customer_screens/mypurchase.dart';
import 'package:kanakku_book/http_requests.dart';
import 'package:kanakku_book/login.dart';
import 'package:kanakku_book/retailer_screens/my_customer.dart';
import 'package:kanakku_book/retailer_screens/myaccount.dart';
import 'package:kanakku_book/retailer_screens/retailer_view%20_all_payments.dart';
import 'package:kanakku_book/retailer_screens/retailer_view_all_bills.dart';
import 'package:kanakku_book/retailer_screens/scanner.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NavigationDrawer extends StatefulWidget {
  const NavigationDrawer({Key? key}) : super(key: key);

  @override
  State<NavigationDrawer> createState() => _NavigationDrawerState();
}

class _NavigationDrawerState extends State<NavigationDrawer> {
  late SharedPreferences logindata;
  late int? id;
  bool isSwitched = false;
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            buildHeader(context),
            buildMenuItems(context),
          ],
        ),
      ),
    );
  }

  Widget buildHeader(BuildContext context) => Container(
        color: Color.fromRGBO(53, 143, 48, 100),
        padding: const EdgeInsets.only(
          //top: MediaQuery.of(context).padding.top,
          top: 30,
          bottom: 30,
        ),
        child: Column(
          children: const [
            CircleAvatar(
              radius: 70,
              backgroundImage: AssetImage(
                'assets/images/profile.png',
              ),
            )
          ],
        ),
      );

  Widget buildMenuItems(BuildContext context) => Container(
        padding: const EdgeInsets.all(24),
        child: Wrap(
          runSpacing: 20,
          children: [
            ListTile(
              title: const Text(
                'My Account',
                style: TextStyle(fontSize: 23),
              ),
              onTap: () async {
                logindata = await SharedPreferences.getInstance();
                id = logindata.getInt('ID');
                final Map? data = await HTTPRequests().sendRes(id.toString());
                if (data == null) {
                  showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                            title: const Text("Issue"),
                            content: const Text("Network Error"),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  Navigator.of(ctx).pop();
                                },
                                child: Container(
                                  //color: Colors.green,
                                  padding: const EdgeInsets.all(14),
                                  child: const Text("close"),
                                ),
                              ),
                            ],
                          ));
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Myaccount(
                              accountDetails: data,
                            )),
                  );
                }
              },
            ),
            ListTile(
              title: const Text(
                'View Customer',
                style: TextStyle(fontSize: 23),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          const MyCustomers(customerID: "all")),
                );
              },
            ),
            ListTile(
              title: const Text(
                'Add Customer',
                style: TextStyle(fontSize: 23),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Scanner()),
                );
              },
            ),
            ListTile(
              title: const Text(
                'View All Bills',
                style: TextStyle(fontSize: 23),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const RetailerViewAllBills()),
                );
              },
            ),
            ListTile(
              title: const Text(
                'View All Payments',
                style: TextStyle(fontSize: 23),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const RetailerViewAllPayments()),
                );
              },
            ),
            SwitchListTile(
              title: const Text(
                'Switch Role',
                style: TextStyle(fontSize: 27, color: Colors.green),
              ),
              value: isSwitched,
              onChanged: (bool value) {
                setState(() {
                  isSwitched = true;
                  changeUserType();
                });
                isSwitched
                    ? Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const MyPurchase()),
                      )
                    : Navigator.pop(context);
              },
            ),
            TextButton(
                onPressed: () async {
                  logindata = await SharedPreferences.getInstance();
                  logindata.clear();
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Login(),
                    ),
                  );
                },
                child: const Text(
                  'Sign Out',
                  style: TextStyle(
                      fontSize: 27, color: Color.fromRGBO(53, 143, 48, 100)),
                ))
          ],
        ),
      );

  void changeUserType() async {
    logindata = await SharedPreferences.getInstance();
    await logindata.setBool('isCustomer', true);
  }
}
