import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:shiv/consts/consts.dart';
import 'package:shiv/services/firestore_services.dart';
import 'package:shiv/views/order_screen/order_details.dart';
import 'package:shiv/widgets/common/loading_indicator.dart';

class OrderScreen extends StatelessWidget {
  const OrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        title: "My Orders".text.color(darkFontGrey).fontFamily(semibold).make(),
      ),
      body: StreamBuilder(
          stream: FirestoreServices.getAllOrders(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: loadingIndicator(),
              );
            } else if (snapshot.data!.docs.isEmpty) {
              return Center(
                child: "You have not placed any Order"
                    .text
                    .color(redColor)
                    .size(20)
                    .fontFamily(semibold)
                    .make(),
              );
            } else {
              var data = snapshot.data!.docs;
              return ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: "${index + 1}"
                        .text
                        .fontFamily(bold)
                        .xl
                        .color(darkFontGrey)
                        .make(),
                    title: data[index]['order_id']
                        .toString()
                        .text
                        .color(redColor)
                        .fontFamily(semibold)
                        .make(),
                    subtitle: data[index]['total_amount']
                        .toString()
                        .numCurrency
                        .text
                        .fontFamily(semibold)
                        .make(),
                    trailing: IconButton(
                        onPressed: () {
                          Get.to(() => OrderDetails(data: data[index],));
                        },
                        icon: Icon(Icons.arrow_forward_ios_rounded)),
                  );
                },
              );
            }
          }),
    );
  }
}
