import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/rendering.dart';
import 'package:fullfit_app/domain/datasources/datasources.dart';
import 'package:fullfit_app/domain/entities/entities.dart';
import 'package:fullfit_app/infrastructure/mappers/mappers.dart';
import 'package:fullfit_app/infrastructure/services/services.dart';
import 'package:package_info_plus/package_info_plus.dart';

class PersonDatasourceImpl extends PersonDatasource {
  static final PersonDatasourceImpl _singleton =
      PersonDatasourceImpl._internal();

  factory PersonDatasourceImpl() {
    return _singleton;
  }

  PersonDatasourceImpl._internal();

  Person? _person;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  Future<void> getUserData({String? userId}) async {
    String? id = userId;
    User? user;
    try {
      if (userId == null) {
        user = _firebaseAuth.currentUser;
        if (user == null) {
          throw Exception('No se ha podido obtener el usuario logueado');
        }
        id = user.uid;
      }

      final Map<String, dynamic> currentDevice = await getCurrentDeviceInfo();

      // Obtenemos la información del usuario
      final DocumentReference<Map<String, dynamic>> userDocRef =
          _firestore.collection('users').doc(id);
      final DocumentSnapshot<Map<String, dynamic>> userDoc =
          await userDocRef.get();

      if (!userDoc.exists) {
        // El usuario no existe en la base de datos, crea un nuevo documento para el usuario
        await userDocRef.set({
          'name': user?.displayName?.split(' ')[0],
          'lastname': user?.displayName?.split(' ')[1],
          'email': user?.email,
          'photoUrl': user?.photoURL,
          'height': 0,
          'weight': 0.0,
          'age': 0,
          'gender': null,
          'login_type': KeyValueStorageServiceImplementation()
              .getValue<String>(loginTypeKey),
          'createdAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
          'devices': [currentDevice],
        });
      } else {
        // El usuario existe, verifica si el dispositivo ya existe en la lista
        List devices = userDoc.data()?['devices'] ?? [];
        int index = devices.indexWhere(
            (device) => device['device'] == currentDevice['device']);

        if (index != -1) {
          // El dispositivo ya existe, actualiza la información de ese dispositivo
          devices[index] = currentDevice;
        } else {
          // El dispositivo es nuevo, añádelo a la lista
          devices.add(currentDevice);
        }

        await userDocRef.update({
          'devices': devices,
        });

        final DocumentSnapshot<Map<String, dynamic>> newUserDoc =
            await userDocRef.get();
        _person = PersonMapper.firestoreUserToEntity(newUserDoc);
      }
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
}
