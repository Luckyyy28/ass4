import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class client_log extends StatefulWidget {
  const client_log({super.key});

  @override
  State<client_log> createState() => _client_logState();
}

class _client_logState extends State<client_log> {

  DateTime? filterDate;

  final firstDate = DateTime(0001);

  static Future<List<Map<String, dynamic>>> getClientLogs() async {
    final currentUser = FirebaseAuth.instance.currentUser!.uid;

    final dataLog = await FirebaseFirestore.instance.collection('users/$currentUser/logs').get();

    final logCollection = dataLog.docs.map((e) => e.data()).toList();

    final List<Map<String, dynamic>> logs = [];

    for (final log in logCollection) {
      final establishmentData = await FirebaseFirestore.instance.collection('users').doc(log['establishment'].toString()).get();

      final establishmentName = establishmentData.get('business');
      logs.add({
        'establishment': establishmentName,
        'timestamp': log['timestamp'],
      });
    }

    return logs;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('History'),
        actions: [
          IconButton(
            onPressed: () async {
              final date = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: firstDate,
                lastDate: DateTime.now(),
              );

              if (date != null) {
                setState(() {
                  filterDate = date;
                });
              }
            },
            icon: const Icon(Icons.calendar_month),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                filterDate = null;
              });
            },
            child: const Text('All'),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder(
          future: getClientLogs(),
          builder: (_, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (!snapshot.hasData) {
              return const Center(
                child: Text('No logs found'),
              );
            }

            final logs = snapshot.data!;

            if (filterDate != null) {
              logs.removeWhere((element) {
                final date = DateTime.parse(element['timestamp'].toString());

                return date.day != filterDate!.day ||
                    date.month != filterDate!.month ||
                    date.year != filterDate!.year;
              });
            }

            if (logs.isEmpty) {
              return const Center(
                child: Text('No logs found'),
              );
            }

            return ListView.builder(
              itemCount: logs.length,
              itemBuilder: (BuildContext context, int index) {
                final time = DateFormat('h:mm a').format(
                    DateTime.parse(logs[index]['timestamp'].toString()));
                final date = DateFormat('MMMM d, yyyy').format(
                    DateTime.parse(logs[index]['timestamp'].toString()));

                return Card(
                  child: ListTile(
                    title: Text(logs[index]['establishment'].toString()),
                    subtitle: Text('$date @ $time'),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}