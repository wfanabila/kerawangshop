import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserProfile {
  final String name;
  final String email;
  final String phone;
  final String pfpPath;

  UserProfile({
    required this.name,
    required this.email,
    required this.phone,
    required this.pfpPath,
  });

  factory UserProfile.fromMap(Map<String, dynamic> map, {String defaultEmail = ''}) {
    return UserProfile(
      name: map['name'] ?? 'New User',
      email: map['email'] != null && map['email'].toString().isNotEmpty 
          ? map['email'].toString() 
          : defaultEmail,
      phone: map['phone'] ?? '',
      pfpPath: map['pfpPath'] ?? 'assets/images/pfp1.jpg',
    );
  }

  UserProfile copyWith({String? name, String? email, String? phone, String? pfpPath}) {
    return UserProfile(
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      pfpPath: pfpPath ?? this.pfpPath,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'pfpPath': pfpPath,
    };
  }

  bool get hasCustomPicture => pfpPath.startsWith('http');
}

class ProfileNotifier extends StateNotifier<UserProfile> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  final _storage = FirebaseStorage.instance;

  ProfileNotifier()
      : super(UserProfile(
          name: 'Loading...',
          email: '',
          phone: '',
          pfpPath: 'assets/images/pfp1.jpg',
        )) {
    _listenToDatabaseUpdates();
  }

  void _listenToDatabaseUpdates() {
    final User? user = _auth.currentUser;
    if (user != null) {
      _firestore.collection('users').doc(user.uid).snapshots().listen((snapshot) {
        if (snapshot.exists && snapshot.data() != null) {
          state = UserProfile.fromMap(snapshot.data()!, defaultEmail: user.email ?? '');
        } else {
          state = state.copyWith(
            name: 'New User',
            email: user.email ?? '',
          );
        }
      });
    }
  }

  Future<void> updateProfile({
    required String name,
    required String email,
    required String phone,
  }) async {
    try {
      final User? user = _auth.currentUser;
      if (user == null) throw Exception("No user logged in");

      final updatedData = state.copyWith(name: name, email: email, phone: phone);

      await _firestore
          .collection('users')
          .doc(user.uid)
          .set(updatedData.toMap(), SetOptions(merge: true));
    } catch (e) {
      print("Database Error: $e");
      rethrow;
    }
  }
Future<void> updateProfilePicture(File imageFile) async {
    final User? user = _auth.currentUser;
    if (user == null) throw Exception("No user logged in");

    try {
      final ref = _storage.ref().child('profile_pictures').child('${user.uid}.jpg');

      await ref.putFile(
        imageFile,
        SettableMetadata(contentType: 'image/jpeg'),
      );

      final downloadUrl = await ref.getDownloadURL();

      await _firestore
          .collection('users')
          .doc(user.uid)
          .set({'pfpPath': downloadUrl}, SetOptions(merge: true));

    
      state = state.copyWith(pfpPath: downloadUrl);
    } catch (e) {
      print("Profile picture upload error: $e");
      rethrow;
    }
  }

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    final User? user = _auth.currentUser;
    if (user == null || user.email == null) {
      throw Exception("No user logged in.");
    }

    AuthCredential credential = EmailAuthProvider.credential(
      email: user.email!,
      password: currentPassword,
    );

    await user.reauthenticateWithCredential(credential);

    await user.updatePassword(newPassword);
  }
}

final profileProvider = StateNotifierProvider<ProfileNotifier, UserProfile>((ref) {
  return ProfileNotifier();
});