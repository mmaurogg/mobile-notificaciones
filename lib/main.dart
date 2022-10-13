import 'package:flutter/material.dart';
import 'package:notificaciones_app/screens/screens.dart';
import 'package:notificaciones_app/services/services.dart';

void main() async {

  // metodo para asegurar que arme el widget para ejecutar la sgte fn
  WidgetsFlutterBinding.ensureInitialized();
  await PushNotificationsService.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  //Keys que guardan la referencia almacenada para ponerla despues de crear el widget
  final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();
  final GlobalKey<ScaffoldMessengerState> messengerKey = new GlobalKey<ScaffoldMessengerState>();

  @override
  void initState() {
    // con esto tengo acceso al contexto
    super.initState();


    PushNotificationsService.messageStream.listen((message) {
      //print('MyApp: $message');

      navigatorKey.currentState?.pushNamed('message', arguments: message);

      final snackBar = SnackBar( content: Text(message) );
      messengerKey.currentState?.showSnackBar( snackBar );
    });

  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Material App',
      initialRoute: 'home',
      navigatorKey: navigatorKey, //key para navegar
      scaffoldMessengerKey: messengerKey, //Key para mostrar snaks
      routes: {
        'home': (_) => HomeScreen(),
        'message': (_) => MessageScreen(),

      },
    );
  }
}
