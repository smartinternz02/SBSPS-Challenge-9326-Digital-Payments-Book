import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kanakku_book/http_requests.dart';
import 'package:kanakku_book/retailer_screens/myshop.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Myaccount extends StatefulWidget {
  Myaccount({Key? key, required this.accountDetails}) : super(key: key);

  Map accountDetails;
  @override
  State<Myaccount> createState() => _MyaccountState();
}

String? _dateTime;
bool isDateSelected = true;

class _MyaccountState extends State<Myaccount> {
  @override
  void initState() {
    super.initState();
    name.text = widget.accountDetails["NAME"];
    mobileNo.text = widget.accountDetails["PHONE_NUMBER"];
    _dateTime = widget.accountDetails["DOB"].toString().substring(6, 17);
  }

  late SharedPreferences logindata;
  late int? id;
  TextEditingController name = TextEditingController();
  TextEditingController mobileNo = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Account'),
      ),
      body: Row(
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
                  logindata = await SharedPreferences.getInstance();
                  id = logindata.getInt('ID');
                  final bool? status = await HTTPRequests().sendAccount(
                      id.toString(),
                      mobileNo.text,
                      name.text,
                      _dateTime.toString());
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
                              title: const Text("Issue"),
                              content: const Text("not updated "),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(14),
                                    child: const Text("close"),
                                  ),
                                ),
                              ],
                            ));
                  } else {
                    showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                              content: const Text(
                                "UPDATED SUCCESSFULY  !!!",
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromARGB(255, 50, 185, 54)),
                              ),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Container(
                                    //  color: Colors.green,
                                    padding: const EdgeInsets.all(14),
                                    child: const Text("close"),
                                  ),
                                ),
                              ],
                            ));
                  }
                },
                child: const Text(
                  ' UPDATE  ',
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
                        fillColor: const Color.fromARGB(80, 217, 217, 217)),
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
                        fillColor: const Color.fromARGB(80, 217, 217, 217)),
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
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2023))
                      .then((date) {
                    setState(() {
                      _dateTime = DateFormat('yyyy-MM-dd').format(date!);
                    });
                  });
                },
                child: const Text(
                  'Choose Date',
                  style: TextStyle(
                      color: Color.fromRGBO(53, 143, 48, 100),
                      fontWeight: FontWeight.bold),
                ),
              ),
              Text(
                isDateSelected == false ? 'Date is mandatory!' : '',
                style: const TextStyle(color: Colors.red),
              ),
              Text(
                // _dateTime == null ? 'No date Choosen!' : _dateTime.toString(),
                _dateTime.toString(),
              ),
              const SizedBox(
                height: 30,
              ),
              ElevatedButton(
                onPressed: () {
                  String? shopName = logindata.getString("shopName");
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MyShop(
                              shopName: shopName!,
                            )),
                  );
                },
                child: const Text(
                  'CANCEL',
                  style: TextStyle(
                    fontSize: 20,
                    color: Color.fromRGBO(53, 143, 48, 100),
                  ),
                ),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                      const Color.fromARGB(255, 199, 193, 200)),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
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
    );
  }
}
