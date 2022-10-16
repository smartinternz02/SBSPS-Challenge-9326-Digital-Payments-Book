import 'package:flutter/material.dart';
import 'package:kanakku_book/customer_screens/customer_my_account.dart';
import 'package:kanakku_book/customer_screens/customer_view_all_bills.dart';
import 'package:kanakku_book/customer_screens/customer_view_all_payments.dart';
import 'package:kanakku_book/customer_screens/customer_view_shops.dart';
import 'package:kanakku_book/customer_screens/qr_code.dart';
import 'package:kanakku_book/http_requests.dart';
import 'package:kanakku_book/login.dart';
import 'package:kanakku_book/customer_screens/support.dart';
import 'package:kanakku_book/retailer_screens/myshop.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomerNavigationDrawer extends StatefulWidget {
  const CustomerNavigationDrawer({Key? key}) : super(key: key);

  @override
  State<CustomerNavigationDrawer> createState() =>
      _CustomerNavigationDrawerState();
}

late SharedPreferences logindata;
late int? id;
bool? isFirstSwitch = true;
TextEditingController shopName = TextEditingController();

class _CustomerNavigationDrawerState extends State<CustomerNavigationDrawer> {
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
        color: Colors.purple,
        padding: const EdgeInsets.only(
          top: 25,
          bottom: 25,
        ),
        child: Column(
          children: const [
            CircleAvatar(
              radius: 60,
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
                        builder: (context) => CustomerMyAccount(
                              accountDetails: data,
                            )),
                  );
                }
              },
            ),
            ListTile(
              title: const Text(
                'View Shops',
                style: TextStyle(fontSize: 23),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const CustomerViewShops()),
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
                      builder: (context) => const CustomerViewAllBills()),
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
                      builder: (context) => const CustomerViewAllPayments()),
                );
              },
            ),
            ListTile(
              title: const Text(
                'Support',
                style: TextStyle(fontSize: 23),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Support()),
                );
              },
            ),
            ListTile(
              title: const Text(
                'Join Shop',
                style: TextStyle(fontSize: 23),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const QRCode()),
                );
              },
            ),
            SwitchListTile(
              title: const Text(
                'Switch Role',
                style: TextStyle(
                    fontSize: 27, color: Color.fromARGB(255, 61, 3, 72)),
              ),
              value: isSwitched,
              onChanged: (bool value) async {
                logindata = await SharedPreferences.getInstance();
                id = logindata.getInt('ID');
                String? shopName =
                    await HTTPRequests().checkShopName(id.toString());

                setState(() {
                  isSwitched = true;
                  changeUserType();
                });
                isSwitched && shopName == null
                    ? shopNameDialog()
                    : {
                        await logindata.setString("shopName", shopName!),
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MyShop(shopName: shopName)),
                        )
                      };
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
                    fontSize: 27,
                    color: Color.fromRGBO(136, 48, 143, 100),
                  ),
                ))
          ],
        ),
      );

  void changeUserType() async {
    logindata = await SharedPreferences.getInstance();
    await logindata.setBool('isCustomer', false);
  }

  Future<void> sendStoreName() async {
    logindata = await SharedPreferences.getInstance();
    id = logindata.getInt('ID');

    HTTPRequests().sendShopName(id.toString(), shopName.text);
  }

  shopNameDialog() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text('Enter Your Shop Name'),
              content: Padding(
                padding: const EdgeInsets.only(left: 12),
                child: SizedBox(
                  height: 40,
                  width: 200,
                  child: TextField(
                    controller: shopName,
                    keyboardType: TextInputType.name,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: const Color.fromARGB(80, 217, 217, 217)),
                  ),
                ),
              ),
              actions: [
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      sendStoreName();
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  MyShop(shopName: shopName.text)));
                    },
                    child: const Text(
                      'Submit',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ),
              ],
              elevation: 40,
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(20),
                  ),
                  side: BorderSide(color: Colors.purple, width: 3)));
        });
  }
}
