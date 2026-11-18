import 'package:appsonair_flutter_appsync/app_sync_service.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AppSync Example',
      theme: ThemeData(
        colorSchemeSeed: const Color(0xFF6200EE),
        useMaterial3: true,
      ),
      home: const DemoApp(),
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
    super.initState();
    // Default — shows the native AppsOnAir update / maintenance UI
    AppSyncService.sync(context);

    // ── Custom UI (optional) ─────────────────────────────────────────────
    // Set showNativeUI: false to disable the default AppsOnAir alert.
    // Provide customWidget to render your own update/maintenance UI.
    // The `response` map contains app info returned by the SDK:
    //   response["appName"]                    → app display name
    //   response["updateData"]["buildNumber"]  → latest available build
    // ─────────────────────────────────────────────────────────────────────
    // AppSyncService.sync(
    //   context,
    //   options: {'showNativeUI': false}, // required when using customWidget
    //   customWidget: (response) {
    //     return Column(
    //       mainAxisSize: MainAxisSize.min,
    //       children: [
    //         Text('App: ${response["appName"]}'),
    //         Text('Version: ${response["updateData"]["buildNumber"]}'),
    //         const SizedBox(height: 20),
    //         ElevatedButton(
    //           onPressed: () {}, // handle update action here
    //           child: const Text('Update'),
    //         ),
    //       ],
    //     );
    //   },
    // );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AppSync Example')),
      body: const Center(
        child: Text('AppSync is active.\nShake or force update to test.'),
      ),
    );
  }
}
