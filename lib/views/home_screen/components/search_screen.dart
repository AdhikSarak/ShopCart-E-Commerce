import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shiv/consts/colors.dart';
import 'package:shiv/consts/consts.dart';
import 'package:shiv/services/firestore_services.dart';
import 'package:shiv/views/category_screen/item_details.dart';
import 'package:shiv/widgets/common/loading_indicator.dart';

class SearchScreen extends StatelessWidget {
  final String? title;
  const SearchScreen({super.key, this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(),
      body: FutureBuilder(
        future: FirestoreServices.searchProducts(title),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: loadingIndicator(),
            );
          } else if (snapshot.data!.docs.isEmpty) {
            return "Product Not Found"
                .text
                .color(redColor)
                .fontFamily(semibold)
                .makeCentered();
          } else {
            var data = snapshot.data!.docs
                .where((element) => element['p_name']
                    .toString()
                    .toLowerCase()
                    .contains(title!.toLowerCase()))
                .toList();
            /*
            return ListView.builder(
              itemCount: data.length,
                itemBuilder: (BuildContext context, int index) {
              return ListTile(
                title: "${data[index]['p_name']}".text.make(),
              );
            });
            */
            return GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: data.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                mainAxisExtent: 300,
              ),
              itemBuilder: ((context, index) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.network(
                      data[index]['p_images'][0],
                      width: 200,
                      height: 200,
                      fit: BoxFit.cover,
                    ),
                    const Spacer(),
                    "${data[index]['p_name']}"
                        .text
                        .color(darkFontGrey)
                        .fontFamily(semibold)
                        .make(),
                    10.heightBox,
                    "${data[index]['p_price']}"
                        .numCurrency
                        .text
                        .color(redColor)
                        .fontFamily(bold)
                        .size(16)
                        .make()
                  ],
                )
                    .box
                    .white
                    //.margin(EdgeInsets.symmetric(horizontal: 4))
                    .roundedSM
                    .padding(const EdgeInsets.all(12))
                    .make()
                    .onTap(() {
                  Get.to(() => ItemDetailsScreen(
                        title: "${data[index]['p_name']}",
                        data: data[index],
                      ));
                });
              }),
            );
          }
        },
      ),
    );
  }
}
