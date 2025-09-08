import 'package:get/get.dart';
import 'package:shiv/consts/consts.dart';
import 'package:shiv/consts/firebase_consts.dart';

class HomeController extends GetxController {
  @override
  void onInit() {
    getUsername();
    super.onInit();
  }

  var currNavIndex = 0.obs;

  var username = '';

  var searchController = TextEditingController();

  getUsername() async {
    var n = await firestore
        .collection(usersCollection)
        .where('id', isEqualTo: currentUser!.uid)
        .get()
        .then((value) {
      if (value.docs.isNotEmpty) {
        return value.docs.single['name'];
      }
    });
    username = n;
    print(username);
  }
}
