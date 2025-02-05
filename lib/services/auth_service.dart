import 'package:escrow_app/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final firebase_auth.FirebaseAuth _auth = firebase_auth.FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get the currently authenticated Firebase user
  firebase_auth.User? get firebaseUser => _auth.currentUser;

  // Get the current AppUser instance if a user is logged in
  AppUser? get currentUser {
    final user = _auth.currentUser;
    if (user == null) return null;
    return AppUser(
      id: user.uid,
      email: user.email ?? '',
      firstName: '', // Firebase Auth doesn't provide first/last name by default
      middleName: '',
      lastName: '',
      bankAccount: '',
      industry: '',
      profilePicture: user.photoURL ?? '',
    );
  }

  // Stream of AppUser instances for auth state changes
  Stream<AppUser?> get userStream {
    return _auth.authStateChanges().map((firebaseUser) {
      if (firebaseUser == null) return null;
      return AppUser(
        id: firebaseUser.uid,
        email: firebaseUser.email ?? '',
        firstName:
            '', // Firebase Auth doesn't provide first/last name by default
        middleName: '',
        lastName: '',
        bankAccount: '',
        industry: '',
        profilePicture: firebaseUser.photoURL ?? '',
      );
    });
  }

  // Get the current AppUser instance if a user is logged in
  AppUser? get user {
    final firebaseUser = _auth.currentUser;
    if (firebaseUser == null) return null;
    return AppUser(
      id: firebaseUser.uid,
      email: firebaseUser.email ?? '',
      firstName: '', // Firebase Auth doesn't provide first/last name by default
      middleName: '',
      lastName: '',
      bankAccount: '',
      industry: '',
      profilePicture: firebaseUser.photoURL ?? '',
    );
  }

  // Sign up a new user with additional details
  Future<void> signUp({
    required String email,
    required String password,
    required String firstName,
    required String middleName,
    required String lastName,
    required String bankAccount,
    required String industry,
    required String profilePicture,
  }) async {
    try {
      // Create the user in Firebase Authentication
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Create the corresponding user document in Firestore
      final user = AppUser(
        id: userCredential.user!.uid,
        email: email,
        firstName: firstName,
        middleName: middleName,
        lastName: lastName,
        bankAccount: bankAccount,
        industry: industry,
        profilePicture: profilePicture,
      );

      await _firestore.collection('users').doc(user.id).set(user.toMap());
    } catch (e) {
      throw Exception('Failed to sign up: $e');
    }
  }

  // Sign in an existing user
  Future<void> signIn(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      throw Exception('Failed to sign in: $e');
    }
  }

  // Sign out the current user
  Future<void> signOut() async {
    await _auth.signOut();
  }
}
