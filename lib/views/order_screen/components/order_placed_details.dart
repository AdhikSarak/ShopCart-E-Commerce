import 'package:shiv/consts/consts.dart';

Widget orderPlacedDetails({title1, details1, title2, details2}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          "$title1".text.fontFamily(bold).make(),
          "$details1".text.fontFamily(semibold).color(redColor).make(),
        ]),
        SizedBox(
          width: 140,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              "$title2".text.fontFamily(bold).make(),
              "$details2".text.fontFamily(semibold).make(),
            ],
          ),
        )
      ],
    ),
  );
}
