import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'views/ble_service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MainApp());
}

final GlobalKey<NavigatorState> appNavigatorKey = GlobalKey<NavigatorState>();

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      builder: (context, child) => MaterialApp(
        navigatorKey: appNavigatorKey,
        debugShowCheckedModeBanner: false,
        theme: ThemeData.light(useMaterial3: true),
        home: Scaffold(
          appBar: AppBar(
            title: const Text("Scan Ble Devices"),
            centerTitle: true,
            backgroundColor: Colors.blue.shade200,
          ),
          body: Center(
            child: ElevatedButton(
              child: const Text("Go To BLE Scan Page"),
              onPressed: () {
                Navigator.of(appNavigatorKey.currentContext!).push(
                    MaterialPageRoute(
                        builder: (context) => const BleDevices()));
              },
            ),
          ),
        ),
      ),
    );
  }
}
