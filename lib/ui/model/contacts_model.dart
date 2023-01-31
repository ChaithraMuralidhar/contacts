import 'package:contacts/data/db/contact_dao.dart';
import 'package:scoped_model/scoped_model.dart';
import '../../data/contact.dart';

class ContactsModel extends Model {
  final ContactDao _contactDao = ContactDao();

  List<Contact>? _contacts;
  List<Contact> get contacts => _contacts ?? [];

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  Future loadContacts() async {
    if (_contacts != null) {
      _contacts = <Contact>[];
    }
    _isLoading = true;
    notifyListeners();
    _contacts = await _contactDao.getAllInSortedOrder();
    _isLoading = false;
    notifyListeners();
  }

  Future addContact(Contact contact) async {
    await _contactDao.insert(contact);
    await loadContacts();
    notifyListeners();
  }

  Future updateContact(Contact contact) async {
    await _contactDao.update(contact);
    await loadContacts();
    notifyListeners();
  }

  Future deleteContact(Contact contact) async {
    await _contactDao.delete(contact);
    await loadContacts();
    notifyListeners();
  }

  Future changeFavoriteStatus(Contact contact) async {
    contact.isFavorite = !contact.isFavorite;
    await _contactDao.update(contact);
    // Even though we are loading all contacts, we dont want to change isLoading to true
    //thats because it would be silly to display the loading indicator after
    //only changing the fav status
    _contacts = await _contactDao.getAllInSortedOrder();

    notifyListeners();
  }
}
