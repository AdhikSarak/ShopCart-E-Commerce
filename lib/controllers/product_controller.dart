import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shiv/consts/consts.dart';
import 'package:shiv/models/category_model.dart';

class ProductController extends GetxController {
  var quantity = 0.obs;
  var colorIndex = 0.obs;
  var totalPrice = 0.obs;
  var isFav = false.obs;
  var selectedSubcat = 0.obs;

  var subcat = [];
  getSubcategories(title) async {
    subcat.clear();
    var data = await rootBundle.loadString('lib/services/category_model.json');
    var decoded = categoryModelFromJson(data);
    var s =
        decoded.categories.where((element) => element.name == title).toList();
    for (var e in s[0].subcategory) {
      subcat.add(e);
    }
  }

  changeColorIndex(index) {
    colorIndex.value = index;
  }

  increaseQuantity(totalQuantity) {
    if (totalQuantity > quantity.value) {
      quantity.value++;
    }
  }

  decreaseQuantity() {
    if (quantity.value > 0) {
      quantity.value--;
    }
  }

  calculateTotalPrice(price) {
    totalPrice.value = price * quantity.value;
  }

  addToCart({
    context,
    title,
    image,
    seller,
    color,
    quantity,
    totalPrice,
    vendorId,
  }) async {
    firestore.collection(cartCollection).doc().set({
      'title': title,
      'image': image,
      'seller': seller,
      'color': color,
      'quantity': quantity,
      'total_price': totalPrice,
      'added_by': currentUser!.uid,
      'vendor_id': vendorId,
    }).catchError((e) {
      VxToast.show(context, msg: e.toString());
    });
  }

  resetValues() {
    quantity.value = 0;
    totalPrice.value = 0;
    colorIndex.value = 0;
  }

  resetSubcatIndex() {
    selectedSubcat.value = 0;
  }

  addToWishlist(context, docId) async {
    await firestore.collection(productsCollection).doc(docId).set(
      {
        'p_wishlist': FieldValue.arrayUnion([
          currentUser!.uid,
        ]),
      },
      SetOptions(merge: true),
    );
    isFav(true);
    VxToast.show(context, msg: "Added to Wishlist");
  }

  removeFromWishlist(context, docId) async {
    await firestore.collection(productsCollection).doc(docId).set(
      {
        'p_wishlist': FieldValue.arrayRemove([
          currentUser!.uid,
        ]),
      },
      SetOptions(merge: true),
    );
    isFav(false);
    VxToast.show(context, msg: "Removed from Wishlist");
  }

  checkIfFav(data) async {
    if (data['p_wishlist'].contains(currentUser!.uid)) {
      isFav(true);
    } else {
      isFav(false);
    }
  }

  changeSelectedSubcat(index) {
    selectedSubcat.value = index;
  }
}
