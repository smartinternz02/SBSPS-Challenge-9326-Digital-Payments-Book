import 'package:flutter/material.dart';
import 'package:kanakku_book/customer_screens/mydues_customer_bills.dart';
import 'package:kanakku_book/customer_screens/mydues_customer_payments.dart';
import 'package:kanakku_book/http_requests.dart';
import 'package:kanakku_book/customer_screens/razor_payment.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyDuesCustomerDetails extends StatefulWidget {
  const MyDuesCustomerDetails(
      {Key? key,
      required this.shopID,
      required this.shopName,
      required this.dues})
      : super(key: key);
  final int shopID;
  final String shopName;
  final double dues;
  @override
  State<MyDuesCustomerDetails> createState() => _MyDuesCustomerDetailsState();
}

late SharedPreferences logindata;
late int? customerID;

class _MyDuesCustomerDetailsState extends State<MyDuesCustomerDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.shopName,
          style: TextStyle(fontSize: 26, fontFamily: "OpenSans-SemiBold"),
        ),
      ),
      body: Center(
        child: Column(
          children: [
            Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                child: CircleAvatar(
                  radius: 85,
                  backgroundImage: AssetImage(
                    'assets/images/shop.jpg',
                  ),
                )),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      'Shop ID : ',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    const Text(
                      'Due Amount : ',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      widget.shopID.toString(),
                      style: const TextStyle(
                        fontSize: 22,
                      ),
                    ),
                    const SizedBox(
                      height: 40,
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
                        color: Colors.purple,
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                  ],
                )
              ],
            ),
            const SizedBox(
              height: 40,
            ),
            Container(
              height: 50,
              margin: EdgeInsets.only(left: 40, right: 40),
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  logindata = await SharedPreferences.getInstance();
                  customerID = logindata.getInt('ID');
                  final List<dynamic>? receiveBills = await HTTPRequests()
                      .myDuesReceiveBills(customerID!, widget.shopID);
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
                            builder: (context) => MyDuesCustomerBills(
                                shopName: widget.shopName,
                                customerBillDetails: receiveBills)));
                  }
                },
                child: const Text(
                  'BILL HISTORY',
                  style: TextStyle(
                      fontSize: 20,
                      color: Color.fromRGBO(136, 48, 143, 100),
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
                  customerID = logindata.getInt('ID');
                  final List<dynamic>? receivePayments = await HTTPRequests()
                      .receivePayments(customerID!, widget.shopID);

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
                            builder: (context) => MyDuesCustomerPayments(
                                shopName: widget.shopName,
                                customerPayments: receivePayments)));
                  }
                },
                child: const Text(
                  'PAYMENT HISTORY',
                  style: TextStyle(
                      fontSize: 20,
                      color: Color.fromRGBO(136, 48, 143, 100),
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
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => RazorPayment(
                              shopID: widget.shopID,
                              shopName: widget.shopName,
                              amount: widget.dues)));
                },
                child: const Text(
                  'PAY',
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
