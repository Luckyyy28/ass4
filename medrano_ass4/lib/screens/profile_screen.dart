
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

class profile_screen extends StatefulWidget {
  profile_screen({super.key, required this.uid});

  final String uid;

  @override
  State<profile_screen> createState() => _profile_screenState();
}

class _profile_screenState extends State<profile_screen> {
  
  final formKey = GlobalKey<FormState>();

  final firstName = TextEditingController();

  final middleName = TextEditingController();

  final lastName = TextEditingController();

  final address = TextEditingController();

  final birthdate = TextEditingController();

  final email = TextEditingController();

  final password = TextEditingController();

  final confirmPassword = TextEditingController();

  bool showPassword = true;

  void getUser() async {
    DocumentSnapshot users = await FirebaseFirestore.instance.collection('users').doc(widget.uid).get();

    firstName.text = users.get('firstname').toString();
    middleName.text = users.get('middlename').toString();
    lastName.text = users.get('lastname').toString();
    address.text = users.get('address').toString();
    birthdate.text = users.get('birthdate').toString();
    email.text = users.get('email').toString();
  }

  void edit(){
    if (!formKey.currentState!.validate()) {
      return;
    }
    QuickAlert.show(
      context: context,
      type: QuickAlertType.confirm,
      title: 'Are you sure?',
      confirmBtnText: 'YES',
      cancelBtnText: 'No',
      onConfirmBtnTap: () {
        Navigator.of(context).pop();
        editClient();
      },
    );
  }

  void editClient() async{

    await FirebaseFirestore.instance.collection('users').doc(widget.uid).set({
      'firstname': firstName.text,
      'middlename': middleName.text,
      'lastname': lastName.text,
      'address': address.text,
      'birthdate': birthdate.text,
      'email': email.text,
      'type': 'client',
    });      
  }

  @override
  void initState() {
    super.initState();
    getUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
        centerTitle: true,
      ),
      body: Container(
        height: double.infinity,
        padding: const EdgeInsets.all(16),
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text('To Edit as Client, please enter the needed information.'),
                const Gap(12),
                TextFormField(
                  controller: firstName,
                  decoration: setTextDecoration('First Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Required.';
                    }
                  },
                ),
                const Gap(12),
                TextFormField(
                  controller: middleName,
                  decoration: setTextDecoration('Last Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Required';
                    }
                  },
                ),
                const Gap(12),
                TextFormField(
                  controller: lastName,
                  decoration: setTextDecoration('Last Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Required';
                    }
                  },
                ),
                const Gap(12),
                TextFormField(
                  controller: address,
                  decoration: setTextDecoration('Address'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Required';
                    }
                  },
                ),
                const Gap(12),
                TextFormField(
                  controller: birthdate,
                  decoration: setTextDecoration('Birthdate'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Required';
                    }
                  },
                ),
                const Gap(12),
                TextFormField(
                  controller: email,
                  decoration: setTextDecoration('Email Address'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Required.';
                    }
                    if (!EmailValidator.validate(value)) {
                      return 'Invalid email';
                    }
                  },
                ),
                const Gap(12),
                
                const Gap(12),
                ElevatedButton(
                  onPressed: edit,
                  child: const Text('Edit'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration setTextDecoration(String name, {bool isPassword = false}) {
    return InputDecoration(
      border: const OutlineInputBorder(),
      label: Text(name),
    );
  }
}