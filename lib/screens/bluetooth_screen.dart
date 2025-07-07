import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import '../services/bluetooth_service.dart';

/**
 * @author Juan De Dios Mendoza Peinado
 * * @abstract
 * Pantalla para escanear y conectarse a dispositivos Bluetooth.
 * Muestra una lista de dispositivos encontrados y permite al usuario
 * seleccionar uno para establecer una conexión.
 * * @param bluetoothService Instancia del servicio de Bluetooth para manejar la lógica de conexión.
 */
class BluetoothScreen extends StatefulWidget {
  final AppBluetoothService bluetoothService;
  
  const BluetoothScreen({Key? key, required this.bluetoothService}) : super(key: key);

  @override
  _BluetoothScreenState createState() => _BluetoothScreenState();
}

/**
 * @abstract
 * Gestiona el estado de la pantalla Bluetooth, incluyendo el inicio y la detención
 * del escaneo de dispositivos.
 */
class _BluetoothScreenState extends State<BluetoothScreen> {
  /**
   * @abstract
   * Inicia el escaneo de dispositivos Bluetooth cuando se carga la pantalla.
   */
  @override
  void initState() {
    super.initState();
    widget.bluetoothService.startScan();
  }

  /**
   * @abstract
   * Detiene el escaneo de dispositivos Bluetooth cuando la pantalla se destruye
   * para liberar recursos.
   */
  @override
  void dispose() {
    widget.bluetoothService.stopScan();
    super.dispose();
  }

  /**
   * @abstract
   * Construye la interfaz de usuario de la pantalla de Bluetooth.
   * Utiliza un StreamBuilder para mostrar el estado del escaneo y la lista de
   * dispositivos encontrados en tiempo real.
   * * @return Un widget Scaffold que contiene la UI de la pantalla.
   */
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Conectar Dispositivo'),
        actions: [
          StreamBuilder<bool>(
            stream: FlutterBluePlus.isScanning,
            initialData: false,
            builder: (c, snapshot) {
              if (snapshot.data ?? false) {
                return IconButton(
                  icon: const Icon(Icons.stop),
                  onPressed: () => widget.bluetoothService.stopScan(),
                );
              } else {
                return IconButton(
                  icon: const Icon(Icons.replay),
                  onPressed: () => widget.bluetoothService.startScan(),
                );
              }
            },
          ),
        ],
      ),
      body: StreamBuilder<List<ScanResult>>(
        stream: widget.bluetoothService.scanResults,
        initialData: const [],
        builder: (c, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final results = snapshot.data ?? [];
          return ListView.builder(
            itemCount: results.length,
            itemBuilder: (context, index) {
              ScanResult r = results[index];
              String deviceName = r.device.platformName.isEmpty 
                  ? "Dispositivo Desconocido" 
                  : r.device.platformName;
              
              if (deviceName == "Dispositivo Desconocido") return const SizedBox.shrink();

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: ListTile(
                  title: Text(deviceName),
                  subtitle: Text(r.device.remoteId.toString()),
                  leading: const Icon(Icons.bluetooth),
                  onTap: () async {
                    await widget.bluetoothService.connectToDevice(r.device);
                    if(mounted) Navigator.pop(context);
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}