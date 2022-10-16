import 'package:flutter/material.dart';
import 'package:flutter_sms/flutter_sms.dart';
import 'package:kanakku_book/http_requests.dart';
import 'package:kanakku_book/retailer_screens/shop_bills.dart';
import 'package:kanakku_book/retailer_screens/shop_payments.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomerDue extends StatefulWidget {
  const CustomerDue(
      {Key? key,
      required this.customerID,
      required this.customerName,
      required this.dues,
      required this.phoneNo})
      : super(key: key);
  final int customerID;
  final String customerName;
  final double dues;
  final String phoneNo;
  @override
  State<CustomerDue> createState() => _CustomerDueState();
}

late SharedPreferences logindata;
late int? shopID;

Future<void> _sendSMS(List<String> recipient, String amount) async {
  String _result = await sendSMS(
    message: 'Dear Customer,\n\n    You have an existing\ndue of ₹ $amount.',
    recipients: recipient,
  );
}

class _CustomerDueState extends State<CustomerDue> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.customerName,
          style: TextStyle(fontFamily: "OpenSans-SemiBold", fontSize: 25),
        ),
      ),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              child: CircleAvatar(
                radius: 85,
                backgroundImage: AssetImage(
                  'assets/images/profile.png',
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    //SizedBox(height: 23),
                    const Text(
                      'Customer ID : ',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(
                      height: 32,
                    ),
                    const Text(
                      'Due Amount : ',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                  ],
                ),
                Column(
                  children: [
                    const SizedBox(
                      height: 29,
                    ),
                    Text(
                      widget.customerID.toString(),
                      style: const TextStyle(
                        fontSize: 22,
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Container(
                      width: 100,
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Text(
                          '₹' + widget.dues.toString(),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        color: Color.fromRGBO(53, 143, 48, 100),
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    const SizedBox(
                      height: 65,
                    ),
                  ],
                )
              ],
            ),
            Container(
              height: 50,
              margin: EdgeInsets.only(left: 40, right: 40),
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  logindata = await SharedPreferences.getInstance();
                  shopID = logindata.getInt('ID');
                  final List<dynamic>? receiveBills = await HTTPRequests()
                      .receiveBills(widget.customerID, shopID!);

                  if (receiveBills == null) {
                    showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                              title: const Text("Issue"),
                              content: const Text("Network Error"),
                              actions: [
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
                            builder: (context) => CustomerBills(
                                customerName: widget.customerName,
                                customerBillDetails: receiveBills)));
                  }
                },
                child: const Text(
                  ' BILL HISTORY',
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.green,
                      fontFamily: "OpenSans-SemiBold"),
                ),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                      Color.fromARGB(255, 194, 187, 187)),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 29,
            ),
            Container(
              height: 50,
              margin: EdgeInsets.only(left: 40, right: 40),
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  logindata = await SharedPreferences.getInstance();
                  shopID = logindata.getInt('ID');
                  final List<dynamic>? receivePayments = await HTTPRequests()
                      .receivePayments(widget.customerID, shopID!);

                  if (receivePayments == null) {
                    showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                              title: const Text("Issue"),
                              content: const Text("Network Error"),
                              actions: [
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
                            builder: (context) => CustomerPaymentsToShop(
                                customerName: widget.customerName,
                                customerPayments: receivePayments)));
                  }
                },
                child: const Text(
                  ' PAYMENT HISTORY',
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.green,
                      fontFamily: "OpenSans-SemiBold"),
                ),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                      Color.fromARGB(255, 194, 187, 187)),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 29,
            ),
            Container(
              height: 50,
              margin: EdgeInsets.only(left: 40, right: 40),
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  _sendSMS([widget.phoneNo], widget.dues.toString());
                },
                child: const Text(
                  'SMS',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
