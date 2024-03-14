import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class DevicePage extends StatefulWidget {
  final BluetoothDevice device;

  const DevicePage({super.key, required this.device});

  @override
  State<DevicePage> createState() => _DevicePageState();
}

class _DevicePageState extends State<DevicePage> {
  bool isConnected = false;
  String deviceName = '';
  String deviceId = '';

  @override
  void initState() {
    deviceName = widget.device.advName;
    deviceId = widget.device.remoteId.toString();
    super.initState();
  }

  @override
  void dispose() {
    disconnectFromDevice(widget.device);
    super.dispose();
  }

  Future<void> connectToDevice(BluetoothDevice device) async {
    try {
      // Connect to the device
      await device.connect();

      // Verify the connection is successful
      if (device.isConnected) {
        if (kDebugMode) {
          print('Connected to ${device.advName}');
        }
        setState(() {
          isConnected = true;
        });
      } else if (device.isDisconnected) {
        if (kDebugMode) {
          print('Disconnected to ${device.advName}');
        }
        setState(() {
          isConnected = false;
        });
      } else {
        if (kDebugMode) {
          print('Failed to connect to ${device.advName}');
        }
      }
    } catch (e) {
      // Handle connection errors
      if (kDebugMode) {
        print('Failed to connect to ${device.advName}: $e');
      }
    }
  }

  Future<void> disconnectFromDevice(BluetoothDevice device) async {
    try {
      // Disconnect from the device
      await device.disconnect();

      // Verify the disconnection is successful
      if (device.isDisconnected) {
        if (kDebugMode) {
          print('Disconnected from ${device.advName}');
        }
        setState(() {
          isConnected = false;
        });
      } else {
        if (kDebugMode) {
          print('Failed to disconnect from ${device.advName}');
        }
      }
    } catch (e) {
      // Handle disconnection errors
      if (kDebugMode) {
        print('Failed to disconnect from ${device.advName}: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.shade200,
        title: const Text('Device Page', style: TextStyle(color: Colors.white)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const SizedBox(height: 20),
            Text(
              'Device Name: ${widget.device.advName}\nDevice ID: ${widget.device.remoteId.toString()}',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            RichText(
              text: TextSpan(
                text: 'Connection Status : ',
                style: const TextStyle(color: Colors.black, fontSize: 18),
                children: <TextSpan>[
                  TextSpan(
                    text: isConnected ? 'Connected' : 'Disconnected',
                    style: TextStyle(
                      color: isConnected ? Colors.green : Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                ElevatedButton(
                  onPressed: () => connectToDevice(widget.device),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.green, // foreground
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          20), // if you need to have border radius
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 50,
                        vertical:
                            20), // if you need to increase the button width and height
                  ),
                  child: const Text('Connect'),
                ),
                ElevatedButton(
                  onPressed: () => disconnectFromDevice(widget.device),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.red, // foreground
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          20), // if you need to have border radius
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical:
                            20), // if you need to increase the button width and height
                  ),
                  child: const Text('Disconnect'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
