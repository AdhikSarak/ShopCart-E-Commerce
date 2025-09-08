import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:shiv/consts/consts.dart';
import 'package:shiv/controllers/chats_controller.dart';
import 'package:shiv/services/firestore_services.dart';
import 'package:shiv/views/chat_screen/components/sender_bubble.dart';
import 'package:shiv/widgets/common/loading_indicator.dart';

class ChatScreen extends StatelessWidget {
  ChatScreen({super.key});

  final ScrollController _controller = ScrollController();

// This is what you're looking for!
  void _scrollDown() {
    _controller.animateTo(
      _controller.position.maxScrollExtent,
      duration: Duration(seconds: 1),
      curve: Curves.fastOutSlowIn,
    );
  }

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(ChatController());
    
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        title: "${controller.friendName}"
            .text
            .fontFamily(semibold)
            .color(darkFontGrey)
            .make(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Obx(
              () => controller.isLoading.value
                  ? Center(
                      child: loadingIndicator(),
                    )
                  : Expanded(
                      child: StreamBuilder(
                        stream: FirestoreServices.getAllChatMessages(
                            controller.chatDocId.toString()),
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (!snapshot.hasData) {
                            return Center(
                              child: loadingIndicator(),
                            );
                          } else if (snapshot.data!.docs.isEmpty) {
                            return Center(
                              child: "You haven't started chatting yet."
                                  .text
                                  .color(redColor)
                                  .fontFamily(semibold)
                                  .size(20)
                                  .make(),
                            );
                          } else {
                            return ListView(
                              controller: _controller,
                              children: snapshot.data!.docs
                                  .mapIndexed((currentValue, index) {
                                var data = snapshot.data!.docs[index];
                                return Align(
                                    alignment:
                                        data['from_id'] == currentUser!.uid
                                            ? Alignment.centerRight
                                            : Alignment.centerLeft,
                                    child: senderBubble(data));
                              }).toList(),
                            );
                          }
                        },
                      ),
                    ),
            ),
            10.heightBox,
            Row(
              children: [
                Expanded(
                    child: TextFormField(
                  controller: controller.messageController,
                  decoration: const InputDecoration(
                      hintText: "Type a Message",
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: textfieldGrey,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                        color: redColor,
                      ))),
                )),
                IconButton(
                  onPressed: () {
                    controller.sendMessage(controller.messageController.text);
                    _scrollDown();
                    controller.messageController.clear();
                  },
                  icon: const Icon(Icons.send),
                  color: redColor,
                )
              ],
            )
                .box
                .height(80)
                .margin(const EdgeInsets.only(bottom: 8))
                .padding(const EdgeInsets.all(12))
                .make()
          ],
        ),
      ),
    );
  }
}
