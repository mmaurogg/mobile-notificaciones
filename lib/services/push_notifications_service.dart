
// SHA1: BE:19:62:34:C1:52:8A:5B:07:6D:82:BE:05:6A:62:87:83:6A:8D:E8

import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class PushNotificationsService {

  static FirebaseMessaging messaging = FirebaseMessaging.instance;
  static String? token;

  // lo que se emitirá para ser oido en el initState del main
  static StreamController<String> _messageStream = StreamController.broadcast();

  static Stream<String> get messageStream => _messageStream.stream;

  static Future _onBackgroundHandler( RemoteMessage message) async {
    print('onBackgroundHandler handler ${ message.messageId}');
    print(message.data);
    _messageStream.add( message.data['producto'] ?? 'no data' );
  }

  static Future _onMessageHandler( RemoteMessage message) async {
    print('onMessageHandler handler ${ message.messageId}');
    print(message.data);
    _messageStream.add( message.data['producto'] ?? 'no data' );
  }

  static Future _onMessageOpenHandler( RemoteMessage message) async {
    print('onMessageOpenHandler handler ${ message.messageId}');
    print(message.data);
    _messageStream.add( message.data['producto'] ?? 'no data' );
  }

  static Future initializeApp() async {

    //push notifications (inicializa firebase)
    await Firebase.initializeApp();
    await requestPermission();

    token = await messaging.getToken();
    print('Token: $token');

    //Handlers
    FirebaseMessaging.onBackgroundMessage(_onBackgroundHandler);
    FirebaseMessaging.onMessage.listen(_onMessageHandler);
    FirebaseMessaging.onMessageOpenedApp.listen(_onMessageOpenHandler);

  }

  //Permisis de enviar mensajes
  static requestPermission() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    print('User push notification status ${ settings.authorizationStatus }');
  }

  //no la usaremos pero se dejará en caso que se requiera cerrar
  static closeStreams(){
    _messageStream.close();
  }


}