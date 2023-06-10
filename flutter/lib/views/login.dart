import 'package:flutter/material.dart';
import '../endpoints/user.dart';
import 'tabs.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _name = TextEditingController();
  final _password = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final form = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.maps_home_work_rounded, size: 80, color: Colors.black),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter name';
              }
              return null;
            },
            controller: _name,
            decoration: const InputDecoration(labelText: 'Name'),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter password';
              }
              return null;
            },
            controller: _password,
            obscureText: true,
            enableSuggestions: false,
            autocorrect: false,
            decoration: const InputDecoration(labelText: 'Password'),
          ),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            textStyle: const TextStyle(fontSize: 20),
            minimumSize: const Size.fromHeight(40),
          ),
          onPressed: () {
            login();
          },
          child: const Text('Login'),
        ),
      ],
    );

    return Scaffold(
      body: SafeArea(
          child: Center(
              child: SingleChildScrollView(
                  child: Form(
                      key: _formKey,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      child: form)))),
    );
  }

  login() async {
    if (_formKey.currentState!.validate()) {
      Map<String, dynamic> form = {
        'password': _password.text,
        'name': _name.text,
      };
      await UserService().login(form).then((response) {
        if (response == "401") {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Center(
                child: Text('Unauthorized'),
              ),
              duration: Duration(seconds: 6),
            ),
          );
        } else if (response == "200") {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const TabsPage()),
          );
        }
      }).catchError((error) {
        debugPrint(error.toString());
      });
    }
  }
}
