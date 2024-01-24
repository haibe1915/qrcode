import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:permission_handler/permission_handler.dart';

class GetContact {
  _contactsPermissions() async {
    Map<Permission, PermissionStatus> permissionStatus =
        await [Permission.contacts].request();
    return permissionStatus[Permission.contacts];
  }

  getAllContact() async {
    List<Contact> contacts = [];
    PermissionStatus contactsPermissionsStatus = await _contactsPermissions();
    if (contactsPermissionsStatus.isGranted) {
      List<Contact> _contacts =
          await FlutterContacts.getContacts(withProperties: true);
      contacts = _contacts;
      return contacts;
    }
    return contacts;
  }
}
