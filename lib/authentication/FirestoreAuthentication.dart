import 'package:warwicksocietyapp/models/firestore_user.dart';


class FirestoreAuthentication {
  FirestoreUser? _firestoreUser;

  FirestoreAuthentication._privateConstructor();

  static final FirestoreAuthentication _instance =
  FirestoreAuthentication._privateConstructor();

  static FirestoreAuthentication get instance => _instance;


  final List<void Function(FirestoreUser? firestoreUser)> _listeners = [];


  FirestoreUser? get firestoreUser => _firestoreUser;

  set firestoreUser(FirestoreUser? user) {
    _firestoreUser = user;
    print("updated");
    _notifyListeners();
  }


  void addListener(void Function(FirestoreUser? firestoreUser) listener) {
    _listeners.add(listener);
  }


  void removeListener(void Function(FirestoreUser? firestoreUser) listener) {
    _listeners.remove(listener);
  }

  void _notifyListeners() {
    for (var listener in _listeners) {
      listener(_firestoreUser);
    }
  }
}
