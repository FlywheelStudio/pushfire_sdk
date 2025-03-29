import 'package:flutter/material.dart';
import 'package:pushfire_sdk/pushfire_sdk.dart';

void main() {
  PushfireSDK.initialize(apiKey: "test_api_key");
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text("PushfireSDK Example")),
        body: Center(
          child: ElevatedButton(
            onPressed: () {
              PushfireSDK.trackEvent("push_opened", "user_123");
            },
            child: Text("Track Push Notification Event"),
          ),
        ),
      ),
    );
  }
}
