import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
// Importamos el paquete con un alias 'fb' para evitar conflictos de nombres
import 'package:flutter_blue_plus/flutter_blue_plus.dart' as fb;

/**
 * @author Juan De Dios Mendoza Peinado
 */

/**
 * @abstract Maneja las operaciones de Bluetooth de bajo consumo (BLE).
 * @package services
 * @access public
 * * @class AppBluetoothService
 * @abstract Gestiona el escaneo, la conexión, la desconexión y la comunicación
 * con dispositivos BLE. Utiliza el paquete flutter_blue_plus para la funcionalidad BLE.
 */
class AppBluetoothService {
  /**
   * @var _connectionStatusController
   * @abstract Controlador de stream para notificar cambios en el estado de la conexión BLE.
   * @access private
   */
  final StreamController<fb.BluetoothDevice?> _connectionStatusController = StreamController.broadcast();
  
  /**
   * @return Stream<fb.BluetoothDevice?>
   * @abstract Stream que emite el dispositivo conectado o null si no hay conexión.
   */
  Stream<fb.BluetoothDevice?> get connectionStream => _connectionStatusController.stream;

  /**
   * @var _dataStreamController
   * @abstract Controlador de stream para los datos recibidos del dispositivo BLE.
   * @access private
   */
  final StreamController<String> _dataStreamController = StreamController.broadcast();

  /**
   * @return Stream<String>
   * @abstract Stream que emite los datos recibidos del dispositivo como una cadena de texto.
   */
  Stream<String> get dataStream => _dataStreamController.stream;
  
  /**
   * @var _connectedDevice
   * @abstract Almacena la instancia del dispositivo Bluetooth actualmente conectado.
   * @access private
   */
  fb.BluetoothDevice? _connectedDevice;

  /**
   * @var _dataSubscription
   * @abstract Suscripción al stream de datos de una característica BLE para recibir notificaciones.
   * @access private
   */
  StreamSubscription<List<int>>? _dataSubscription;

  /**
   * @return Stream<List<fb.ScanResult>>
   * @abstract Expone los resultados del escaneo de dispositivos BLE en tiempo real.
   */
  Stream<List<fb.ScanResult>> get scanResults => fb.FlutterBluePlus.scanResults;

  /**
   * @abstract Inicia el escaneo de dispositivos BLE cercanos.
   * @return Future<void>
   * @access public
   * @param timeout Duración del escaneo.
   */
  Future<void> startScan() async {
    if (await fb.FlutterBluePlus.isSupported == false) {
      debugPrint("Bluetooth no es soportado por este dispositivo.");
      return;
    }
    await fb.FlutterBluePlus.adapterState.where((s) => s == fb.BluetoothAdapterState.on).first;
    await fb.FlutterBluePlus.startScan(timeout: const Duration(seconds: 5));
  }

  /**
   * @abstract Detiene el escaneo de dispositivos BLE.
   * @return Future<void>
   * @access public
   */
  Future<void> stopScan() async {
    await fb.FlutterBluePlus.stopScan();
  }

  /**
   * @abstract Se conecta a un dispositivo BLE específico.
   * @param device El dispositivo al que se va a conectar.
   * @return Future<void>
   * @access public
   */
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

  /**
   * @abstract Se desconecta del dispositivo BLE actualmente conectado.
   * @return Future<void>
   * @access public
   */
  Future<void> disconnect() async {
    await _dataSubscription?.cancel();
    await _connectedDevice?.disconnect();
    _connectedDevice = null;
    _dataSubscription = null;
    _connectionStatusController.add(null);
  }

  /**
   * @abstract Descubre los servicios y características del dispositivo conectado y se suscribe a las notificaciones.
   * @return Future<void>
   * @access private
   */
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
  
  /**
   * @abstract Libera los recursos utilizados por el servicio.
   * @access public
   */
  void dispose() {
    _connectionStatusController.close();
    _dataStreamController.close();
    disconnect();
  }
}