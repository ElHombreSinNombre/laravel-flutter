import 'package:flutter/material.dart';
import 'package:map/endpoints/user.dart';

class FormPage extends StatefulWidget {
  final int? id;

  const FormPage({Key? key, this.id}) : super(key: key);

  @override
  State<FormPage> createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  String _language = 'es';
  final _city = TextEditingController();
  double _latitude = 90.0;
  double _longitude = 180.0;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    if (widget.id != null) {
      UserService().edit(widget.id).then((user) {
        setState(() {
          _name.text = user.name;
          _email.text = user.email!;
          _language = user.language;
          _city.text = user.city!;
          _latitude = user.latitude!;
          _longitude = user.longitude!;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final form = Column(mainAxisSize: MainAxisSize.min, children: [
      Text(widget.id == null ? 'New user' : 'Edit user',
          style: Theme.of(context).textTheme.titleLarge),
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
          decoration: InputDecoration(
              labelText: widget.id == null ? 'Name' : 'New name'),
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextFormField(
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter email';
            }
            return null;
          },
          controller: _email,
          decoration: InputDecoration(
              labelText: widget.id == null ? 'Email' : 'New email'),
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextFormField(
          validator: (value) {
            if ((value == null || value.isEmpty) && widget.id == null) {
              return 'Please enter password';
            }
            return null;
          },
          controller: _password,
          obscureText: true,
          enableSuggestions: false,
          autocorrect: false,
          decoration: InputDecoration(
              labelText: widget.id == null ? 'Password' : 'New password'),
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextFormField(
          controller: _city,
          decoration: InputDecoration(
              labelText: widget.id == null ? 'City' : 'New city'),
        ),
      ),
      DropdownButton<String>(
        value: _language,
        icon: const Icon(Icons.arrow_downward),
        elevation: 16,
        style: const TextStyle(color: Colors.deepPurple),
        underline: Container(
          height: 2,
          color: Colors.deepPurpleAccent,
        ),
        onChanged: (String? newValue) {
          setState(() {
            _language = newValue!;
          });
        },
        items:
            <String>['es', 'en'].map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value == 'es' ? 'Spanish' : 'English'),
          );
        }).toList(),
      ),
      const Divider(color: Colors.transparent),
      Text('Latitude: $_latitude'),
      Slider(
        value: _latitude,
        max: 90.0,
        min: -90.0,
        onChanged: (double newValue) {
          setState(() {
            _latitude = newValue;
          });
        },
      ),
      const Divider(color: Colors.transparent),
      Text('Longitude: $_longitude'),
      Slider(
        value: _longitude,
        max: 180.0,
        min: -180.0,
        onChanged: (double newValue) {
          setState(() {
            _longitude = newValue;
          });
        },
      )
    ]);

    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
              child: Center(
                  child: Form(
                      key: _formKey,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      child: form)))),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            Map<String, dynamic> form = {
              'name': _name.text,
              'email': _email.text,
              'language': _language.toString(),
              'city': _city.text,
              'latitude': _latitude.toString(),
              'longitude': _longitude.toString(),
            };
            if (_password.text.isNotEmpty) {
              form['password'] = _password.text;
            }
            widget.id != null ? update(form) : save(form);
          }
        },
        tooltip: widget.id == null ? 'Save' : 'Edit',
        child: const Icon(Icons.check),
      ),
    );
  }

  save(form) async {
    await UserService().create(form).then((response) {
      String text = "";
      if (response == "409") {
        text = "Name, email or password already exist";
      } else if (response == "422") {
        text = "Invalid email";
      } else if (response == "200") {
        Navigator.pop(context);
        text = '${_name.text} updated';
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Center(
            child: Text(text),
          ),
          duration: const Duration(seconds: 6),
        ),
      );
    }).catchError((error) {
      debugPrint(error.toString());
    });
  }

  update(form) async {
    await UserService().update(widget.id, form).then((response) {
      String text = "";
      if (response == "409") {
        text = "Name, email or password already exist";
      } else if (response == "422") {
        text = "Invalid email";
      } else if (response == "200") {
        Navigator.pop(context);
        text = '${_name.text} updated';
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Center(
            child: Text(text),
          ),
          duration: const Duration(seconds: 6),
        ),
      );
    }).catchError((error) {
      debugPrint(error.toString());
    });
  }
}
