import 'package:firebase_try/screens/login.dart';
import 'package:firebase_try/screens/register_client.dart';
import 'package:firebase_try/screens/register_estab.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () => open(login_screen(), context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightBlueAccent,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Login'),
              ),
              const Gap(12),
              ElevatedButton(
                onPressed: () => open(register_client(), context),
                child: const Text('Register as Client'),
              ),
              const Gap(12),
              ElevatedButton(
                onPressed: () => open(register_establishment(), context),
                child: const Text('Register as Establishment'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void open(Widget screen, BuildContext context) {
    Navigator.of(context).push(CupertinoPageRoute(builder: (_) => screen));
  }
  
}