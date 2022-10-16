import 'package:flutter/material.dart';
import 'package:kanakku_book/customer_screens/mypurchase.dart';
import 'package:kanakku_book/http_requests.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Support extends StatelessWidget {
  const Support({Key? key}) : super(key: key);

  static const String _title = 'SUPPORT';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _title,
          style: TextStyle(fontFamily: 'OpenSans-SemiBold'),
        ),
      ),
      body: const MyStatefulWidget(),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key}) : super(key: key);

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

late SharedPreferences logindata;
late int? id;

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  TextEditingController shopIDController = TextEditingController();
  TextEditingController subjectController = TextEditingController();
  TextEditingController queryController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(10),
        child: ListView(
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 25),
              child: Text(
                "Shop ID:",
                style: TextStyle(fontSize: 23),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  top: 20, bottom: 20, left: 25, right: 25),
              child: SizedBox(
                height: 50,
                width: 200,
                child: TextField(
                  readOnly: false,
                  controller: shopIDController,
                  keyboardType: TextInputType.number,
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
            const Padding(
              padding: EdgeInsets.only(left: 25),
              child: Text(
                "Subject:",
                style: TextStyle(fontSize: 23),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  top: 20, bottom: 20, left: 25, right: 25),
              child: SizedBox(
                height: 50,
                width: 200,
                child: TextField(
                  controller: subjectController,
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
            const Padding(
              padding: EdgeInsets.only(left: 25),
              child: Text(
                "Query:",
                style: TextStyle(fontSize: 23),
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(25, 25, 25, 25),
              child: TextField(
                controller: queryController,
                maxLines: 10,
                cursorHeight: 30,
                // style: TextStyle(height: 3.0),
                // obscureText: true,
                // controller: passwordController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: const Color.fromARGB(80, 217, 217, 217)),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Container(
                height: 60,
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: ElevatedButton(
                  child: const Text(
                    'SEND',
                    style: TextStyle(
                        fontFamily: 'OpenSans-SemiBold', fontSize: 22),
                  ),
                  onPressed: () async {
                    logindata = await SharedPreferences.getInstance();
                    id = logindata.getInt('ID');
                    final bool? status = await HTTPRequests().sendQuery(
                        id.toString(),
                        shopIDController.text,
                        subjectController.text,
                        queryController.text);
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
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: ((context) => MyPurchase())));
                    }
                  },
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                  ),
                )),
          ],
        ));
  }
}
