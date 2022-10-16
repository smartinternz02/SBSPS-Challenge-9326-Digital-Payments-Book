import 'package:flutter/material.dart';
import 'package:kanakku_book/customer_screens/mypurchase.dart';
import 'package:kanakku_book/http_requests.dart';

import 'package:razorpay_flutter/razorpay_flutter.dart';

import 'package:shared_preferences/shared_preferences.dart';

class RazorPayment extends StatefulWidget {
  const RazorPayment(
      {Key? key,
      required this.shopName,
      required this.amount,
      required this.shopID})
      : super(key: key);
  final String shopName;
  final double amount;
  final int shopID;

  @override
  _RazorPaymentState createState() => _RazorPaymentState();
}

class _RazorPaymentState extends State<RazorPayment> {
  // static const platform =  MethodChannel("razorpay_flutter");

  late Razorpay _razorpay;
  TextEditingController amount = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Custom Payment',
          style: TextStyle(fontFamily: 'OpenSans-SemiBold'),
        ),
      ),
      body: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Text(
          widget.shopName,
          style: const TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w400,
          ),
        ),
        Padding(
          padding:
              const EdgeInsets.only(left: 20, right: 20, top: 60, bottom: 60),
          child: Row(
            children: [
              const Text(
                'Enter Amount  : ',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(
                height: 40,
                width: 150,
                child: TextField(
                  controller: amount,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                      hintText: widget.amount.toString(),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: const Color.fromARGB(80, 217, 217, 217)),
                ),
              ),
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.only(left: 30,right: 30),
          height: 50,
          width: double.infinity,
          child: ElevatedButton(
            onPressed: openCheckout,
            child: const Text(
              'PAY',
              style: TextStyle(fontFamily: 'OpenSans-SemiBold', fontSize: 20),
            ),
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.purple),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                    side: const BorderSide(color: Colors.purple)),
              ),
            ),
          ),
        )
      ])),
    );
  }

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  void openCheckout() async {
    var options = {
      'key': 'rzp_test_N8MqS7Rb389eml',
      'amount': int.parse(amount.text) * 100,
      'name': widget.shopName,
      'description': 'pay due',
      'retry': {'enabled': true, 'max_count': 1},
      'send_sms_hash': true,
      'prefill': {'contact': '9345827839'},
      // 'external': {
      //   'wallets': ['paytm']
      // }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint('Error: e');
    }
  }

  Future<void> sendPaymentDetails() async {
    logindata = await SharedPreferences.getInstance();
    id = logindata.getInt('ID');
    var sendPaymentDetails =
        HTTPRequests().sendPaymentDetails(id!, widget.shopID, amount.text);
  }

  Future<void> _dialogBuilder(
      BuildContext context, PaymentSuccessResponse response) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Payment Status'),
          content: Text(
            'Success',
            style: TextStyle(color: Colors.green, fontSize: 23),
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('CLOSE'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    print('Success Response: $response');
    _dialogBuilder(context, response);
    sendPaymentDetails();

    Navigator.push(
        context, MaterialPageRoute(builder: ((context) => const MyPurchase())));
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    print('Error Response: $response');
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    print('External SDK Response: $response');
  }
}
