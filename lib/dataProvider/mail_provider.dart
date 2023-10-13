import 'package:flutter/cupertino.dart';

import '../model/thread.dart';

class MailProvider extends ChangeNotifier {
  List<dynamic> _mailIds = [];
  Thread? _openedThread;

  List<dynamic> get mailIds => _mailIds;
  Thread? get currentThread => _openedThread;

  set updateMailIds(List<dynamic> mails) {
    _mailIds = mails;
    notifyListeners();
  }

  set setCurrentThread(Thread thread) {
    _openedThread = thread;
    notifyListeners();
  }
}
