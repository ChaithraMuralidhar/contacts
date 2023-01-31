import 'dart:io';

import 'package:contacts/data/contact.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:scoped_model/scoped_model.dart';

import '../../model/contacts_model.dart';

class ContactForm extends StatefulWidget {
  final Contact? editedContact;

  const ContactForm({
    Key? key,
    this.editedContact,
  }) : super(key: key);

  @override
  State<ContactForm> createState() => _ContactFormState();
}

class _ContactFormState extends State<ContactForm> {
  final _formKey = GlobalKey<FormState>();

  late String _name;
  late String _email;
  late String _phoneNumber;
  File? _contactImageFile;

  bool get isEditMode => widget.editedContact != null;
  bool get hasSelectedCustomImage => _contactImageFile != null;

  @override
  void initState() {
    super.initState();
    _contactImageFile = widget.editedContact?.imageFile;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: ListView(
        children: <Widget>[
          SizedBox(
            height: 20,
          ),
          _buildContactPictures(),
          SizedBox(
            height: 20,
          ),
          TextFormField(
            onSaved: (value) => _name = value!,
            decoration: InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                )),
            validator: _validateName,
            initialValue: widget.editedContact?.name,
          ),
          SizedBox(
            height: 20,
          ),
          TextFormField(
            onSaved: (value) => _email = value!,
            decoration: InputDecoration(
                labelText: 'E-mail',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                )),
            validator: _validateEmail,
            initialValue: widget.editedContact?.email,
          ),
          SizedBox(
            height: 20,
          ),
          TextFormField(
            onSaved: (value) => _phoneNumber = value!,
            decoration: InputDecoration(
                labelText: 'Phone Number',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                )),
            validator: _validatePhonenumber,
            initialValue: widget.editedContact?.phoneNumber,
          ),
          SizedBox(
            height: 20,
          ),
          MaterialButton(
            onPressed: _onSaveContactButtonPressed,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "SAVE CONTACT",
                  style: TextStyle(fontSize: 16),
                ),
                Icon(
                  Icons.person,
                  size: 20,
                )
              ],
            ),
            color: Theme.of(context).primaryColor,
            textColor: Colors.white,
          ),
        ],
      ),
    );
  }

  Widget _buildContactPictures() {
    final halfScreenDiameter = MediaQuery.of(context).size.width / 2;
    return Hero(
      tag: widget.editedContact.hashCode,
      child: GestureDetector(
        onTap: _onContactPictureTapped,
        child: CircleAvatar(
          radius: halfScreenDiameter / 2,
          child: _buildCircleAvatarContent(halfScreenDiameter / 2),
          // child: Text(widget.editedContact!.name[0]),
        ),
      ),
    );
  }

  void _onContactPictureTapped() async {
    final imageFile = await ImagePicker().getImage(source: ImageSource.gallery);
    setState(() {
      _contactImageFile = File(imageFile!.path);
    });
    print(imageFile?.path);
  }

  Widget _buildCircleAvatarContent(double halfScreenDiameter) {
    if (isEditMode || hasSelectedCustomImage) {
      return _buildEditModeCircleAvatarContent(halfScreenDiameter);
    } else {
      return Icon(
        Icons.person,
        size: halfScreenDiameter / 2,
      );
    }
  }

  Widget _buildEditModeCircleAvatarContent(double halfScreenDiameter) {
    if (_contactImageFile == null) {
      return Text(
        widget.editedContact!.name[0],
        style: TextStyle(fontSize: halfScreenDiameter / 1.5),
      );
    } else {
      return ClipOval(
          child: AspectRatio(
        aspectRatio: 1 / 1,
        child: Image.file(
          _contactImageFile!,
          fit: BoxFit.cover,
        ),
      ));
    }
  }

  String? _validateName(String? value) {
    if (value!.isEmpty) {
      return "Enter a name";
    }
    return null;
  }

  String? _validateEmail(String? value) {
    final emailRegExp = RegExp(
        // r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9]{0,253}[a-zA-Z0-9]?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9]{0,253}[a-zA-Z0-9]?)?)*$"
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    if (value!.isEmpty) {
      return "Enter an  E-mail";
    } else if (!emailRegExp.hasMatch(value)) {
      return 'Enter a valid Email Address';
    }
    return null;
  }

  String? _validatePhonenumber(String? value) {
    final phoneRegExp = RegExp(r'[!@#<>?":_`~;[\]\\|+=)(*&^%0-9-]');
    if (value!.isEmpty) {
      return "Enter an  E-mail";
    } else if (!phoneRegExp.hasMatch(value)) {
      return 'Enter a valid phone number ';
    }
    return null;
  }

  void _onSaveContactButtonPressed() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState?.save();
      final newOrEditedContact = Contact(
          name: _name,
          email: _email,
          phoneNumber: _phoneNumber,
          isFavorite: widget.editedContact?.isFavorite ?? false,
          imageFile: _contactImageFile);
      // print(_name + '  ' + _email + '  ' + _phoneNumber);

      if (isEditMode) {
        newOrEditedContact.id = widget.editedContact?.id;
        ScopedModel.of<ContactsModel>(context).updateContact(
          newOrEditedContact,
        );
      } else {
        ScopedModel.of<ContactsModel>(context).addContact(newOrEditedContact);
      }
      Navigator.of(context).pop();
    }
  }
}
