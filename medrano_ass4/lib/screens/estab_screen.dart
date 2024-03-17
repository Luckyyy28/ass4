import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_try/screens/estab_log.dart';
import 'package:firebase_try/screens/estab_profile.dart';
import 'package:firebase_try/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

class establishment_screen extends StatelessWidget {
  establishment_screen({super.key, required this.uid});

  final String uid;

  void scanQR(context) async {
    final lineColor = '#ffffff';
    final cancelButtonText = 'CANCEL';
    final isShowFlashIcon = true;
    final scanMode = ScanMode.DEFAULT;
    final qr = await FlutterBarcodeScanner.scanBarcode(lineColor, cancelButtonText, isShowFlashIcon, scanMode);

    if (qr == '-1') {
      return;
    }

    if (!await validateQR(qr)) {
      QuickAlert.show(
        context: context,
        title: 'Invalid QR',
        text: 'The QR code is not valid',
        type: QuickAlertType.error,
        barrierDismissible: false,
      );

      return;
    }
    
    final currentUser = FirebaseAuth.instance.currentUser!.uid;

    final client = FirebaseFirestore.instance.collection('users/$qr/logs');
    final establishment = FirebaseFirestore.instance.collection('users/$currentUser/logs');

    QuickAlert.show(
      context: context,
      title: 'Validating QR',
      text: 'Please wait...',
      type: QuickAlertType.loading,
      barrierDismissible: false,
    );

    try {
      await client.add({
        'establishment': FirebaseAuth.instance.currentUser!.uid,
        'timestamp': DateTime.now().toString(),
      });

      await establishment.add({
        'client': qr,
        'timestamp': DateTime.now().toString(),
      });

      Navigator.pop(context);

      QuickAlert.show(
        context: context,
        title: 'Success',
        text: 'The QR code was successfully validated',
        type: QuickAlertType.success,
        barrierDismissible: false,
      );
    } catch (e) {
      QuickAlert.show(
        context: context,
        title: 'Error',
        text: 'An error occurred while validating the QR code',
        type: QuickAlertType.error,
        barrierDismissible: false,
      );
    }  
  }

   Future<bool> validateQR(String qr) async {
    

    try{
      final doc = FirebaseFirestore.instance.collection('users').doc(qr);
      final snapshot = await doc.get();

      return snapshot.exists;
    }catch(e){
    }

    return false;
    
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Establishment'),
        centerTitle: true,
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

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) {
                      return estab_profile(uid: uid,);
                    },
                  ),
                );
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
                      return const estab_log();
                    },
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: (){
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>HomeScreen()));
              },
            ),
          ],
        ),
      ),
      body: Container(
        child: ElevatedButton(
          onPressed: (){scanQR(context);},
          child: Text('Scan'),
        ),
      ),
    );
  }
}