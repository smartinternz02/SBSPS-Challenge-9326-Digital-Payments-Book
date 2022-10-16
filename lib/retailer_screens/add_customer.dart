import 'package:flutter/material.dart';
import 'package:kanakku_book/http_requests.dart';
import 'package:kanakku_book/retailer_screens/addbill.dart';
import 'package:kanakku_book/retailer_screens/myshop.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddCustomer extends StatefulWidget {
  AddCustomer(
      {Key? key, required this.customerDetails, required this.customerID})
      : super(key: key);
  final Map customerDetails;
  String customerID;
  @override
  State<AddCustomer> createState() => _AddCustomerState();
}

class _AddCustomerState extends State<AddCustomer> {
  @override
  void initState() {
    super.initState();
    customerID.text = widget.customerID;
    customerName.text = widget.customerDetails["NAME"];
    customerPhoneNo.text = widget.customerDetails["PHONE_NUMBER"];
  }

  TextEditingController customerName = TextEditingController();
  TextEditingController customerPhoneNo = TextEditingController();
  TextEditingController customerID = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("ADD CUSTOMER"),
      ),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 48, bottom: 30),
                  child: Text(
                    'Customer ID : ',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 30, bottom: 30),
                  child: Text(
                    'Name :',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 30, bottom: 30),
                  child: Text(
                    'Phone :',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 30),
                  child: ElevatedButton(
                    onPressed: () async {
                      logindata = await SharedPreferences.getInstance();
                      id = logindata.getInt('ID');

                      final Map? status = await HTTPRequests()
                          .addCustomerData(widget.customerID, id.toString());
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
                      } else if (widget.customerDetails['status'] == false) {
                        showDialog(
                            context: context,
                            builder: (ctx) => AlertDialog(
                                  title: const Text("Note"),
                                  content: const Text(
                                      "Customer already registered !!!"),
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
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AddBill(
                                  customerName: customerName.text,
                                  customerPhoneNo: customerPhoneNo.text,
                                  customerID: customerID.text,
                                  customerDetails: widget.customerDetails)),
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
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 45, bottom: 30),
                  child: SizedBox(
                    height: 40,
                    width: 200,
                    child: TextField(
                      readOnly: true,
                      controller: customerID,
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
                Padding(
                  padding: const EdgeInsets.only(top: 20, bottom: 30),
                  child: SizedBox(
                    height: 40,
                    width: 200,
                    child: TextField(
                      readOnly: true,
                      controller: customerName,
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
                Padding(
                  padding: const EdgeInsets.only(top: 15, bottom: 20),
                  child: SizedBox(
                    height: 40,
                    width: 200,
                    child: TextField(
                      readOnly: true,
                      controller: customerPhoneNo,
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
                Padding(
                  padding: const EdgeInsets.only(top: 25),
                  child: ElevatedButton(
                    onPressed: () {
                      String? shopName = logindata.getString("shopName");
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MyShop(shopName: shopName!)),
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
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
