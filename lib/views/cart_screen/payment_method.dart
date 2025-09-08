import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:shiv/consts/consts.dart';
import 'package:shiv/consts/lists.dart';
import 'package:shiv/controllers/cart_controller.dart';
import 'package:shiv/views/home_screen/home.dart';
import 'package:shiv/widgets/common/loading_indicator.dart';
import 'package:shiv/widgets/common/our_button.dart';

class PaymentMethod extends StatelessWidget {
  const PaymentMethod({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<CartController>();
    return Obx(
      () => Scaffold(
        backgroundColor: whiteColor,
        appBar: AppBar(
          title: "Choose payment method"
              .text
              .fontFamily(semibold)
              .color(darkFontGrey)
              .make(),
        ),
        bottomNavigationBar: SizedBox(
          height: 60,
          child: controller.placingOrder.value
              ? Center(
                  child: loadingIndicator(),
                )
              : ourButton(
                  color: redColor,
                  textColor: whiteColor,
                  title: "Place my Order",
                  onPress: () async {
                    await controller.placeMyOrder(
                        paymentMethod[controller.paymentIndex.value]);
                    await controller.clearCart();
                    VxToast.show(context, msg: "Order placed Successfully");
                    Get.offAll(() => Home());
                  },
                ),
        ),
        body: Obx(
          () => Column(
            children: List.generate(paymentMethod.length, (index) {
              return GestureDetector(
                onTap: () {
                  controller.changePaymentIndex(index);
                },
                child: Container(
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: controller.paymentIndex.value == index
                            ? redColor
                            : Colors.transparent,
                        width: 5,
                        style: BorderStyle.solid,
                      )),
                  margin: const EdgeInsets.all(8),
                  child: Stack(alignment: Alignment.topRight, children: [
                    Image.asset(
                      paymentMethodList[index],
                      width: double.infinity,
                      height: 120,
                      fit: BoxFit.cover,
                      color: controller.paymentIndex.value == index
                          ? Colors.black.withOpacity(0.4)
                          : Colors.transparent,
                      colorBlendMode: controller.paymentIndex.value == index
                          ? BlendMode.darken
                          : BlendMode.color,
                    ),
                    controller.paymentIndex.value == index
                        ? Transform.scale(
                            scale: 1.3,
                            child: Checkbox(
                                activeColor: Colors.green,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                value: true,
                                onChanged: (value) {}),
                          )
                        : Container(),
                    Positioned(
                        bottom: 10,
                        right: 10,
                        child: paymentMethod[index]
                            .text
                            .white
                            .fontFamily(semibold)
                            .size(16)
                            .make()),
                  ]),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
