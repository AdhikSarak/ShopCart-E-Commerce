import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:shiv/consts/consts.dart';
import 'package:shiv/controllers/cart_controller.dart';
import 'package:shiv/views/cart_screen/payment_method.dart';
import 'package:shiv/widgets/common/custom_textfield.dart';
import 'package:shiv/widgets/common/our_button.dart';

class ShippingScreen extends StatelessWidget {
  const ShippingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<CartController>();
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        title: "Shipping Info"
            .text
            .fontFamily(semibold)
            .color(darkFontGrey)
            .make(),
      ),
      bottomNavigationBar: SizedBox(
        height: 60,
        child: ourButton(
          color: redColor,
          textColor: whiteColor,
          title: "Continue",
          onPress: () {
            if (controller.addressController.text.length > 10 && controller.cityController.text.isNotEmpty && controller.stateController.text.isNotEmpty && controller.phoneController.text.isNotEmpty && controller.postalCodeController.text.isNotEmpty) {
              Get.to(() => PaymentMethod());
            } else {
              VxToast.show(context, msg: "Please fill the form");
            }
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            customTextfield(
              hint: "Address",
              isPass: false,
              title: "Address",
              controller: controller.addressController,
            ),
            customTextfield(
              hint: "City",
              isPass: false,
              title: "City",
              controller: controller.cityController,
            ),
            customTextfield(
              hint: "State",
              isPass: false,
              title: "State",
              controller: controller.stateController,
            ),
            customTextfield(
              hint: "Postal Code",
              isPass: false,
              title: "Postal Code",
              controller: controller.postalCodeController,
            ),
            customTextfield(
              hint: "Phone",
              isPass: false,
              title: "Phone",
              controller: controller.phoneController,
            ),
          ],
        ),
      ),
    );
  }
}
