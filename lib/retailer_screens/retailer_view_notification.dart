import 'package:flutter/material.dart';

class ViewNotifications extends StatelessWidget {
  const ViewNotifications(
      {Key? key,
      required this.customerName,
      required this.subject,
      required this.query})
      : super(key: key);
  final String customerName;
  final String subject;
  final String query;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Notification',
          style: TextStyle(fontSize: 25, fontFamily: 'OpenSans-SemiBold'),
        ),
        backgroundColor: Colors.green,
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 40,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: const [
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: AssetImage(
                      'assets/images/profile.png',
                    ),
                  ),
                ],
              ),
              SingleChildScrollView(
                child: Column(
                  children: [
                    Text(
                      subject,
                      style: const TextStyle(fontSize: 22),
                    ),
                    Text(
                      customerName,
                      style: const TextStyle(
                        fontSize: 22,
                        color: Color.fromRGBO(53, 143, 48, 100),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 40,
          ),
          const Divider(
            height: 20,
            thickness: 1.5,
            indent: 20,
            endIndent: 20,
            color: Colors.black,
          ),
          const SizedBox(
            height: 40,
          ),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Text(
                query,
                style: const TextStyle(fontSize: 25),
              ),
            ),
          ),
          const SizedBox(
            height: 40,
          ),
          ElevatedButton(
            onPressed: () {},
            child: const Text('Reply'),
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.green),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
