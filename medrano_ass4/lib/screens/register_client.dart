import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

class register_client extends StatefulWidget {
  const register_client({super.key});

  @override
  State<register_client> createState() => _register_clientState();
}

class _register_clientState extends State<register_client> {

  final formKey = GlobalKey<FormState>();
  final firstName = TextEditingController();
  final MiddleName = TextEditingController();
  final lastName = TextEditingController();
  final address = TextEditingController();
  final birthdate = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();
  final confirmPassword = TextEditingController();
  bool showPassword = true;

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
                const Text(
                    'To register as Client, please enter the needed information.'),
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
                  controller: MiddleName,
                  decoration: setTextDecoration('Middle Name'),
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
                TextFormField(
                  obscureText: showPassword,
                  controller: password,
                  decoration: setTextDecoration('Password', isPassword: true),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Required.';
                    }
                  },
                ),
                const Gap(12),
                TextFormField(
                  obscureText: showPassword,
                  controller: confirmPassword,
                  decoration: setTextDecoration('Confirm Password'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Required.';
                    }
                    if (password.text != value) {
                      return 'Passwords do not match.';
                    }
                  },
                ),
                const Gap(12),
                ElevatedButton(
                  onPressed: register,
                  child: const Text('Register'),
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
      suffixIcon: isPassword
          ? IconButton(
              onPressed: toggleShowPassword,
              icon: Icon(
                showPassword ? Icons.visibility : Icons.visibility_off,
              ),
            )
          : null,
    );
  }

  void register() {
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
        registerClient();
      },
    );
  }

  void registerClient() async {
    try {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.loading,
        title: 'Loading',
        text: 'Registering your account',
      );
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: email.text, password: password.text);
      String user_id = userCredential.user!.uid;
      await FirebaseFirestore.instance.collection('users').doc(user_id).set({
        'firstname': firstName.text,
        'middlename': MiddleName.text,
        'lastname': lastName.text,
        'address': address.text,
        'birthdate': birthdate.text,
        'email': email.text,
        'type': 'client',
      });
      Navigator.of(context).pop();
    } on FirebaseAuthException catch (ex) {
      Navigator.of(context).pop();
      var errorTitle = '';
      var errorText = '';
      if (ex.code == 'weak-password') {
        errorText = 'Please enter a password with more than 6 characters';
        errorTitle = 'Weak Password';
      } else if (ex.code == 'email-already-in-use') {
        errorText = 'Password is already registered';
        errorTitle = 'Please enter a new email.';
      }

      QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        title: errorTitle,
        text: errorText,
      );
    }
  }

  void toggleShowPassword() {
    setState(() {
      showPassword = !showPassword;
    });
  }

}