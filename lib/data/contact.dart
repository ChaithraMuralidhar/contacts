import 'dart:io';

class Contact {
//Database id(key)
  int? id;

  String name;
  String email;
  String phoneNumber;
  dynamic isFavorite;
  File? imageFile;

  Contact(
      {required this.name,
      required this.email,
      required this.phoneNumber,
      this.isFavorite = false,
      this.imageFile});

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'phoneNumber': phoneNumber,
      'isFavorite': isFavorite,
      'imageFilePath': imageFile?.path
    };
  }

  static Contact fromMap(Map<String, dynamic> map) {
    return Contact(
      name: map['name'],
      email: map['email'],
      phoneNumber: map['phoneNumber'],
      isFavorite: map['isFavorite'],
      // if there is an imageFilePath, then convert it to File.
      // otherwise set imageFile to be null.
      imageFile:
          map['imageFilePath'] != null ? File(map['imageFilePath']) : null,
    );
  }
}
