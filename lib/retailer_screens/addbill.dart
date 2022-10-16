import 'package:flutter/material.dart';
import 'package:kanakku_book/http_requests.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './myshop.dart';

class AddBill extends StatefulWidget {
  const AddBill(
      {Key? key,
      required this.customerName,
      required this.customerPhoneNo,
      required this.customerID,
      required this.customerDetails})
      : super(key: key);
  final String customerName;
  final String customerPhoneNo;
  final String customerID;
  final Map customerDetails;

  @override
  State<AddBill> createState() => _AddBillState();
}

class _AddBillState extends State<AddBill> {
  TextEditingController amount = TextEditingController();
  TextEditingController kPoints = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("ADD BILL"),
      ),
      body: Center(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    const SizedBox(
                      height: 40,
                    ),
                    const Text(
                      'Customer ID : ',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
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
                      height: 40,
                    ),
                    const Text(
                      'Add Amount  : ',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        // widget.customerDetails({
                        //   "id": widget.customerID,
                        //   'name': widget.customerName,
                        //   'phone': widget.customerPhoneNo,
                        //   'amount': amount.text,
                        //   'KPoints': kPoints,
                        // });
                        logindata = await SharedPreferences.getInstance();
                        id = logindata.getInt('ID');
                        final bool? status = await HTTPRequests()
                            .sendNewCustomerData(
                                widget.customerID, id.toString(), amount.text);
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
                                          // color: Colors.green,
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
                                          // color: Colors.green,
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
                                    //title: const Text("NOTE"),
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
                          String? shopName = logindata.getString("shopName");
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MyShop(
                                      shopName: shopName!,
                                    )),
                          );
                        }
                      },
                      child: const Text(
                        ' ADD  ',
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
                  ],
                ),
                Column(
                  children: [
                    const SizedBox(
                      height: 30,
                    ),
                    SizedBox(
                      height: 40,
                      width: 200,
                      child: TextField(
                        readOnly: true,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                            hintText: widget.customerID,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15.0),
                              borderSide: BorderSide.none,
                            ),
                            filled: true,
                            fillColor: const Color.fromARGB(80, 217, 217, 217)),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    SizedBox(
                      height: 40,
                      width: 200,
                      child: TextField(
                        readOnly: true,
                        keyboardType: TextInputType.name,
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                            hintText: widget.customerName,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15.0),
                              borderSide: BorderSide.none,
                            ),
                            filled: true,
                            fillColor: const Color.fromARGB(80, 217, 217, 217)),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    SizedBox(
                      height: 40,
                      width: 200,
                      child: TextField(
                        readOnly: true,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                            hintText: widget.customerPhoneNo,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15.0),
                              borderSide: BorderSide.none,
                            ),
                            filled: true,
                            fillColor: const Color.fromARGB(80, 217, 217, 217)),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    SizedBox(
                      height: 40,
                      width: 200,
                      child: TextField(
                        controller: amount,
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
          ],
        ),
      ),
    );
  }
}
