import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
// Importamos el paquete con un alias 'fb' para evitar conflictos de nombres
import 'package:flutter_blue_plus/flutter_blue_plus.dart' as fb;

// Renombramos la clase para que sea única
class AppBluetoothService {
  // Stream para notificar sobre el estado de la conexión
  final StreamController<fb.BluetoothDevice?> _connectionStatusController = StreamController.broadcast();
  Stream<fb.BluetoothDevice?> get connectionStream => _connectionStatusController.stream;

  // Stream para recibir datos del dispositivo
  final StreamController<String> _dataStreamController = StreamController.broadcast();
  Stream<String> get dataStream => _dataStreamController.stream;
  
  fb.BluetoothDevice? _connectedDevice;
  StreamSubscription<List<int>>? _dataSubscription;

  // Iniciar escaneo de dispositivos
  Stream<List<fb.ScanResult>> get scanResults => fb.FlutterBluePlus.scanResults;

  Future<void> startScan() async {
    if (await fb.FlutterBluePlus.isSupported == false) {
      debugPrint("Bluetooth no es soportado por este dispositivo.");
      return;
    }
    await fb.FlutterBluePlus.adapterState.where((s) => s == fb.BluetoothAdapterState.on).first;
    await fb.FlutterBluePlus.startScan(timeout: const Duration(seconds: 5));
  }

  Future<void> stopScan() async {
    await fb.FlutterBluePlus.stopScan();
  }

  // Conectar a un dispositivo
  Future<void> connectToDevice(fb.BluetoothDevice device) async {
    try {
      await device.connect(autoConnect: false);
      _connectedDevice = device;
      _connectionStatusController.add(device);
      await _discoverServicesAndListen();
      stopScan();
    } catch (e) {
      debugPrint("Error al conectar: $e");
      _connectionStatusController.add(null);
    }
  }

  // Desconectar del dispositivo
  Future<void> disconnect() async {
    await _dataSubscription?.cancel();
    await _connectedDevice?.disconnect();
    _connectedDevice = null;
    _dataSubscription = null;
    _connectionStatusController.add(null);
  }

  // Descubrir servicios y suscribirse a la característica para recibir datos
  Future<void> _discoverServicesAndListen() async {
    if (_connectedDevice == null) return;

    // Aquí usamos el alias 'fb.BluetoothService' para referirnos a la clase del paquete
    List<fb.BluetoothService> services = await _connectedDevice!.discoverServices();
    for (var service in services) {
      for (var characteristic in service.characteristics) {
        if (characteristic.properties.notify) {
          try {
            await characteristic.setNotifyValue(true);
            _dataSubscription = characteristic.value.listen((value) {
              String data = utf8.decode(value, allowMalformed: true);
              if (data.isNotEmpty) {
                _dataStreamController.add(data);
              }
            });
            return; // Salimos después de suscribirnos exitosamente
          } catch (e) {
            debugPrint("Error al suscribirse a la característica: $e");
          }
        }
      }
    }
  }
  
  // Para liberar recursos
  void dispose() {
    _connectionStatusController.close();
    _dataStreamController.close();
    disconnect();
  }
}
