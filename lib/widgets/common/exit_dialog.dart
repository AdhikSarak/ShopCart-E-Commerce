import 'package:flutter/services.dart';
import 'package:shiv/consts/consts.dart';
import 'package:shiv/widgets/common/our_button.dart';

Widget exitDialog(context) {
  return Dialog(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        "Confirm".text.fontFamily(bold).size(18).color(darkFontGrey).make(),
        const Divider(),
        10.heightBox,
        "Are you sure? Do you want to Exit?"
            .text
            .size(16)
            .color(darkFontGrey)
            .make(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ourButton(
              color: whiteColor,
              onPress: () {
                SystemNavigator.pop();
              },
              textColor: redColor,
              title: "Yes",
            ),
            //10.widthBox,
            ourButton(
              color: redColor,
              onPress: () {
                Navigator.pop(context);
              },
              textColor: whiteColor,
              title: "No",
            )
          ],
        )
      ],
    ).box.roundedSM.padding(EdgeInsets.all(12)).color(lightGrey).make(),
  );
}
