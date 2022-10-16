import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kanakku_book/customer_screens/mypurchase.dart';
import 'package:kanakku_book/http_requests.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class CustomerMyAccount extends StatefulWidget {
  CustomerMyAccount({Key? key, required this.accountDetails}) : super(key: key);

  Map accountDetails;
  @override
  State<CustomerMyAccount> createState() => _CustomerMyAccountState();
}

String? _dateTime;
bool isDateSelected = true;

class _CustomerMyAccountState extends State<CustomerMyAccount> {
  @override
  void initState() {
    super.initState();
    name.text = widget.accountDetails["NAME"];
    mobileNo.text = widget.accountDetails["PHONE_NUMBER"];
    _dateTime = widget.accountDetails["DOB"];
  }

  late SharedPreferences logindata;
  late int? id;
  TextEditingController name = TextEditingController();
  TextEditingController mobileNo = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Account',
          style: TextStyle(fontFamily: 'OpenSans-SemiBold'),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
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
                    Padding(
                      padding: const EdgeInsets.only(left: 18.0),
                      child: ElevatedButton(
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
                                            color:
                                                Color.fromARGB(255, 50, 185, 54)),
                                      ),
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
                          }
                        },
                        child: const Text(
                          ' UPDATE  ',
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                        style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
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
                                firstDate: DateTime(1990),
                                lastDate: DateTime(2030))
                            .then((date) {
                          setState(() {
                            _dateTime = DateFormat('yyyy-MM-dd').format(date!);
                          });
                        });
                      },
                      child: const Text(
                        'Choose Date',
                        style: TextStyle(
                            color: Color.fromRGBO(136, 48, 143, 100),
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Text(
                      isDateSelected == false ? 'Date is mandatory!' : '',
                      style: const TextStyle(color: Colors.red),
                    ),
                    Text(
                      _dateTime.toString().substring(6, 17),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => MyPurchase()),
                        );
                      },
                      child: const Text(
                        'CANCEL',
                        style: TextStyle(
                          fontSize: 20,
                          color: Color.fromRGBO(136, 48, 143, 100),
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
            Container(
              margin: EdgeInsets.only(top: 40),
              height: 320,
              width: 250,
              child: SfRadialGauge(
                  title: GaugeTitle(
                      text: 'K POINTS',
                      textStyle: const TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.purple,
                          fontFamily: "OpenSans-SemiBold")),
                  axes: <RadialAxis>[
                    RadialAxis(minimum: 0, maximum: 2000, ranges: <GaugeRange>[
                      GaugeRange(
                          startValue: 0,
                          endValue: 400,
                          color: Colors.red,
                          startWidth: 10,
                          endWidth: 10),
                      GaugeRange(
                          startValue: 400,
                          endValue: 800,
                          color: Colors.orange,
                          startWidth: 10,
                          endWidth: 10),
                      GaugeRange(
                          startValue: 800,
                          endValue: 1200,
                          color: Colors.yellow,
                          startWidth: 10,
                          endWidth: 10),
                      GaugeRange(
                          startValue: 1200,
                          endValue: 1600,
                          color: Colors.greenAccent,
                          startWidth: 10,
                          endWidth: 10),
                      GaugeRange(
                          startValue: 1600,
                          endValue: 2000,
                          color: Colors.green,
                          startWidth: 10,
                          endWidth: 10)
                    ], pointers: <GaugePointer>[
                      NeedlePointer(
                          value: widget.accountDetails["KPOINTS"].toDouble())
                    ], annotations: <GaugeAnnotation>[
                      GaugeAnnotation(
                          widget: Container(
                              child: Text(
                                  widget.accountDetails["KPOINTS"].toString(),
                                  style: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.purple,
                                      fontFamily: "OpenSans-SemiBold"))),
                          angle: 90,
                          positionFactor: 0.5)
                    ])
                  ]),
            ),
          ],
        ),
      ),
    );
  }
}
