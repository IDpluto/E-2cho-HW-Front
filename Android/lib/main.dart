import 'package:e_2cho/views/device_selection_page.dart';
import 'package:e_2cho/views/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'controllers/bluetooth_controller.dart';
import 'views/welcome_screen.dart';
import 'views/welcome_check_screen.dart';
import 'views/finding_device_screen.dart';
import 'views/device_confirmation_screen.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  FlutterBluePlus.setLogLevel(LogLevel.verbose, color : true);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => BluetoothController(),
      child: MaterialApp(
        title: 'E2cho App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => const WelcomeScreen(),
          '/welcome_check': (context) => WelcomeCheckScreen(
              nickname: ModalRoute.of(context)!.settings.arguments as String),
          '/finding': (context) => const BluetoothAdapterStateObserver(),
          '/find_and_select': (context) => const DeviceSelectionPage(),
          '/confirmation': (context) => const DeviceConfirmationScreen(),
          '/HomeScreen': (context) => const HomeScreen(),
        },
      ),
    );
  }
}

class BluetoothAdapterStateObserver extends StatelessWidget {
  const BluetoothAdapterStateObserver({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<BluetoothAdapterState>(
      stream: FlutterBluePlus.adapterState,
      initialData: BluetoothAdapterState.unknown,
      builder: (c, snapshot) {
        final adapterState = snapshot.data;
        if (adapterState == BluetoothAdapterState.on) {
          return const FindingDeviceScreen();
        }
        return BluetoothOffScreen(adapterState: adapterState);
      },
    );
  }
}

class BluetoothOffScreen extends StatelessWidget {
  const BluetoothOffScreen({super.key, required this.adapterState});

  final BluetoothAdapterState? adapterState;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Icon(
              Icons.bluetooth_disabled,
              size: 200.0,
              color: Colors.white54,
            ),
            Text(
              'Bluetooth Adapter is ${adapterState != null ? adapterState.toString().substring(21).toUpperCase() : 'not available'}.',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
