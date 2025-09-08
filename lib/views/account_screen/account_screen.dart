import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:shiv/consts/consts.dart';
import 'package:shiv/consts/lists.dart';
import 'package:shiv/controllers/account_controller.dart';
import 'package:shiv/controllers/auth_controller.dart';
import 'package:shiv/services/firestore_services.dart';
import 'package:shiv/views/account_screen/components/details_card.dart';
import 'package:shiv/views/account_screen/components/edit_profile_screen.dart';
import 'package:shiv/views/auth_screen/login_screen.dart';
import 'package:shiv/views/chat_screen/messaging_screen.dart';
import 'package:shiv/views/order_screen/order_screen.dart';
import 'package:shiv/views/wishlist_screen/wishlist_screen.dart';
import 'package:shiv/widgets/common/bg_widget.dart';
import 'package:shiv/widgets/common/loading_indicator.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(AccountController());
    return bgWidget(Scaffold(
      body: StreamBuilder(
          stream: FirestoreServices.getUser(currentUser!.uid),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(redColor),
                ),
              );
            } else {
              var data = snapshot.data!.docs[0];
              return SafeArea(
                  child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: const Align(
                      alignment: Alignment.topRight,
                      child: Icon(
                        Icons.edit,
                        color: whiteColor,
                      ),
                    ).onTap(() {
                      controller.nameController.text = data['name'];
                      Get.to(() => EditProfileScreen(
                            data: data,
                          ));
                    }),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      children: [
                        data['imageUrl'] == ''
                            ? CircleAvatar(
                                radius: 50,
                                backgroundImage: AssetImage(imgProfile),
                              )
                            : CircleAvatar(
                                radius: 50,
                                backgroundImage: NetworkImage(data['imageUrl']),
                              ),
                        /*
                             Image.asset(imgProfile2,
                                    width: 100, fit: BoxFit.cover)
                                .box
                                .roundedFull
                                .clip(Clip.antiAlias)
                                .make()
                            : Image.network(data['imageUrl'],
                                    width: 100, fit: BoxFit.cover)
                                .box
                                .roundedFull
                                .clip(Clip.antiAlias)
                                .make(),*/
                        10.widthBox,
                        Expanded(
                            child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            "${data['name']}"
                                .text
                                .fontFamily(semibold)
                                .white
                                .make(),
                            "${data['email']}".text.white.make(),
                          ],
                        )),
                        OutlinedButton(
                            style: OutlinedButton.styleFrom(
                                side: const BorderSide(
                              color: whiteColor,
                            )),
                            onPressed: () async {
                              await Get.put(AuthController())
                                  .signOutMethod(context);
                              Get.offAll(() => const LoginScreen());
                            },
                            child:
                                logout.text.fontFamily(semibold).white.make()),
                      ],
                    ),
                  ),
                  10.heightBox,
                  FutureBuilder(
                      future: FirestoreServices.getCount(),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (!snapshot.hasData) {
                          return Center(
                            child: loadingIndicator(),
                          );
                        } else {
                          var data = snapshot.data;
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              detailsCard(
                                count: data[0].toString(),
                                title: "Cart",
                                width: context.screenWidth / 3.4,
                              ),
                              detailsCard(
                                count: data[1].toString(),
                                title: "WishList",
                                width: context.screenWidth / 3.4,
                              ),
                              detailsCard(
                                count: data[2].toString(),
                                title: "Orders",
                                width: context.screenWidth / 3.4,
                              ),
                            ],
                          );
                        }
                      }),
                  /*
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      detailsCard(
                        count: data['cart_count'],
                        title: "Cart",
                        width: context.screenWidth / 3.4,
                      ),
                      detailsCard(
                        count: data['wishlist_count'],
                        title: "WishList",
                        width: context.screenWidth / 3.4,
                      ),
                      detailsCard(
                        count: data['order_count'],
                        title: "Orders",
                        width: context.screenWidth / 3.4,
                      ),
                    ],
                  ),
                  */
                  ListView.separated(
                          shrinkWrap: true,
                          itemBuilder: (BuildContext context, index) {
                            return ListTile(
                              onTap: () {
                                switch (index) {
                                  case 0:
                                    Get.to(() => OrderScreen());
                                    break;
                                  case 1:
                                    Get.to(() => WishlistScreen());
                                    break;
                                  case 2:
                                    Get.to(() => MessagingScreen());
                                    break;
                                }
                              },
                              leading: Image.asset(
                                profilebuttonIcon[index],
                                width: 22,
                              ),
                              title: profileButtonList[index]
                                  .text
                                  .color(darkFontGrey)
                                  .fontFamily(semibold)
                                  .make(),
                            );
                          },
                          separatorBuilder: (context, index) {
                            return const Divider(color: lightGrey);
                          },
                          itemCount: profileButtonList.length)
                      .box
                      .white
                      .rounded
                      .shadowSm
                      .margin(const EdgeInsets.all(12))
                      .padding(const EdgeInsets.symmetric(horizontal: 16))
                      .make()
                      .box
                      .color(redColor)
                      .make(),
                ],
              ));
            }
          }),
    ));
  }
}
