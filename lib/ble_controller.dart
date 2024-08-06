import 'dart:developer';

import 'package:flutter_blue/flutter_blue.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:permission_handler/permission_handler.dart';

class BleController extends GetxController {
  FlutterBlue ble = FlutterBlue.instance;

  Future scanBlueDevices() async {
    if (await Permission.bluetoothScan.request().isGranted) {
      if (await Permission.bluetoothConnect.request().isGranted) {
        ble.startScan(timeout: Duration(seconds: 30));

        ble.stopScan();
      }
    }
  }

  Stream<List<ScanResult>> get scanResults => ble.scanResults;

  Future<void> connectToDevice(BluetoothDevice device) async {
    log('devices details ${device.toString()}');
    await device.connect(timeout: Duration(seconds: 15));
    device.state.listen(
      (event) {
        if (event == BluetoothDeviceState.connected) {
          log('device connected');
        } else {
          log('device disconnected');
        }
      },
    );
  }
}
