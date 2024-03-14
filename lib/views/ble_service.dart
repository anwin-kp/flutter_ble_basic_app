import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

import '../main.dart';
import 'custome_ble_page.dart';

class BleDevices extends StatefulWidget {
  const BleDevices({super.key});

  @override
  State<BleDevices> createState() => _BleDevicesState();
}

class _BleDevicesState extends State<BleDevices> {
  List<ScanResult> devices = [];
  bool isScanning = false;

  @override
  void initState() {
    super.initState();

    startScan();
  }

  @override
  void dispose() {
    FlutterBluePlus.stopScan();
    super.dispose();
  }

  startScan() async {
    setState(() {
      isScanning = true; // Set isScanning to true at the start of the scan
    });

    if (await FlutterBluePlus.isSupported == false) {
      if (kDebugMode) {
        print("Bluetooth not supported by this device");
      }
      return;
    }
    devices.clear();
    // Wait for Bluetooth enabled & permission granted
    await FlutterBluePlus.adapterState
        .where((val) => val == BluetoothAdapterState.on)
        .first;

    // Start scanning w/ timeout
    await FlutterBluePlus.startScan(
      timeout: const Duration(seconds: 15),
    );

    // Listen to scan results
    var subscription = FlutterBluePlus.onScanResults.listen(
      (results) {
        if (results.isNotEmpty) {
          ScanResult r = results.last; // the most recently found device
          if (kDebugMode) {
            print(
                '${r.device.remoteId}: "${r.advertisementData.advName}" found!');
          }
          setState(() {
            if (r.device.advName.isNotEmpty) {
              devices.add(r);
            }
          });
        }
      },
      onError: (e) => debugPrint(e),
    );

    // Cleanup: cancel subscription when scanning stops
    FlutterBluePlus.cancelWhenScanComplete(subscription);

    // Wait for scanning to stop
    await FlutterBluePlus.isScanning.where((val) => val == false).first;

    setState(() {
      isScanning = false; // Set isScanning to false when the scan is complete
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.shade200,
        title: const Text('BLE Devices'),
      ),
      body: AbsorbPointer(
        absorbing: isScanning,
        child: Stack(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: ListView.builder(
                itemCount: devices.length,
                itemBuilder: (context, index) {
                  return SizedBox(
                    width: double.infinity,
                    height: 60,
                    child: Card(
                      elevation: 2.0,
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: ListTile(
                        dense: true,
                        visualDensity: VisualDensity.compact,
                        leading: const Icon(Icons.bluetooth,
                            size: 20.0, color: Colors.blue),
                        title: Text(
                          devices[index].device.advName.isEmpty
                              ? 'Unknown'
                              : devices[index].device.advName,
                          style: const TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          devices[index].device.remoteId.toString(),
                          style: TextStyle(
                            fontSize: 12.0,
                            color: Colors.grey[700],
                          ),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            StreamBuilder<List<ScanResult>>(
                              stream: FlutterBluePlus.scanResults,
                              builder: (BuildContext context,
                                  AsyncSnapshot<List<ScanResult>> snapshot) {
                                if (snapshot.hasData) {
                                  return CircleAvatar(
                                    radius: 15,
                                    backgroundColor: Colors.blue,
                                    child: Text(
                                      snapshot.data![index].rssi.toString(),
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 12),
                                    ),
                                  );
                                } else {
                                  return const CircularProgressIndicator();
                                }
                              },
                            ),
                            const SizedBox(width: 10),
                            GestureDetector(
                              onTap: () {
                                Navigator.of(appNavigatorKey.currentContext!)
                                    .push(
                                  MaterialPageRoute(
                                    builder: (context) => DevicePage(
                                      device: devices[index].device,
                                    ),
                                  ),
                                );
                              },
                              child: const Icon(
                                Icons.arrow_forward_ios,
                                color: Colors.blue,
                                size: 18,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            if (isScanning)
              const Center(
                child: CircularProgressIndicator(),
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: startScan,
        child: const Icon(Icons.search),
      ),
    );
  }
}
