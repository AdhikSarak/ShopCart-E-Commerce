import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:shiv/consts/consts.dart';
import 'package:shiv/controllers/product_controller.dart';
import 'package:shiv/services/firestore_services.dart';
import 'package:shiv/views/category_screen/item_details.dart';
import 'package:shiv/widgets/common/bg_widget.dart';
import 'package:shiv/widgets/common/loading_indicator.dart';

class CategoryDetails extends StatelessWidget {
  final String? title;
  const CategoryDetails({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<ProductController>();
    return PopScope(
      canPop: true,
      onPopInvoked: (didPop) {
        controller.resetSubcatIndex();
      },
      child: bgWidget(
        Scaffold(
          appBar: AppBar(
            leading: IconButton(
              onPressed: () {
                Get.back();
                controller.resetSubcatIndex();
              },
              icon: const Icon(Icons.arrow_back)),
            title: title!.text.fontFamily(bold).white.make(),
          ),
          body: Obx(() =>Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List.generate(
                        controller.subcat.length,
                        (index) => "${controller.subcat[index]}"
                                .text
                                .size(controller.selectedSubcat.value == index ? 14 : 12)
                                .fontFamily(controller.selectedSubcat.value == index ? bold : semibold)
                                .color(controller.selectedSubcat.value == index ? redColor : darkFontGrey)
                                .makeCentered()
                                .box
                                .color(controller.selectedSubcat.value == index ? whiteColor : whiteColor.withOpacity(0.7))
                                .rounded
                                .margin(EdgeInsets.symmetric(horizontal: 4))
                                .size(120, 60)
                                .make()
                                .onTap(() {
                              controller.changeSelectedSubcat(index);
                            })),
                  ),
                ),
                20.heightBox,
                
                StreamBuilder(
                    stream: FirestoreServices.getSubCategoryProducts(controller.subcat[controller.selectedSubcat.value]),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapsot) {
                      if (!snapsot.hasData) {
                        return Expanded(
                          child: Center(
                            child: loadingIndicator(),
                          ),
                        );
                      } else if (snapsot.data!.docs.isEmpty) {
                        return Expanded(
                          child: Center(
                            child: "No Products Found in this Category"
                                .text
                                .color(redColor)
                                .makeCentered(),
                          ),
                        );
                      } else {
                        var data = snapsot.data!.docs;
                        return Expanded(
                            child: Container(
                          child: GridView.builder(
                              physics: BouncingScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: data.length,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisSpacing: 8,
                                      crossAxisCount: 2,
                                      mainAxisExtent: 250,
                                      mainAxisSpacing: 8),
                              itemBuilder: (context, index) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Image.network(
                                      data[index]['p_images'][0],
                                      width: 200,
                                      height: 150,
                                      fit: BoxFit.cover,
                                    ),
                                    "${data[index]['p_name']}"
                                        .text
                                        .color(darkFontGrey)
                                        .fontFamily(semibold)
                                        .make(),
                                    10.heightBox,
                                    "${data[index]['p_price']}"
                                        .text
                                        .color(redColor)
                                        .fontFamily(bold)
                                        .size(16)
                                        .make()
                                  ],
                                )
                                    .box
                                    .white
                                    .outerShadowSm
                                    .roundedSM
                                    .padding(const EdgeInsets.all(12))
                                    .make()
                                    .onTap(() {
                                  controller.checkIfFav(data[index]);
                                  Get.to(
                                    () => ItemDetailsScreen(
                                      title: data[index]['p_name'],
                                      data: data[index],
                                    ),
                                  );
                                });
                              }),
                        ));
                      }
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
