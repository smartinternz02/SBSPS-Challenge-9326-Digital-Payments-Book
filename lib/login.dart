import 'package:flutter/material.dart';
import 'package:kanakku_book/customer_screens/mypurchase.dart';
import 'package:kanakku_book/http_requests.dart';
import 'package:kanakku_book/otp.dart';
import 'package:kanakku_book/retailer_screens/myshop.dart';
import 'package:kanakku_book/signin.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  Login({
    Key? key,
  }) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController mobileNoController = TextEditingController();
  late SharedPreferences logindata;
  late int? id;
  late bool? isCustomer;
  late String? shopName;
  @override
  void initState() {
    super.initState();
    checkIfAlreadyLogin();
  }

  void checkIfAlreadyLogin() async {
    logindata = await SharedPreferences.getInstance();
    id = logindata.getInt('ID');
    shopName = logindata.getString('shopName');
    isCustomer = logindata.getBool('isCustomer');
    if (isCustomer == true && id != null) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const MyPurchase()));
    } else if (isCustomer == false && id != null) {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => MyShop(shopName: shopName!)));
    }
  }

  @override
  void dispose() {
    mobileNoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "LOGIN TO YOUR ACCOUNT",
                style: TextStyle(fontSize: 22),
              ),
              const SizedBox(
                height: 42,
              ),
              SizedBox(
                width: 200,
                height: 70,
                child: Center(
                  child: TextField(
                    controller: mobileNoController,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    maxLength: 10,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          borderSide: BorderSide.none,
                        ),
                        hintText: 'MOBILE NO',
                        filled: true,
                        fillColor: const Color.fromARGB(80, 217, 217, 217)),
                  ),
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              SizedBox(
                width: 200,
                height: 40,
                child: ElevatedButton(
                  onPressed: () async {
                    final bool? status = await HTTPRequests()
                        .sendMobileNo(mobileNoController.text);
                    if (status == null) {
                      const Text('network error');
                    } else if (status == false) {
                      showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                                title: const Text("Issue"),
                                content: const Text("No data found "),
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
                            builder: (context) => Otp(
                                  mobileNo: mobileNoController.text,
                                )),
                      );
                    }
                  },
                  child: const Text('SUBMIT'),
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.purple),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                            side: const BorderSide(
                                color: Color.fromRGBO(136, 48, 143, 100))),
                      )),
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              const Text('or'),
              TextButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: ((context) => const SignIn())));
                },
                child: const Text(
                  'Register',
                  style: TextStyle(fontSize: 15, color: Colors.purple),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
