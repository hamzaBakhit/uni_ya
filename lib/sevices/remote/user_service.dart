import 'dart:async';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:uni_ya/constants/texts.dart';

class UserService {
  static final UserService get = UserService();
  User? myUser;

  UserService() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      myUser = user;
    });
  }

  Future<bool> createUserByEmail(
      {required String email,
      required String password,
      required String name}) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      myUser!.updateDisplayName(name);
      await myUser?.sendEmailVerification();
      EasyLoading.showSuccess(TextKeys.checkYourEmail.tr());
      return true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        EasyLoading.showError(TextKeys.weakPassword.tr());
      } else if (e.code == 'email-already-in-use') {
        EasyLoading.showError(TextKeys.emailUsed.tr());
      }
    } catch (e) {
      EasyLoading.showError(TextKeys.error.tr());
    }
    return false;
  }

  Future<UserCredential?> SignInByEmail(
      {required String email, required String password}) async {
    try {
      final userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      if (userCredential.user!.emailVerified) {
        return userCredential;
      } else {
        SignOut();
        EasyLoading.showError(TextKeys.checkYourEmail.tr());
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        EasyLoading.showError(TextKeys.userNotFound.tr());
      }
    }
    EasyLoading.showError(TextKeys.userNotFound.tr());
    return null;
  }

  Future<bool> SignOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      return true;
    } catch (e) {
      EasyLoading.showError(TextKeys.error.tr());
      return false;
    }
  }

  Future<bool> resetPassword({required String email}) async {
    try {
      if (email.isNotEmpty) {
        try {
          await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
        } on PlatformException catch (e) {
          if (Platform.isAndroid &&
              e.message.toString().contains(
                  "There is no user record corresponding to this identifier. The user may have been deleted.")) {
            EasyLoading.showSuccess(TextKeys.userNotFound.tr());
          } else if (Platform.isIOS &&
              e.message.toString().contains("Error 17011")) {
            EasyLoading.showSuccess(TextKeys.userNotFound.tr());
          }
        }
      } else if (email.isEmpty) {
        EasyLoading.showSuccess(TextKeys.checkYourEmail.tr());
        Future.delayed(const Duration(milliseconds: 3000), () {
          EasyLoading.dismiss();
        });
      }
      return true;
    } catch (e) {
      EasyLoading.showError(TextKeys.error.tr());
      Future.delayed(const Duration(milliseconds: 3000), () {
        EasyLoading.dismiss();
      });
      return false;
    }
  }

  Future<UserCredential?> signInWithGoogle({String? token}) async {
    try {
      if (token == null) {
        final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
        final GoogleSignInAuthentication? googleAuth =
            await googleUser?.authentication;
        token = googleAuth?.accessToken;
      }
      final credential = GoogleAuthProvider.credential(
        accessToken: token,
        // idToken: googleAuth?.idToken,
      );
      final user = await FirebaseAuth.instance.signInWithCredential(credential);
      return user;
    } catch (e) {
      EasyLoading.showError(TextKeys.error.tr());
    }
    return null;
  }

  Future<UserCredential?> signInWithFacebook() async {
    try {
      final LoginResult loginResult = await FacebookAuth.instance.login();
      final OAuthCredential facebookAuthCredential =
          FacebookAuthProvider.credential(loginResult.accessToken!.token);
      return FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
    } catch (e) {
      print(e);
      EasyLoading.showError(TextKeys.error.tr());
    }
    return null;
  }

  Future<UserCredential?> signInWithApple() async {
    // To prevent replay attacks with the credential returned from Apple, we
    // include a nonce in the credential request. When signing in with
    // Firebase, the nonce in the id token returned by Apple, is expected to
    // match the sha256 hash of `rawNonce`.
    String generateNonce([int length = 32]) {
      final charset =
          '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
      final random = Random.secure();
      return List.generate(
          length, (_) => charset[random.nextInt(charset.length)]).join();
    }

    /// Returns the sha256 hash of [input] in hex notation.
    String sha256ofString(String input) {
      final bytes = utf8.encode(input);
      final digest = sha256.convert(bytes);
      return digest.toString();
    }

    try {} catch (e) {
      EasyLoading.showError('Some Error');
      final rawNonce = generateNonce();
      final nonce = sha256ofString(rawNonce);

      // Request credential for the currently signed in Apple account.
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        nonce: nonce,
      );

      // Create an `OAuthCredential` from the credential returned by Apple.
      final oauthCredential = OAuthProvider("apple.com").credential(
        idToken: appleCredential.identityToken,
        rawNonce: rawNonce,
      );

      // Sign in the user with Firebase. If the nonce we generated earlier does
      // not match the nonce in `appleCredential.identityToken`, sign in will fail.
      return await FirebaseAuth.instance.signInWithCredential(oauthCredential);
    }
    return null;
  }

  Future<UserCredential?> signInWithPhone(String phoneNum) async {
    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: '+201091447533',
        verificationCompleted: (PhoneAuthCredential credential) async {
          await FirebaseAuth.instance.signInWithCredential(credential);
          print(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          if (e.code == 'invalid-phone-number') {
            print('The provided phone number is not valid.');
          }
        },
        codeSent: (String verificationId, int? resendToken) async {
          // Update the UI - wait for the user to enter the SMS code
          String smsCode = '330080';

          // Create a PhoneAuthCredential with the code
          PhoneAuthCredential credential = PhoneAuthProvider.credential(
              verificationId: verificationId, smsCode: smsCode);
          credential.accessToken;
          print(credential);
          print(credential.accessToken);
          // Sign the user in (or link) with the credential
          await FirebaseAuth.instance.signInWithCredential(credential);
        },
        timeout: const Duration(minutes: 2),
        codeAutoRetrievalTimeout: (String verificationId) {
          print('time Out');
        });
  }
}
