import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:slope_net/Screen/Auth/Login_Screen.dart';
import 'package:slope_net/Screen/Auth/VerifyEmailScreen.dart';
import 'package:slope_net/Screen/RootScreen.dart';

class Authenticationcontroller extends GetxController {
  static String? validateEmail(String value) =>
      RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(value.trim())
          ? null
          : "Enter a valid email";

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;

  final Rxn<User> firebaseUser = Rxn<User>();
  final RxBool isAuthReady = false.obs;
  final RxBool isLoading = false.obs;
  final RxBool emailVerified = false.obs;

  final RxString userName = ''.obs;
  final RxString userEmail = ''.obs;
  final RxString userRole = 'traveler'.obs;

  // Resend verification email cooldown (seconds)
  final RxInt resendSecondsLeft = 0.obs;
  Timer? _resendTimer;

  bool _googleInitialized = false;
  bool _hasRoutedInitialSession = false;

  @override
  void onInit() {
    super.onInit();
    _initAuthListener();
  }

  @override
  void onClose() {
    _resendTimer?.cancel();
    super.onClose();
  }

  Future<void> _ensureGoogleSignInInitialized() async {
    if (_googleInitialized) return;
    await _googleSignIn.initialize();
    _googleInitialized = true;
  }

  void _initAuthListener() {
    _auth.authStateChanges().listen((User? user) async {
      firebaseUser.value = user;

      if (user != null) {
        emailVerified.value = user.emailVerified;
        userEmail.value = user.email ?? '';
        try {
          await _ensureUserDocument(user);
        } catch (e) {
          debugPrint('Firestore user sync warning: $e');
        }
      } else {
        emailVerified.value = false;
        userName.value = '';
        userEmail.value = '';
        userRole.value = 'traveler';
      }

      if (!isAuthReady.value) {
        isAuthReady.value = true;
      }
    });
  }

  Future<void> _ensureUserDocument(User user, {String? fallbackName}) async {
    if (_auth.currentUser == null) return;

    final docRef = _firestore.collection('users').doc(user.uid);
    final snap = await docRef.get();

    if (!snap.exists) {
      final resolvedName =
      (fallbackName != null && fallbackName.trim().isNotEmpty)
          ? fallbackName.trim()
          : (user.displayName ?? user.email?.split('@').first ?? 'Traveler');

      await docRef.set({
        'uid': user.uid,
        'fullName': resolvedName,
        'email': user.email ?? '',
        'role': 'traveler',
        'emailVerified': user.emailVerified,
        'activeSession': true,
        'createdAt': FieldValue.serverTimestamp(),
        'lastLoginAt': FieldValue.serverTimestamp(),
      });

      userName.value = resolvedName;
      userRole.value = 'traveler';
    } else {
      final data = snap.data() ?? {};
      userName.value =
          (data['fullName'] ?? user.displayName ?? 'Traveler').toString();
      userRole.value = (data['role'] ?? 'traveler').toString();

      await docRef.set({
        'emailVerified': user.emailVerified,
        'activeSession': true,
        'lastLoginAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    }
  }

  // ---------------------------------------------------------------------------
  // 1. SIGN UP WITH EMAIL + SEND VERIFICATION LINK
  // ---------------------------------------------------------------------------
  Future<void> signUpWithEmail({
    required String fullName,
    required String email,
    required String password,
  }) async {
    if (fullName.trim().isEmpty || email.trim().isEmpty || password.isEmpty) {
      _showError('Please fill in all fields.');
      return;
    }

    try {
      isLoading.value = true;

      final credential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      final user = credential.user;
      if (user == null) {
        _showError('Unable to create account. Please try again.');
        return;
      }

      await user.updateDisplayName(fullName.trim());
      await _ensureUserDocument(user, fallbackName: fullName.trim());

      // Send free Firebase verification email
      await user.sendEmailVerification();
      _startResendCooldown();

      Get.snackbar(
        'Verification Email Sent',
        'Check ${user.email} and click the verification link.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF0C2E24),
        colorText: Colors.white,
      );

      Get.offAll(() => VerifyEmailScreen());
    } on FirebaseAuthException catch (e) {
      _showError(_mapAuthError(e));
    } catch (e) {
      _showError('Signup failed: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // ---------------------------------------------------------------------------
  // 2. LOGIN WITH EMAIL & PASSWORD
  // ---------------------------------------------------------------------------
  Future<void> loginWithEmail({
    required String email,
    required String password,
  }) async {
    if (email.trim().isEmpty || password.isEmpty) {
      _showError('Please enter your email and password.');
      return;
    }

    try {
      isLoading.value = true;

      final credential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      User? user = credential.user;
      if (user == null) return;

      await user.reload();
      user = _auth.currentUser;
      if (user == null) return;

      await _ensureUserDocument(user);

      if (!user.emailVerified) {
        Get.offAll(() => VerifyEmailScreen());
        return;
      }

      Get.offAll(() => RootScreen());
    } on FirebaseAuthException catch (e) {
      _showError(_mapAuthError(e));
    } catch (e) {
      _showError('Login failed: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // ---------------------------------------------------------------------------
  // 3. GOOGLE SIGN-IN (Emails from Google are already verified)
  // ---------------------------------------------------------------------------
  Future<void> signInWithGoogle() async {
    try {
      isLoading.value = true;
      await _ensureGoogleSignInInitialized();

      final GoogleSignInAccount googleUser = await _googleSignIn.authenticate();
      final GoogleSignInAuthentication googleAuth = googleUser.authentication;

      final OAuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);
      final user = userCredential.user;

      if (user != null) {
        await _ensureUserDocument(user);
        Get.offAll(() => RootScreen());
      }
    } on GoogleSignInException catch (e) {
      if (e.code != GoogleSignInExceptionCode.canceled) {
        _showError('Google Sign-In failed: ${e.description ?? e.code.name}');
      }
    } on FirebaseAuthException catch (e) {
      _showError(_mapAuthError(e));
    } catch (e) {
      _showError('Google Sign-In error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // ---------------------------------------------------------------------------
  // 4. CHECK EMAIL VERIFICATION STATUS & RESEND LINK
  // ---------------------------------------------------------------------------
  Future<void> checkEmailVerified({bool silent = false}) async {
    try {
      if (!silent) isLoading.value = true;

      User? user = _auth.currentUser;
      if (user == null) {
        Get.offAll(() => LoginScreen());
        return;
      }

      // Must call reload() and re-read _auth.currentUser to refresh emailVerified
      await user.reload();
      user = _auth.currentUser;

      if (user != null && user.emailVerified) {
        emailVerified.value = true;
        await _firestore.collection('users').doc(user.uid).update({
          'emailVerified': true,
          'verifiedAt': FieldValue.serverTimestamp(),
        });

        Get.offAll(() => RootScreen());
      } else if (!silent) {
        _showError(
          'Email not verified yet. Please click the link sent to ${user?.email}.',
        );
      }
    } catch (e) {
      if (!silent) _showError('Could not verify status: $e');
    } finally {
      if (!silent) isLoading.value = false;
    }
  }

  Future<void> resendVerificationEmail() async {
    if (resendSecondsLeft.value > 0) return;

    try {
      isLoading.value = true;
      final user = _auth.currentUser;
      if (user == null) return;

      await user.sendEmailVerification();
      _startResendCooldown();

      Get.snackbar(
        'Email Resent',
        'A new verification link has been sent to ${user.email}.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF0C2E24),
        colorText: Colors.white,
      );
    } on FirebaseAuthException catch (e) {
      _showError(_mapAuthError(e));
    } catch (e) {
      _showError('Failed to resend email: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void _startResendCooldown() {
    _resendTimer?.cancel();
    resendSecondsLeft.value = 60;
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (resendSecondsLeft.value <= 1) {
        resendSecondsLeft.value = 0;
        timer.cancel();
      } else {
        resendSecondsLeft.value--;
      }
    });
  }

  // ---------------------------------------------------------------------------
  // 5. FORGOT PASSWORD
  // ---------------------------------------------------------------------------
  Future<void> sendPasswordResetEmail(String email) async {
    if (email.trim().isEmpty) {
      _showError('Please enter your email address.');
      return;
    }

    try {
      isLoading.value = true;
      await _auth.sendPasswordResetEmail(email: email.trim());
      Get.snackbar(
        'Reset Link Sent',
        'Check ${email.trim()} to reset your password.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF0C2E24),
        colorText: Colors.white,
      );
    } on FirebaseAuthException catch (e) {
      _showError(_mapAuthError(e));
    } finally {
      isLoading.value = false;
    }
  }

  // ---------------------------------------------------------------------------
  // 6. SPLASH SESSION ROUTING & LOGOUT
  // ---------------------------------------------------------------------------
  Future<void> routeBySavedSession({required Widget fallbackScreen}) async {
    if (_hasRoutedInitialSession) return;

    if (!isAuthReady.value) {
      await isAuthReady.stream.firstWhere((ready) => ready == true);
    }

    _hasRoutedInitialSession = true;

    User? user = _auth.currentUser;
    if (user != null) {
      await user.reload();
      user = _auth.currentUser;

      if (user != null && !user.emailVerified) {
        Get.offAll(() => VerifyEmailScreen());
        return;
      }

      Get.offAll(() => RootScreen());
      return;
    }

    Get.offAll(() => fallbackScreen);
  }

  Future<void> logout() async {
    try {
      isLoading.value = true;
      final uid = _auth.currentUser?.uid;

      if (uid != null) {
        await _firestore.collection('users').doc(uid).update({
          'activeSession': false,
          'lastLogoutAt': FieldValue.serverTimestamp(),
        }).catchError((_) {});
      }

      if (_googleInitialized) {
        await _googleSignIn.signOut();
      }
      await _auth.signOut();

      _hasRoutedInitialSession = false;
      _resendTimer?.cancel();
      resendSecondsLeft.value = 0;

      Get.offAll(() => LoginScreen());
    } catch (e) {
      _showError('Logout failed: $e');
    } finally {
      isLoading.value = false;
    }
  }

  String _mapAuthError(FirebaseAuthException e) {
    switch (e.code) {
      case 'email-already-in-use':
        return 'An account already exists with this email.';
      case 'invalid-email':
        return 'Please enter a valid email address.';
      case 'weak-password':
        return 'Password must be at least 6 characters.';
      case 'user-not-found':
      case 'wrong-password':
      case 'invalid-credential':
        return 'Incorrect email or password.';
      case 'too-many-requests':
        return 'Too many attempts. Please wait a moment and try again.';
      default:
        return e.message ?? 'Authentication failed.';
    }
  }

  void _showError(String message) {
    Get.snackbar(
      'Notice',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.redAccent.withOpacity(0.9),
      colorText: Colors.white,
    );
  }
}