import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kanakku_book/http_requests.dart';
import 'package:kanakku_book/login.dart';
import 'package:kanakku_book/siginin_otp.dart';
import 'package:flutter/gestures.dart';
import 'package:url_launcher/url_launcher.dart';

class SignIn extends StatefulWidget {
  const SignIn({
    Key? key,
  }) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

bool isDateSelected = true;
TextEditingController mobileNo = TextEditingController();
TextEditingController name = TextEditingController();
Uri termsAndConditions = Uri.parse(
    'https://www.termsfeed.com/live/7e338a11-bcce-430b-af17-3d439495a9c0');
Uri privacyPolicy = Uri.parse(
    'https://www.termsfeed.com/live/326f0644-fb94-4488-84a5-b0f50ae09148');

class _SignInState extends State<SignIn> {
  String? dateTime;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.purple,
          title: const Text(
            'SIGN IN',
            style: TextStyle(fontFamily: 'OpenSans-SemiBold'),
          ),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    const SizedBox(
                      height: 40,
                    ),
                    const Text(
                      'Name :',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    const Text(
                      'Phone :',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(
                      height: 42,
                    ),
                    const Text(
                      'DOB :',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(
                      height: 65,
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        final bool? status = await HTTPRequests()
                            .sendMobileNoSignIn(mobileNo.text);
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
                        } else if (status == false) {
                          showDialog(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                    title: const Text("Note"),
                                    content: const Text("Already Registered "),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => Login(),
                                              ));
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
                              builder: (context) => SignInOtp(
                                date: dateTime!,
                                name: name.text,
                                mobileNo: mobileNo.text,
                              ),
                            ),
                          );
                        }
                        ;
                      },
                      child: const Text(
                        ' SUBMIT  ',
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.purple),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    const SizedBox(
                      height: 35,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 12),
                      child: SizedBox(
                        height: 40,
                        width: 200,
                        child: TextField(
                          controller: name,
                          keyboardType: TextInputType.name,
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15.0),
                                borderSide: BorderSide.none,
                              ),
                              filled: true,
                              fillColor:
                                  const Color.fromARGB(80, 217, 217, 217)),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 12),
                      child: SizedBox(
                        height: 40,
                        width: 200,
                        child: TextField(
                          controller: mobileNo,
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15.0),
                                borderSide: BorderSide.none,
                              ),
                              filled: true,
                              fillColor:
                                  const Color.fromARGB(80, 217, 217, 217)),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextButton(
                      onPressed: () {
                        showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(1990),
                                lastDate: DateTime(2030))
                            .then((date) {
                          setState(() {
                            dateTime = DateFormat('yyyy-MM-dd').format(date!);
                          });
                        });
                      },
                      child: const Text(
                        'Choose Date',
                        style: TextStyle(
                            color: Colors.purple, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Text(
                      isDateSelected == false ? 'Date is mandatory!' : '',
                      style: const TextStyle(color: Colors.red),
                    ),
                    Text(
                      dateTime == null
                          ? 'No date Choosen!'
                          : dateTime.toString(),
                      // dateTime.toString().substring(6,17),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Login()),
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
                            const Color.fromARGB(255, 199, 193, 200)),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                            side: const BorderSide(
                              color: Color.fromARGB(255, 199, 193, 200),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.all(10),
              child: Center(
                  child: Text.rich(TextSpan(
                      text: 'By continuing, you agree to our ',
                      style: TextStyle(fontSize: 16, color: Colors.black),
                      children: <TextSpan>[
                    TextSpan(
                        text: 'Terms of Service',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.purple,
                          decoration: TextDecoration.underline,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            launchUrl(termsAndConditions);
                          }),
                    TextSpan(
                        text: ' and ',
                        style: TextStyle(fontSize: 18, color: Colors.black),
                        children: <TextSpan>[
                          TextSpan(
                              text: 'Privacy Policy',
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.purple,
                                  decoration: TextDecoration.underline),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  launchUrl(privacyPolicy);
                                })
                        ])
                  ]))),
            )
          ],
        ),
      ),
    );
  }
}
