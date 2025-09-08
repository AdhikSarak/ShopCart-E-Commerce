import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:shiv/consts/consts.dart';
import 'package:shiv/controllers/home_controller.dart';

class CartController extends GetxController {
  var totalPrice = 0.obs;
  var addressController = TextEditingController();
  var cityController = TextEditingController();
  var postalCodeController = TextEditingController();
  var stateController = TextEditingController();
  var phoneController = TextEditingController();
  var paymentIndex = 0.obs;
  late dynamic productsSnapshot;
  var products = [];
  var placingOrder = false.obs;

  calculate(data) {
    totalPrice.value = 0;
    for (var i = 0; i < data.length; i++) {
      totalPrice.value += int.parse(data[i]['total_price'].toString());
    }
  }

  changePaymentIndex(index) {
    paymentIndex.value = index;
  }

  placeMyOrder(orderPaymentsMethod) async {
    placingOrder(true);
    await getProductDetails();
    await firestore.collection(ordersCollection).doc().set({
      'order_id': "123456789",
      'order_by': currentUser!.uid,
      'order_by_name': Get.find<HomeController>().username,
      'order_by_email': currentUser!.email,
      'order_by_address': addressController.text,
      'order_by_city': cityController.text,
      'order_by_state': stateController.text,
      'order_by_postalcode': postalCodeController.text,
      'order_by_phone': phoneController.text,
      'shipping_method': "Home Delivery",
      'payment_method': orderPaymentsMethod,
      'order_placed': true,
      'total_amount': totalPrice.value,
      'orders': FieldValue.arrayUnion(products),
      'order_confirmed': false,
      'order_ondelivery': false,
      'order_delivered': false,
      'order_date': FieldValue.serverTimestamp(),
    });
    placingOrder(false);
  }

  getProductDetails() {
    products.clear();
    for (var i = 0; i < productsSnapshot.length; i++) {
      products.add({
        'color': productsSnapshot[i]['color'],
        'image': productsSnapshot[i]['image'],
        'quantity': productsSnapshot[i]['quantity'],
        'title': productsSnapshot[i]['title'],
        'vendor_id': productsSnapshot[i]['vendor_id'],
        'total_price': productsSnapshot[i]['total_price'],
      });
    }
  }

  clearCart() {
    for (var i = 0; i < productsSnapshot.length; i++) {
      firestore.collection(cartCollection).doc(productsSnapshot[i].id).delete();
    }
  }
}
