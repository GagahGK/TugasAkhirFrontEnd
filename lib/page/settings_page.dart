import 'package:flutter/material.dart';

// Define a custom Form widget.
class SettingsPage extends StatefulWidget {
  @override
  SettingsPageState createState() {
    return SettingsPageState();
  }
}

// Define a corresponding State class.
// This class holds data related to the form.
class SettingsPageState extends State<SettingsPage> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a `GlobalKey<FormState>`,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          TextFormField(
            // The validator receives the text that the user has entered.
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }
}
