import 'package:flutter/material.dart';
import 'package:kanakku_book/http_requests.dart';
import 'package:kanakku_book/retailer_screens/my_customer.dart';
import 'package:kanakku_book/retailer_screens/navigation_drawer.dart';
import 'package:kanakku_book/retailer_screens/pending_payment_card.dart';
import 'package:kanakku_book/retailer_screens/retailer_notifications.dart';
import 'package:kanakku_book/retailer_screens/scanner.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyShop extends StatefulWidget {
  MyShop({
    Key? key,
    required this.shopName,
  }) : super(key: key);
  final String shopName;
  @override
  State<MyShop> createState() => _MyShopState();
}

late SharedPreferences logindata;
late int? id;
late List<dynamic> billDetails = [];
Future<List<dynamic>> fetchData() async {
  logindata = await SharedPreferences.getInstance();
  id = logindata.getInt('ID');
  return await HTTPRequests().sendBill(id.toString());
}

bool _show = false;
bool btnshow = true;
final TextEditingController idFindingController = TextEditingController();

class _MyShopState extends State<MyShop> {
  @override
  void initState() {
    super.initState();
    fetchData().then((value) {
      setState(() {
        billDetails = value;
      });
    });
  }

  @override
  void dispose() {
    idFindingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _show = false;
          btnshow = true;
        });
      },
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: 'OpenSans',
          colorScheme: ColorScheme.fromSeed(
            seedColor: Color.fromRGBO(53, 143, 48, 100),
          ).copyWith(
            secondary: Color.fromRGBO(53, 143, 48, 100),
          ),
          textTheme: const TextTheme(bodyText2: TextStyle(color: Colors.black)),
        ),
        home: Scaffold(
          appBar: AppBar(
            leading: Builder(
              builder: (BuildContext context) {
                return GestureDetector(
                  child: const Icon(Icons.menu_outlined, size: 35),
                  onTap: () => Scaffold.of(context).openDrawer(),
                );
              },
            ),
            centerTitle: true,
            title: Text(
              widget.shopName,
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            toolbarHeight: 70,
            actions: [
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const RetailerNotifications()),
                  );
                },
                icon: const Icon(
                  Icons.notifications_outlined,
                  size: 35,
                ),
              ),
            ],
          ),
          drawer: const NavigationDrawer(),
          body: ListView(
            children: [
              Column(
                children: const [
                  SizedBox(
                    height: 15,
                  ),
                  Divider(
                    height: 20,
                    thickness: 1.5,
                    indent: 20,
                    endIndent: 20,
                    color: Colors.black,
                  ),
                  Text(
                    'PENDING PAYMENTS',
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                  Divider(
                    height: 20,
                    thickness: 1.5,
                    indent: 20,
                    endIndent: 20,
                    color: Colors.black,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                ],
              ),
              billDetails.isEmpty
                  ? const Padding(
                      padding: EdgeInsets.only(top: 200),
                      child: Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 8,
                        ),
                      ),
                    )
                  : PendingPaymentCard(billDetails),
            ],
          ),
          floatingActionButton: Visibility(
            visible: btnshow,
            child: FloatingActionButton(
              onPressed: () {
                _show = true;
                setState(() {
                  btnshow = false;
                });
              },
              child: const Icon(Icons.add),
            ),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
          bottomSheet: _showBottomSheet(),
        ),
      ),
    );
  }
}

Widget? _showBottomSheet() {
  try {
    if (_show) {
      return BottomSheet(
        onClosing: () {},
        builder: (context) {
          return SizedBox(
            height: MediaQuery.of(context).size.height / 2,
            child: Container(
              margin: const EdgeInsets.all(5),
              padding: const EdgeInsets.all(5),
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 237, 235, 235),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(80),
                  topRight: Radius.circular(80),
                ),
              ),
              child: Column(
                children: [
                  const SizedBox(
                    height: 50,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: TextField(
                      controller: idFindingController,
                      cursorColor: Colors.grey,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(40),
                            borderSide: BorderSide.none),
                        hintText: 'ENTER ID',
                        hintStyle: const TextStyle(
                            fontSize: 20,
                            color: Color.fromARGB(255, 104, 104, 106)),
                        prefixIcon: SizedBox(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20),
                            child: IconButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (conext) => MyCustomers(
                                            customerID:
                                                idFindingController.text)));
                                idFindingController.clear();
                              },
                              icon: const Icon(
                                Icons.person_search,
                                size: 34,
                                color: Color.fromRGBO(53, 143, 48, 100),
                              ),
                            ),
                          ),
                          width: 18,
                        ),
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(bottom: 20.0),
                    child: Text(
                      'or',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  SizedBox(
                    width: 350,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Scanner()),
                        );
                      },
                      child: const Text(
                        'ADD NEW CUSTOMER',
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                      style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(40),
                              side: const BorderSide(
                                  color: Color.fromRGBO(53, 143, 48, 100))),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    } else {
      return null;
    }
  } catch (e) {
    print('$e');
  }
  return null;
}
