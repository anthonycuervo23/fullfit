import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/rendering.dart';
import 'package:fullfit_app/domain/datasources/datasources.dart';
import 'package:fullfit_app/domain/entities/entities.dart';
import 'package:fullfit_app/infrastructure/mappers/mappers.dart';
import 'package:package_info_plus/package_info_plus.dart';

class PersonDatasourceImpl extends PersonDatasource {
  static final PersonDatasourceImpl _singleton =
      PersonDatasourceImpl._internal();

  factory PersonDatasourceImpl() {
    return _singleton;
  }

  PersonDatasourceImpl._internal() {
    checkLoggedUser();
  }

  Person? _person;
  User? _loggedUser;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  @override
  bool get isUserLogged => _loggedUser != null;

  @override
  Future<bool> checkUserDocumentExists() async {
    if (!isUserLogged) {
      return Future.value(false);
    }

    try {
      final DocumentReference<Map<String, dynamic>> userDocRef =
          _firestore.collection('users').doc(_loggedUser!.uid);
      final DocumentSnapshot<Map<String, dynamic>> userDoc =
          await userDocRef.get();
      return userDoc.exists;
    } catch (e) {
      debugPrint(e.toString());
      return Future.value(false);
    }
  }

  @override
  Future<void> saveUserData(Map<String, dynamic> personLike) async {
    checkLoggedUser();
    if (!isUserLogged) {
      debugPrint('No se ha podido obtener el usuario logueado');
      throw Exception('No se ha podido obtener el usuario logueado');
    }

    try {
      final Map<String, dynamic> currentDevice = await getCurrentDeviceInfo();
      personLike['devices'] = [currentDevice];

      personLike['photo_URL'] =
          await _uploadImageToFirebaseStorage(personLike['photo_URL'] ?? '');

      // Agregar o actualizar datos del usuario en Firestore
      DocumentReference userDoc =
          _firestore.collection('users').doc(_loggedUser!.uid);
      await userDoc.set(personLike);
    } catch (e) {
      debugPrint(e.toString());
      throw Exception(e);
    }
  }

  @override
  Future<void> getUserData({String? userId}) async {
    checkLoggedUser();
    try {
      if (!isUserLogged) {
        throw Exception('No se ha podido obtener el usuario logueado');
      }

      final Map<String, dynamic> currentDevice = await getCurrentDeviceInfo();

      // Obtenemos la información del usuario
      final DocumentReference<Map<String, dynamic>> userDocRef =
          _firestore.collection('users').doc(_loggedUser!.uid);
      final DocumentSnapshot<Map<String, dynamic>> userDoc =
          await userDocRef.get();
      // Verifica si el dispositivo ya existe en la lista
      List devices = userDoc.data()?['devices'] ?? [];
      int index = devices
          .indexWhere((device) => device['device'] == currentDevice['device']);

      if (index != -1) {
        // El dispositivo ya existe, actualiza la información de ese dispositivo
        devices[index] = currentDevice;
      } else {
        // El dispositivo es nuevo, añádelo a la lista
        devices.add(currentDevice);
      }

      await userDocRef.update({
        'devices': devices,
        'last_login': FieldValue.serverTimestamp(),
      });

      //obtenemos el ususario actualizado con la informacion del dispositivo
      final DocumentSnapshot<Map<String, dynamic>> newUserDoc =
          await userDocRef.get();
      // mapeamos la respuesta a la entidad
      _person = PersonMapper.firestoreUserToEntity(newUserDoc);
      // }
    } catch (e) {
      debugPrint(e.toString());
      _person = null;
      throw Exception(e);
    }
  }

  @override
  Person? get person => _person;
}

extension PersonDataSourceExtension on PersonDatasourceImpl {
  Future<void> checkLoggedUser() async {
    try {
      _loggedUser = _firebaseAuth.currentUser;
    } catch (e) {
      _loggedUser = null;
    }
  }

  Future<Map<String, dynamic>> getCurrentDeviceInfo() async {
    try {
      // Obtén la información del dispositivo
      final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();

      String osVersion = '';
      String model = '';
      if (Platform.isIOS) {
        final info = await deviceInfoPlugin.iosInfo;
        osVersion = '${info.systemName} ${info.systemVersion}';
        model = info.name;
      } else {
        final info = await deviceInfoPlugin.androidInfo;
        osVersion = info.version.release;
        model = '${info.brand} ${info.model}';
      }

      // Obtén la información de la aplicación
      final PackageInfo packageInfo = await PackageInfo.fromPlatform();

      return {
        'appVersion': '${packageInfo.version}+${packageInfo.buildNumber}',
        'osVersion': osVersion,
        'device': model,
      };
    } catch (e) {
      debugPrint(e.toString());
      throw Exception(e);
    }
  }

  //upload image to firebase storage
  Future<String?> _uploadImageToFirebaseStorage(String profilePic) async {
    User? user = _firebaseAuth.currentUser;
    if (user == null) {
      return null;
    }

    try {
      late Uint8List list;
      // Si la imagen es un activo, se carga como un ByteData
      if (profilePic.startsWith('assets/')) {
        final ByteData bytes = await rootBundle.load(profilePic);
        list = bytes.buffer.asUint8List();
      }
      // Si la imagen es un archivo del sistema de archivos, se carga como un archivo
      else {
        File file = File(profilePic);
        list = await file.readAsBytes();
      }

      String imagePath = 'user_profile_images/${user.uid}/${user.uid}.jpg';
      // Utiliza putData para cargar la imagen
      UploadTask uploadTask = _storage.ref(imagePath).putData(list);
      TaskSnapshot snapshot = await uploadTask;
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }
}
