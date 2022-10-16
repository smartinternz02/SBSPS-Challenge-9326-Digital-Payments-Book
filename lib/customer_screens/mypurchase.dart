import 'package:flutter/material.dart';
import 'package:kanakku_book/customer_screens/customer_nav_drawer.dart';
import 'package:kanakku_book/customer_screens/customer_pending_payments_card.dart';
import 'package:kanakku_book/http_requests.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyPurchase extends StatefulWidget {
  const MyPurchase({Key? key}) : super(key: key);

  @override
  State<MyPurchase> createState() => _MyPurchaseState();
}

late List<dynamic> customerPendingPayments = [];
late SharedPreferences logindata;
late int? id;
Future<List<dynamic>> fetchCustomerPendingPayments() async {
  logindata = await SharedPreferences.getInstance();
  id = logindata.getInt('ID');
  return await HTTPRequests().myDues(id.toString());
}

class _MyPurchaseState extends State<MyPurchase> {
  @override
  void initState() {
    super.initState();
    fetchCustomerPendingPayments().then((value) {
      setState(() {
        customerPendingPayments = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'OpenSans',
        colorScheme: ColorScheme.fromSeed(
          seedColor: Color.fromRGBO(136, 48, 143, 100),
        ).copyWith(
          secondary: Color.fromRGBO(136, 48, 143, 100),
        ),
        textTheme: const TextTheme(bodyText2: TextStyle(color: Colors.black)),
      ),
      home: Scaffold(
        appBar: AppBar(
          leading: Builder(
            builder: (BuildContext context) {
              return GestureDetector(
                child: const Icon(Icons.menu_outlined, size: 35),
                onTap: () => Scaffold.of(context).openDrawer(),
              );
            },
          ),
          centerTitle: true,
          title: const Text(
            'MY PURCHASE',
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
          toolbarHeight: 70,
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.notifications_outlined,
                size: 35,
              ),
            ),
          ],
        ),
        drawer: const CustomerNavigationDrawer(),
        body: SingleChildScrollView(
          child: (Column(children: [
            const SizedBox(
              height: 15,
            ),
            const Divider(
              height: 20,
              thickness: 1.5,
              indent: 20,
              endIndent: 20,
              color: Colors.black,
            ),
            const Text(
              'PENDING PAYMENTS',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            const Divider(
              height: 20,
              thickness: 1.5,
              indent: 20,
              endIndent: 20,
              color: Colors.black,
            ),
            const SizedBox(
              height: 15,
            ),
            customerPendingPayments.isEmpty
                ? const Padding(
                    padding: EdgeInsets.only(top: 200),
                    child: Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 4,
                      ),
                    ),
                  )
                : SingleChildScrollView(
                    child: Column(children: [
                      CustomerPendingPaymentCard(customerPendingPayments),
                    ]),
                  ),
          ])),
        ),
      ),
    );
  }
}
