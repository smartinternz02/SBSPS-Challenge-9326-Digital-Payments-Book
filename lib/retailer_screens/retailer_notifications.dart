import 'package:flutter/material.dart';
import 'package:kanakku_book/http_requests.dart';
import 'package:kanakku_book/retailer_screens/retailer_notification_tile.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RetailerNotifications extends StatefulWidget {
  const RetailerNotifications({Key? key}) : super(key: key);

  @override
  State<RetailerNotifications> createState() => _RetailerNotificationsState();
}

late List<dynamic> retailerNotifications = [];
late SharedPreferences logindata;
late int? id;
Future<List<dynamic>> fetchNotificationsData() async {
  logindata = await SharedPreferences.getInstance();
  id = logindata.getInt('ID');
  return await HTTPRequests().myNotifications(id.toString());
}

class _RetailerNotificationsState extends State<RetailerNotifications> {
  @override
  void initState() {
    super.initState();
    fetchNotificationsData().then((value) {
      setState(() {
        retailerNotifications = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text(
          'Notifications',
          style: TextStyle(fontFamily: "OpenSans-SemiBold"),
        ),
      ),
      body: SingleChildScrollView(
          child:
              RetailerNotificationTile(myNotifications: retailerNotifications)),
    );
  }
}
