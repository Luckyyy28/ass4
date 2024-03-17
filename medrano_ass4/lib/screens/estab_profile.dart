
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

class estab_profile extends StatefulWidget {
  estab_profile({super.key, required this.uid});

  final String uid;

  @override
  State<estab_profile> createState() => _estab_profileState();
}

class _estab_profileState extends State<estab_profile> {
  
  final formKey = GlobalKey<FormState>();

  final firstName = TextEditingController();

  final lastName = TextEditingController();

  final address = TextEditingController();

  final business = TextEditingController();

  final email = TextEditingController();

  void getUser() async {
    DocumentSnapshot users = await FirebaseFirestore.instance.collection('users').doc(widget.uid).get();

    firstName.text = users.get('firstname').toString();
    lastName.text = users.get('lastname').toString();
    address.text = users.get('address').toString();
    business.text = users.get('business').toString();
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
      'lastname': lastName.text,
      'address': address.text,
      'business': business.text,
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
                const Text('To Edit as Establishment, please enter the needed information.'),
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
                  controller: business,
                  decoration: setTextDecoration('Business'),
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