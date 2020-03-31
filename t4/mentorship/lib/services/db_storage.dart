import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mentorship/services/authservice.dart';

class DbStorage {
  DbStorage(Auth auth) {
    this.auth = auth;
  }

  Auth auth;

  Future<FirebaseUser> getUser() async {
    return auth.getCurrentUser();
  }

  Future<void> updateProfilePic(String url) async {
    FirebaseUser user = await getUser();
    print(user.uid);
    await Firestore.instance
        .collection('profile-pics')
        .document(user.uid)
        .setData({'uid': user.uid, 'url': url});
    return;
  }

  Future<void> uploadListing(String title, String description) async {
    FirebaseUser user = await getUser();
    await Firestore.instance
        .collection('listings')
        .document()
        .setData({'uid': user.uid, 'title': title, 'description': description});
    return;
  }
}
