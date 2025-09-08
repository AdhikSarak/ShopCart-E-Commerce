import 'package:get/get.dart';
import 'package:shiv/consts/consts.dart';
import 'package:shiv/controllers/home_controller.dart';
import 'package:shiv/views/account_screen/account_screen.dart';
import 'package:shiv/views/cart_screen/cart_screen.dart';
import 'package:shiv/views/category_screen/category_screen.dart';
import 'package:shiv/views/home_screen/home_screen.dart';
import 'package:shiv/widgets/common/exit_dialog.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(HomeController());
    var navBarItems = [
      BottomNavigationBarItem(
          icon: Image.asset(
            icHome,
            width: 26,
          ),
          label: home),
      BottomNavigationBarItem(
          icon: Image.asset(
            icCategories,
            width: 26,
          ),
          label: categories),
      BottomNavigationBarItem(
          icon: Image.asset(
            icCart,
            width: 26,
          ),
          label: cart),
      BottomNavigationBarItem(
          icon: Image.asset(
            icProfile,
            width: 26,
          ),
          label: account),
    ];

    var navBody = [
      const HomeScreen(),
      const CategoryScreen(),
      const CartScreen(),
      const AccountScreen(),
    ];
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        showDialog(
          barrierDismissible: false,
          context: context, 
          builder: (context) => exitDialog(context)
        );
      },
      child: Scaffold(
        body: Column(
          children: [
            Obx(
              () => Expanded(
                child: navBody.elementAt(controller.currNavIndex.value),
              ),
            ),
          ],
        ),
        bottomNavigationBar: Obx(
          () => BottomNavigationBar(
            currentIndex: controller.currNavIndex.value,
            selectedItemColor: redColor,
            selectedLabelStyle: const TextStyle(fontFamily: semibold),
            type: BottomNavigationBarType.fixed,
            backgroundColor: whiteColor,
            items: navBarItems,
            onTap: (value) {
              controller.currNavIndex.value = value;
            },
          ),
        ),
      ),
    );
  }
}
