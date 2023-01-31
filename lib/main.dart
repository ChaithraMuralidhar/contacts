import 'package:contacts/ui/contacts_list/contacts_list_page.dart';
import 'package:contacts/ui/model/contacts_model.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModel(
      model: ContactsModel()..loadContacts(),
      child: MaterialApp(
        title: "Contacts",
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home:
            // ContactCreatePage(),
            const ContactListPage(),
      ),
    );
  }
}
