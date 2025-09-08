import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shiv/consts/consts.dart';
import 'package:shiv/services/firestore_services.dart';
import 'package:shiv/widgets/common/loading_indicator.dart';

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        title:
            "My Wishlist".text.color(darkFontGrey).fontFamily(semibold).make(),
      ),
      body: StreamBuilder(
          stream: FirestoreServices.getWishlist(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: loadingIndicator(),
              );
            } else if (snapshot.data!.docs.isEmpty) {
              return Center(
                child: "You still haven't added anything to wishlist"
                    .text
                    .color(redColor)
                    .size(20)
                    .fontFamily(semibold)
                    .makeCentered(),
              );
            } else {
              var data = snapshot.data!.docs;
              return Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: data.length,
                        itemBuilder: (BuildContext context, int index) {
                          return ListTile(
                            leading: Image.network(
                              '${data[index]['p_images'][0]}',
                              width: 80,
                              fit: BoxFit.cover,
                            ),
                            title: '${data[index]['p_name']}'
                                .text
                                .fontFamily(semibold)
                                .size(16)
                                .make(),
                            subtitle: '${data[index]['p_price']}'
                                .numCurrency
                                .text
                                .fontFamily(semibold)
                                .color(redColor)
                                .make(),
                            trailing: IconButton(
                              onPressed: () {
                                firestore
                                    .collection(productsCollection)
                                    .doc(data[index].id)
                                    .set({
                                      'p_wishlist': FieldValue.arrayRemove([currentUser!.uid]),
                                    }, SetOptions(merge: true));
                              },
                              icon: const Icon(Icons.favorite),
                              color: redColor,
                            ),
                          );
                        }),
                  ),
                ],
              );
            }
          }),
    );
  }
}
