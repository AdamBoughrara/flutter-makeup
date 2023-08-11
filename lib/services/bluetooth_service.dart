import 'package:flutter_blue/flutter_blue.dart';

class MyBluetoothService {
  FlutterBlue _flutterBlue = FlutterBlue.instance;
  BluetoothDevice? _connectedDevice;

  Future<void> startDeviceScan() async {
    _flutterBlue.startScan(timeout: Duration(seconds: 4));
  }

  Stream<List<ScanResult>> getDeviceStream() {
    return _flutterBlue.scanResults;
  }

  Future<void> stopDeviceScan() async {
    _flutterBlue.stopScan();
  }

  Future<bool> connectToDevice(BluetoothDevice device) async {
    try {
      await device.connect();
      _connectedDevice = device;
      return true;
    } catch (e) {
      print("Error connecting to the device: $e");
      return false;
    }
  }

  void disconnectFromDevice() {
    if (_connectedDevice != null && _connectedDevice!.state == BluetoothDeviceState.connected) {
      _connectedDevice!.disconnect();
    }
  }

  bool get isDeviceConnected {
    return _connectedDevice != null && _connectedDevice!.state == BluetoothDeviceState.connected;
  }

  Future<void> sendData(List<int> data, String characteristicUuid) async {
    if (_connectedDevice == null || _connectedDevice!.state != BluetoothDeviceState.connected) {
      print("Error: Device is not connected.");
      return;
    }

    List<BluetoothService> services = await _connectedDevice!.discoverServices();
    BluetoothCharacteristic? characteristic;

    // Find the desired characteristic from the discovered services
    for (BluetoothService service in services) {
      List<BluetoothCharacteristic> characteristics = service.characteristics;
      for (BluetoothCharacteristic c in characteristics) {
        if (c.uuid.toString().toUpperCase() == characteristicUuid.toUpperCase()) {
          characteristic = c;
          break;
        }
      }
      if (characteristic != null) {
        break;
      }
    }

    if (characteristic == null) {
      print("Error: Characteristic not found.");
      return;
    }

    try {
      await characteristic.write(data);
    } catch (e) {
      print("Error sending data: $e");
    }
  }
}
