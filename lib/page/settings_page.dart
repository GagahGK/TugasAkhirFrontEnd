import 'package:flutter/material.dart';
import 'package:futurebuilder_example/api/deviceAPI.dart';

// Define a custom Form widget.
class SettingsPage extends StatefulWidget {
  @override
  SettingsPageState createState() {
    return SettingsPageState();
  }
}

class SettingsPageState extends State<SettingsPage> {
  final myController = TextEditingController();
  final GlobalKey<SettingsPageState> key = new GlobalKey();
  String var1 = 'text1';
  void dispose() {
    myController.dispose();
    super.dispose();
  }

  getText() {
    return myController.text;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Retrieve Text Input'),
      // ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              key: settingsKey,
              controller: myController,
              decoration: InputDecoration(
                  hintText: 'Enter API Endpoint URL',
                  border: OutlineInputBorder()),
            ),
          ),
          ElevatedButton(
              onPressed: () {
                setState(() {
                  var1 = myController.text;
                });
              },
              child: Text('Apply URL'))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        // When the user presses the button, show an alert dialog containing
        // the text that the user has entered into the text field.
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                // Retrieve the text the that user has entered by using the
                // TextEditingController.
                content: Text(myController.text),
              );
            },
          );
        },
        tooltip: 'Show me the value!',
        child: Icon(Icons.text_fields),
      ),
    );
  }
}
