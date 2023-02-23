import 'package:contacts/ui/contact/widget/contact_form.dart';
import 'package:flutter/material.dart';

class ContactCreatePage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
return Scaffold(
  appBar: AppBar(
    title: Text('Create'),
    ),
    body: ContactForm(),
);


  }
}
