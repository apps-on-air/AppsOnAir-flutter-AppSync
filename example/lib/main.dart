import 'package:flutter/material.dart';

import 'package:appsonair_flutter_appsync/app_sync_service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // Platform messages are asynchronous, so we initialize in an async method.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: const DemoApp(),
      ),
    );
  }
}

class DemoApp extends StatefulWidget {
  const DemoApp({super.key});

  @override
  State<DemoApp> createState() => _DemoAppState();
}

class _DemoAppState extends State<DemoApp> {
  @override
  void initState() {
    AppSyncService.sync(
      context,

      ///use customWidget only if you want to use Your custom UI,
      ///make sure to pass false in param [showNativeUI]
      options: {'showNativeUI': false},
      customWidget: (response) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Application Name : ${response["appName"]}"),
            Text(
              "Application Version : ${response["updateData"]["buildNumber"]}",
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {},
              child: const Text('Update'),
            ),
          ],
        );
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(),
    );
  }
}
