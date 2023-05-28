import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fullfit_app/config/config.dart';
import 'package:fullfit_app/domain/datasources/datasources.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fullfit_app/domain/entities/entities.dart';
import 'package:fullfit_app/infrastructure/mappers/mappers.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:twitter_login/twitter_login.dart';

class FirebaseAuthDatasourceImpl extends AuthDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final TwitterLogin _twitterLogin = TwitterLogin(
    apiKey: Environment.twitterApiKey,
    apiSecretKey: Environment.twitterApiSecret,
    redirectURI: Environment.twitterRedirectUri,
  );

  Future<Person> getUserData(String userId) async {
    final DocumentSnapshot<Map<String, dynamic>> userDoc =
        await _firestore.collection('users').doc(userId).get();

    // convertir el documento a una entidad de persona
    final Person person = PersonMapper.firestoreUserToEntity(userDoc);
    return person;
  }

  @override
  bool isUserLoggedIn() {
    if (_firebaseAuth.currentUser != null) {
      return true;
    }
    return false;
  }

  @override
  Future<Person> loginWithApple() {
    throw UnimplementedError();
  }

  @override
  Future<Person> loginWithEmailPassword(String email, String password) async {
    final UserCredential userCredential =
        await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    return await getUserData(userCredential.user!.uid);

    // obtener el documento del usuario de firestore
    // final DocumentSnapshot<Map<String, dynamic>> userDoc = await _firestore
    //     .collection('users')
    //     .doc(userCredential.user!.uid)
    //     .get();

    // // convertir el documento a una entidad de persona
    // final Person person = PersonMapper.firestoreUserToEntity(userDoc);
    // return person;
  }

  @override
  Future<Person> loginWithGoogle() {
    throw UnimplementedError();
  }

  @override
  Future<Person> loginWithTwitter() {
    throw UnimplementedError();
  }

  @override
  Future<void> logout() async {
    await _firebaseAuth.signOut();
  }

  @override
  Future<Person> register(String email, String password, String fullname) {
    throw UnimplementedError();
  }

  @override
  Future<Person> getLoggedInUser() async {
    return await getUserData(_firebaseAuth.currentUser!.uid);
    // final DocumentSnapshot<Map<String, dynamic>> userDoc = await _firestore
    //     .collection('users')
    //     .doc(_firebaseAuth.currentUser!.uid)
    //     .get();

    // // convertir el documento a una entidad de persona
    // final Person person = PersonMapper.firestoreUserToEntity(userDoc);
    // return person;
  }
}
