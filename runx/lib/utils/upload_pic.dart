// System Packages
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

final _firebaseAuth = FirebaseAuth.instance;
FirebaseStorage firebaseStorage = FirebaseStorage.instance;
FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
final imgPicker = ImagePicker();
late File image;
String photoUrl = "";

uploadPic() async {
  try {
    // picking Image from local storage
    final file = await ImagePicker().pickImage(
      imageQuality: 70,
      maxWidth: 1440,
      source: ImageSource.gallery,
    );

    image = File(file!.path);

    // creating ref at Firebase Storage with userID
    Reference ref =
        firebaseStorage.ref(_firebaseAuth.currentUser?.uid).child(file.path);

    ref
        .putFile(
            image,
            SettableMetadata(customMetadata: {
              'uploaded_by': _firebaseAuth.currentUser!.uid.toString(),
              'date': DateTime.now().toString(),
            }))
        .whenComplete(() async {
      print("Pic Uploaded Successfully!");

      String url = (await ref.getDownloadURL()).toString();

      // refreshing the UI when photo updated
      print("URL UPLOADED AT: $url");
    });
  } catch (e) {
    print(e);
  }
}
