import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shiv/consts/consts.dart';
import 'package:intl/intl.dart' as intl;

Widget senderBubble(DocumentSnapshot data) {
  var t =
      data['created_on'] == null ? DateTime.now() : data['created_on'].toDate();
  var time = intl.DateFormat.Hm().format(t);
  return Directionality(
    textDirection: data['from_id'] == currentUser!.uid ? TextDirection.rtl : TextDirection.ltr,
    child: Container(
      //constraints: BoxConstraints(maxWidth: contex - 60),
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: data['from_id'] == currentUser!.uid ? redColor : darkFontGrey.withOpacity(0.7),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
          bottomLeft: Radius.circular(20),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          "${data['msg']}".text.size(16).color(whiteColor).make(),
          10.heightBox,
          time.text.color(whiteColor.withOpacity(0.5)).make(),
        ],
      ),
    ),
  );
}
