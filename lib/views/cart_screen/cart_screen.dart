import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:shiv/consts/consts.dart';
import 'package:shiv/controllers/cart_controller.dart';
import 'package:shiv/services/firestore_services.dart';
import 'package:shiv/views/cart_screen/shipping_screen.dart';
import 'package:shiv/widgets/common/loading_indicator.dart';
import 'package:shiv/widgets/common/our_button.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(CartController());
    return Scaffold(
      bottomNavigationBar: SizedBox(
        height: 60,
        child: ourButton(
          onPress: () {
            Get.to(
              () => ShippingScreen(),
            );
          },
          color: redColor,
          textColor: whiteColor,
          title: "Proceed to Checkout",
        ),
      ),
      backgroundColor: whiteColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: "Shopping Cart"
            .text
            .color(darkFontGrey)
            .fontFamily(semibold)
            .make(),
      ),
      body: StreamBuilder(
          stream: FirestoreServices.getCart(currentUser!.uid),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: loadingIndicator(),
              );
            } else if (snapshot.data!.docs.isEmpty) {
              return Center(
                child: "Cart is Empty".text.color(darkFontGrey).make(),
              );
            } else {
              var data = snapshot.data!.docs;
              controller.calculate(data);
              controller.productsSnapshot = data;
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                          itemCount: data.length,
                          itemBuilder: (BuildContext context, int index) {
                            return ListTile(
                              leading: Image.network(
                                '${data[index]['image']}',
                                width: 80,
                                fit: BoxFit.cover,
                              ),
                              title:
                                  '${data[index]['title']} (x${data[index]['quantity']})'
                                      .text
                                      .fontFamily(semibold)
                                      .size(16)
                                      .make(),
                              subtitle: '${data[index]['total_price']}'
                                  .numCurrency
                                  .text
                                  .fontFamily(semibold)
                                  .color(redColor)
                                  .make(),
                              trailing: IconButton(
                                onPressed: () {
                                  FirestoreServices.deleteDocument(
                                      data[index].id);
                                },
                                icon: const Icon(Icons.delete),
                                color: redColor,
                              ),
                            );
                          }),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        "Total Price"
                            .text
                            .fontFamily(semibold)
                            .color(darkFontGrey)
                            .make(),
                        Obx(
                          () => "${controller.totalPrice}"
                              .numCurrency
                              .text
                              .fontFamily(bold)
                              .color(redColor)
                              .make(),
                        ),
                      ],
                    )
                        .box
                        .padding(const EdgeInsets.all(12))
                        .width(context.screenWidth - 60)
                        .color(lightGolden)
                        .roundedSM
                        .make(),
                    10.heightBox,
                    /*
                    SizedBox(
                      width: context.screenWidth - 60,
                      child: ourButton(
                        onPress: () {},
                        color: redColor,
                        textColor: whiteColor,
                        title: "Proceed to Checkout",
                      ),
                    ), */
                  ],
                ),
              );
            }
          }),
    );
  }
}
