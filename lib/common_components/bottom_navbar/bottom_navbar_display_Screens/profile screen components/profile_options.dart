import 'package:flutter/material.dart';
import 'package:xpense_app/sms.dart';

class UserProfileoptions extends StatelessWidget {
  const UserProfileoptions({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextButton.icon(
              onPressed: () {},
              icon: const Icon(
                Icons.person_outline_outlined,
                size: 40,
              ),
              label: const Text(
                "Profile Details",
                style: TextStyle(fontSize: 25),
              )),
          TextButton.icon(
              onPressed: () {},
              icon: const Icon(
                Icons.notifications_outlined,
                size: 40,
              ),
              label: const Text(
                "Notifications",
                style: TextStyle(fontSize: 25),
              )),
          TextButton.icon(
              onPressed: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => const SmsWidget()));
              },
              icon: const Icon(
                Icons.settings_outlined,
                size: 40,
              ),
              label: const Text(
                "Settings",
                style: TextStyle(fontSize: 25),
              )),
          TextButton.icon(
              onPressed: () {},
              icon: const Icon(
                Icons.support_outlined,
                size: 40,
              ),
              label: const Text(
                "Support",
                style: TextStyle(fontSize: 25),
              )),
          TextButton.icon(
              onPressed: () {},
              icon: const Icon(
                Icons.logout_outlined,
                size: 40,
              ),
              label: const Text(
                "Logout",
                style: TextStyle(fontSize: 25),
              ))
        ],
      ),
    );
  }
}
