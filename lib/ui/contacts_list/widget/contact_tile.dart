import 'package:contacts/data/contact.dart';
import 'package:contacts/ui/contact/contact_edit_page.dart';
import 'package:contacts/ui/model/contacts_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:url_launcher/url_launcher.dart' as url_launcher;

class ContactTile extends StatelessWidget {
  const ContactTile({
    Key? key,
    required this.contactIndex,
  }) : super(key: key);

  final int contactIndex;

  @override
  Widget build(BuildContext context) {
    final model = ScopedModel.of<ContactsModel>(context);
    final displayedContact = model.contacts[contactIndex];
    return Slidable(
      startActionPane:
          ActionPane(motion: const ScrollMotion(), children: <Widget>[
        SlidableAction(
          onPressed: (context) {
            _callPhoneNumber(context, displayedContact.phoneNumber);
          },
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
          icon: Icons.phone,
          label: 'Phone',
        ),
        SlidableAction(
          onPressed: (context) {
            _writeEmail(context, displayedContact.email);
          },
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          icon: Icons.mail,
          label: 'E-mail',
        ),
      ]),
      endActionPane: ActionPane(motion: const ScrollMotion(), children: [
        SlidableAction(
          onPressed: (context) {
            model.deleteContact(displayedContact);
          },
          backgroundColor: Colors.red,
          foregroundColor: Colors.white,
          icon: Icons.delete,
          label: 'Delete',
        )
      ]),
      child: _buildContent(displayedContact, model, context),
    );
  }

  Future _callPhoneNumber(
    BuildContext context,
    String number,
  ) async {
    final url = Uri.parse('tel:$number');

    if (await url_launcher.canLaunchUrl(url)) {
      await url_launcher.launchUrl(url);
    } else {
      const snackBar = SnackBar(
        content: Text(
          "Cannot make a call",
          style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  Future _writeEmail(
    BuildContext context,
    String emailAddress,
  ) async {
    final url = Uri.parse('mailto:$emailAddress');

    if (await url_launcher.canLaunchUrl(url)) {
      await url_launcher.launchUrl(url);
    } else {
      const snackBar = SnackBar(
        content: Text(
          "Cannot send email",
          style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  Padding _buildContent(
    Contact displayedContact,
    ContactsModel model,
    BuildContext context,
  ) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        color: Theme.of(context).canvasColor,
        child: ListTile(
          title: Text(displayedContact.name),
          subtitle: Text(displayedContact.email),
          trailing: IconButton(
              icon: Icon(
                  size: 28,
                  displayedContact.isFavorite ? Icons.star : Icons.star_border),
              color: displayedContact.isFavorite ? Colors.amber : Colors.grey,
              onPressed: (() {
                model.changeFavoriteStatus(displayedContact);
              })),
          leading: _buildCircleAvatar(displayedContact),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => ContactEditPage(
                editedContact: displayedContact,
              ),
            ));
          },
        ),
      ),
    );
  }

  Hero _buildCircleAvatar(Contact displayedContact) {
    return Hero(
      tag: displayedContact.hashCode,
      child: CircleAvatar(
        child: _buildCircleAvatarContent(displayedContact),
      ),
    );
  }

  Widget _buildCircleAvatarContent(Contact displayedContact) {
    if (displayedContact.imageFile == null) {
      return Text(displayedContact.name[0]);
    } else {
      return ClipOval(
        child: AspectRatio(
          aspectRatio: 1 / 1,
          child: Image.file(
            displayedContact.imageFile!,
            fit: BoxFit.cover,
          ),
        ),
      );
    }
  }
}
