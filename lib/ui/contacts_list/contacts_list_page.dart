import 'package:contacts/ui/contacts_list/widget/contact_tile.dart';
import 'package:contacts/ui/model/contacts_model.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../contact/contact_create_page.dart';

class ContactListPage extends StatefulWidget {
  const ContactListPage({Key? key}) : super(key: key);

  @override
  State<ContactListPage> createState() => _ContactListPageState();
}

class _ContactListPageState extends State<ContactListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Contacts"),
        ),
        body: ScopedModelDescendant<ContactsModel>(
          builder: (context, child, model) {
            if (model.isLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return ListView.builder(
                itemCount: model.contacts.length,
                // Runs and builds every item
                itemBuilder: (context, index) {
                  return ContactTile(
                    contactIndex: index,
                  );
                },
              );
            }
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => ContactCreatePage()));
          },
          child: Icon(Icons.person_add),
        ));
  }
}
