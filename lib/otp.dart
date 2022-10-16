import 'package:flutter/material.dart';
import 'package:kanakku_book/customer_screens/mypurchase.dart';
import 'package:kanakku_book/http_requests.dart';
import 'package:kanakku_book/login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Otp extends StatefulWidget {
  Otp({
    Key? key,
    required this.mobileNo,
  }) : super(key: key);

  final String mobileNo;
  @override
  State<Otp> createState() => _OtpState();
}

class _OtpState extends State<Otp> {
  final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();
  String? _verificationCode;
  final TextEditingController otp = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            const SizedBox(
              height: 120,
            ),
            const Text(
              'OTP',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.w500),
            ),
            const SizedBox(
              height: 50,
            ),
            SizedBox(
              width: 280,
              height: 50,
              child: TextField(
                controller: otp,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      borderSide: BorderSide.none,
                    ),
                    hintText: 'Enter OTP',
                    hintStyle: const TextStyle(
                        fontSize: 20,
                        color: Color.fromARGB(255, 104, 104, 106)),
                    filled: true,
                    fillColor: const Color.fromARGB(80, 217, 217, 217)),
              ),
            ),
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 60),
                child: TextButton(
                  onPressed: () {},
                  child: const Text(
                    'resend otp',
                    style: TextStyle(color: Color.fromARGB(255, 95, 93, 93)),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              width: 280,
              height: 50,
              child: ElevatedButton(
                onPressed: () async {
                  final int? status =
                      await HTTPRequests().sendOtp(widget.mobileNo);
                  if (status == null) {
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
                    final logindata = await SharedPreferences.getInstance();
                    await logindata.setInt('ID', status);
                    await logindata.setBool('isCustomer', true);

                    try {
                      await FirebaseAuth.instance
                          .signInWithCredential(PhoneAuthProvider.credential(
                              verificationId: _verificationCode!,
                              smsCode: otp.text))
                          .then((value) async {
                        if (value.user != null) {
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MyPurchase()),
                              (route) => false);
                        }
                      });
                    } catch (e) {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(content: Text(e.toString())));
                    }
                  }
                },
                child: const Text(
                  'SUBMIT',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        side: const BorderSide(color: Colors.purple)),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            SizedBox(
              width: 280,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Login(),
                    ),
                  );
                },
                child: const Text(
                  'CANCEL',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.purple,
                  ),
                ),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                      const Color.fromARGB(80, 210, 204, 204)),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        side: BorderSide.none),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _verifyPhone() async {
    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: '+91${widget.mobileNo}',
        verificationCompleted: (PhoneAuthCredential credential) async {
          await FirebaseAuth.instance
              .signInWithCredential(credential)
              .then((value) async {
            if (value.user != null) {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => MyPurchase()),
                  (route) => false);
            }
          });
        },
        verificationFailed: (FirebaseAuthException e) {
          print(e.message);
        },
        codeSent: (String? verficationID, int? resendToken) {
          setState(() {
            _verificationCode = verficationID;
          });
        },
        codeAutoRetrievalTimeout: (String verificationID) {
          setState(() {
            _verificationCode = verificationID;
          });
        },
        timeout: const Duration(seconds: 120));
  }

  @override
  void initState() {
    super.initState();
    _verifyPhone();
  }
}
