import 'package:enough_mail/enough_mail.dart';
import 'package:flutter/cupertino.dart';

class StateManagerEmail with ChangeNotifier {
  List<MimeMessage> mails = [];
  List<MimeMessage> viewMails = [];
  String? searchValue;
  String sortBy = 'date', direction = 'asc';

  void addAll(List<MimeMessage> messages) {
    mails.clear();
    mails.addAll(messages);
    mails.sort((a, b) => a.toString().compareTo(b.toString()));
    search(searchValue);
    notifyListeners();
  }

  void addSingleMail(MimeMessage mail) {
    mails.add(mail);
    mails.sort((a, b) => a.toString().compareTo(b.toString()));
    search(searchValue);
    notifyListeners();
  }

  void update(MimeMessage mail, int condition) {
    for (var element in mails) {
      if (element.uid == condition) {
        element = mail;
        break;
      }
    }
    mails.sort((a, b) => a.toString().compareTo(b.toString()));
    search(searchValue);
    notifyListeners();
  }

  void search(dynamic value) {
    viewMails.clear();
    if (value != null) {
      for (var element in mails) {
        if (/*element.subject.toLowerCase().contains(value.toLowerCase()) ||*/
            element.from!.contains(value) ||
            element.to!.contains(value) ||
            element.decodeDate()!.isAtSameMomentAs(value)) {
          viewMails.add(element);
        }
      }
    } else {
      viewMails.addAll(mails);
    }
    viewMails.sort((a, b) => a.toString().compareTo(b.toString()));
    notifyListeners();
  }
}
