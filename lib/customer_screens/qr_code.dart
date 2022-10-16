import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

final qrKey = GlobalKey();

class QRCode extends StatelessWidget {
  const QRCode({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Join Shop',
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

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  @override
  void initState() {
    super.initState();
    setUserData();
  }

  int? qrData;
  late SharedPreferences logindata;
  void setUserData() async {
    logindata = await SharedPreferences.getInstance();
    setState(() {
      qrData = logindata.getInt('ID');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(10),
        child: ListView(
          children: [
            Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.fromLTRB(10, 100, 10, 10),
                child: const Text(
                  'Scan QR Code',
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 40),
                )),
            RepaintBoundary(
              key: qrKey,
              child: QrImage(
                padding: const EdgeInsets.fromLTRB(100, 50, 20, 10),
                data: qrData.toString(),
                size: 250,
                backgroundColor: Colors.white,
                version: QrVersions.auto,
              ),
            ),
          ],
        ));
  }
}
