import 'package:shiv/consts/consts.dart';
import 'package:shiv/views/order_screen/components/order_placed_details.dart';
import 'package:shiv/views/order_screen/components/order_status.dart';
import 'package:intl/intl.dart' as intl;

class OrderDetails extends StatelessWidget {
  final dynamic data;
  const OrderDetails({super.key, this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        title: "Order Details"
            .text
            .color(darkFontGrey)
            .fontFamily(semibold)
            .make(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              orderStatus(
                icon: Icons.done,
                color: redColor,
                title: "Order Placed",
                showDone: data['order_placed'],
              ),
              orderStatus(
                icon: Icons.thumb_up,
                color: Colors.blue,
                title: "Order Confirmed",
                showDone: data['order_confirmed'],
              ),
              orderStatus(
                icon: Icons.delivery_dining_outlined,
                color: Colors.green,
                title: "Order On Delivery",
                showDone: data['order_ondelivery'],
              ),
              orderStatus(
                icon: Icons.done_all,
                color: Colors.purple,
                title: "Order Delivered",
                showDone: data['order_delivered'],
              ),
              //const Divider(),
              10.heightBox,
              Column(
                children: [
                  orderPlacedDetails(
                    title1: "Order Code",
                    details1: data['order_id'],
                    title2: "Shipping Method",
                    details2: data['shipping_method'],
                  ),
                  orderPlacedDetails(
                    title1: "Order Date",
                    details1: intl.DateFormat()
                        .add_yMMMEd()
                        .format(data['order_date'].toDate()),
                    title2: "Payment Method",
                    details2: data['payment_method'],
                  ),
                  orderPlacedDetails(
                    title1: "Payment Status",
                    details1: "Unpaid",
                    title2: "Delivery Status",
                    details2: "Order Placed",
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            "Shipping Address".text.fontFamily(bold).make(),
                            "${data['order_by_name']}".text.make(),
                            "${data['order_by_email']}".text.make(),
                            "${data['order_by_address']}".text.make(),
                            "${data['order_by_city']}".text.make(),
                            "${data['order_by_state']}".text.make(),
                            "${data['order_by_phone']}".text.make(),
                            "${data['order_by_postalcode']}".text.make(),
                          ],
                        ),
                        SizedBox(
                          width: 140,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              "Total Amount".text.fontFamily(bold).make(),
                              "${data['total_amount']}"
                                  .text
                                  .color(redColor)
                                  .fontFamily(bold)
                                  .make(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ).box.shadowMd.white.make(),

              10.heightBox,
              "Ordered Product"
                  .text
                  .color(darkFontGrey)
                  .fontFamily(semibold)
                  .size(16)
                  .makeCentered(),
              10.heightBox,
              ListView(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                children: List.generate(data['orders'].length, (index) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      orderPlacedDetails(
                        title1: data['orders'][index]['title'],
                        title2: data['orders'][index]['total_price'],
                        details1: "x${data['orders'][index]['quantity']}",
                        details2: "Refundable",
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Container(
                          height: 10,
                          width: 30,
                          color: Color(data['orders'][index]['color']),
                        ),
                      ),
                      const Divider(),
                    ],
                  );
                }).toList(),
              ).box.shadowSm.margin(const EdgeInsets.only(bottom: 4)).white.make(),
              20.heightBox,              
            ],
          ),
        ),
      ),
    );
  }
}
