
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_try/screens/client_log.dart';
import 'package:firebase_try/screens/home.dart';
import 'package:firebase_try/screens/profile_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:qr_flutter/qr_flutter.dart';

class client_screen extends StatelessWidget {
  client_screen({super.key, required this.uid});

  final String uid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Client'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.of(context).pushReplacement(
                CupertinoPageRoute(
                  builder: (_) => HomeScreen(),
                ),
              );
            },
            icon: FaIcon(FontAwesomeIcons.arrowRightFromBracket),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              child: Text(
                'Trace app',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32.0,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Profile'),
              onTap: () {
                Navigator.pop(context);

                Navigator.push(context, MaterialPageRoute(builder: (_)=>profile_screen(uid: uid)));
              },
            ),
            ListTile(
              leading: const Icon(Icons.history),
              title: const Text('History'),
              onTap: () {
                Navigator.pop(context);

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) {
                      return const client_log();
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: QrImageView(
          data: uid,
          version: QrVersions.auto,
        ),
      ),
    );
  }
}