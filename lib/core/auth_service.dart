import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lazy_dm_helper/constants/constants.dart';
import 'package:lazy_dm_helper/core/core.dart';
import 'package:lazy_dm_helper/models/user_model.dart';
import 'package:logger/logger.dart';

class AuthService{
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<UserModel?> signUpEmailPassword(String email, String password) async {
    try{
      final UserCredential credential = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email.trim(),
          password: password.trim());
      final User? firebaseUser = credential.user;
      return firebaseUser != null ? UserModel(
        id: firebaseUser.uid,
        email: firebaseUser.email!
      ) : null;
    }on FirebaseAuthException catch(e){
      Logger logger = Logger();
      logger.e(e.toString());
    }
    return null;
  }

  Future<UserModel?> signInEmailPassword({required String email, required String password}) async {
    try{
      final UserCredential credential = await _firebaseAuth.signInWithEmailAndPassword(
          email: email.trim(),
          password: password.trim());
      final User? firebaseUser = credential.user;
      if(firebaseUser != null){
        UserModel temp = UserModel(id: firebaseUser.uid, email: firebaseUser.email!);
        APIManager.saveData(json: temp.toJson(), endpointPlural: Texts.usersEndpoint);
        return temp;
      }
      return null;
    }on FirebaseAuthException catch(e){
      Logger logger = Logger();
      logger.e(e.toString());
    }
    return null;
  }

  Future<UserModel?> signInGoogle() async {
    final GoogleSignInAccount? account = await _googleSignIn.signIn();
    if(account != null){
      final GoogleSignInAuthentication authentication = await account.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: authentication.accessToken,
        idToken: authentication.idToken
      );

      final UserCredential userCredential = await _firebaseAuth.signInWithCredential(credential);
      final User? firebaseUser = userCredential.user;

      if(firebaseUser != null){
        UserModel temp = UserModel(id: firebaseUser.uid, email: firebaseUser.email!);
        APIManager.saveData(json: temp.toJson(), endpointPlural: Texts.usersEndpoint);
        return temp;
      }
      return null;
    }
    return null;
  }

  Future<String> resetPassword({required String email}) async {
    String response = "";
    await _firebaseAuth
        .sendPasswordResetEmail(email: email)
        .then((value) => response = "S")
        .catchError((e) => response = "E");
    return response;
  }

  Future deleteAccount() async {
    await _firebaseAuth.currentUser?.delete();
  }

  Future signOutUser() async {
    final User? firebaseUser = _firebaseAuth.currentUser;
    if(firebaseUser != null){
      await _googleSignIn.signOut();
      await _firebaseAuth.signOut();
    }
  }
}