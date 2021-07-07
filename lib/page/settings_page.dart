import 'package:flutter/material.dart';
import 'package:futurebuilder_example/api/settingPreferences.dart';

// Define a custom Form widget.
class SettingsPage extends StatefulWidget {
  @override
  SettingsPageState createState() {
    return SettingsPageState();
  }
}

class SettingsPageState extends State<SettingsPage> {
  final myController = TextEditingController();
  void dispose() {
    myController.dispose();
    super.dispose();
  }

  getText() {
    return myController.text;
  }

  @override
  Widget build(BuildContext context) => Scaffold(
          body: FutureBuilder<SettingsPreferences>(
        future: SettingsPreferences.getSettings(),
        builder: (context, snapshot) {
          final settings = snapshot.data;
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Center(child: CircularProgressIndicator());
            default:
              if (snapshot.hasError) {
                return Center(child: Text('error ${snapshot.error}'));
              } else {
                myController.text = settings.uri;
                return buildForm(settings);
              }
          }
        },
      ));

  Widget buildForm(SettingsPreferences settingsData) => Scaffold(
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: myController,
                decoration: InputDecoration(
                    hintText: 'Enter API Endpoint URL',
                    border: OutlineInputBorder()),
              ),
            ),
            ElevatedButton(
                onPressed: () async {
                  await SettingsPreferences.applyFormUri(myController.text);
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
