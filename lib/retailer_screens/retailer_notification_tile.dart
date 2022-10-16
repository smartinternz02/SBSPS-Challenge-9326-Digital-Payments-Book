import 'package:flutter/material.dart';
import 'package:kanakku_book/retailer_screens/retailer_view_notification.dart';

class RetailerNotificationTile extends StatelessWidget {
  const RetailerNotificationTile({Key? key, required this.myNotifications})
      : super(key: key);

  final List<dynamic> myNotifications;
  @override
  Widget build(BuildContext context) {
    List<Widget> tileList = [];
    for (int i = 0; i < myNotifications.length; i++) {
      tileList.add(
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ViewNotifications(
                  customerName: myNotifications[i]['CUST_NAME'],
                  subject: myNotifications[i]['SUBJECT'],
                  query: myNotifications[i]['QUERY'],
                ),
              ),
            );
          },
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 20),
                    child: CircleAvatar(
                      radius: 20,
                      backgroundImage: AssetImage(
                        'assets/images/profile.png',
                      ),
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        myNotifications[i]['CUST_NAME'],
                        style: const TextStyle(
                          fontWeight: FontWeight.w400,
                          color: Color.fromRGBO(53, 143, 48, 100),
                          fontSize: 23,
                        ),
                      ),
                      Text(
                        myNotifications[i]['SUBJECT'],
                        style: const TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    width: 40,
                  ),
                ],
              ),
              const Divider(
                height: 20,
                thickness: 1.5,
                indent: 10,
                endIndent: 10,
                color: Colors.black,
              ),
            ],
          ),
        ),
      );
    }
    return Column(
      children: [
        const SizedBox(
          height: 20,
        ),
        Column(
          children: tileList,
        ),
      ],
    );
  }
}
