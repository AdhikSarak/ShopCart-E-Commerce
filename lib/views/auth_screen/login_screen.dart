import 'package:get/get.dart';
import 'package:shiv/consts/consts.dart';
import 'package:shiv/consts/lists.dart';
import 'package:shiv/controllers/auth_controller.dart';
import 'package:shiv/views/auth_screen/signup_screen.dart';
import 'package:shiv/views/home_screen/home.dart';
import 'package:shiv/widgets/common/applogo_widget.dart';
import 'package:shiv/widgets/common/bg_widget.dart';
import 'package:shiv/widgets/common/custom_textfield.dart';
import 'package:shiv/widgets/common/our_button.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(AuthController());
    return bgWidget(Scaffold(
      resizeToAvoidBottomInset: false,
      body: Center(
        child: Column(
          children: [
            (context.screenHeight * 0.1).heightBox,
            applogoWidget(),
            10.heightBox,
            "Log in to $appname".text.white.fontFamily(bold).size(18).make(),
            15.heightBox,
            Obx(
              () => Column(
                children: [
                  customTextfield(
                      controller: controller.emailController,
                      hint: emailHint,
                      title: email,
                      isPass: false),
                  customTextfield(
                      controller: controller.passController,
                      hint: passwordHint,
                      title: password,
                      isPass: true),
                  Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {},
                        child: forgetPass.text.make(),
                      )),
                  5.heightBox,
                  controller.isLoading.value
                      ? const CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation(redColor),
                        )
                      : ourButton(
                          color: redColor,
                          textColor: whiteColor,
                          title: login,
                          onPress: () async {
                            controller.isLoading(true);
                            await controller.loginMethod(context).then((value) {
                              if (value != null) {
                                VxToast.show(context, msg: loggedIn);
                                Get.offAll(() => const Home());
                              } else {
                                controller.isLoading(false);
                              }
                            });
                            //controller.isLoading(false);
                          }).box.width(context.screenWidth - 50).make(),
                  5.heightBox,
                  createNewAccount.text.color(fontGrey).make(),
                  5.heightBox,
                  ourButton(
                      color: lightGolden,
                      textColor: redColor,
                      title: signUp,
                      onPress: () {
                        Get.to(() => const SignupScreen());
                      }).box.width(context.screenWidth - 50).make(),
                  10.heightBox,
                  loginWith.text.color(fontGrey).make(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                        3,
                        (index) => Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CircleAvatar(
                                radius: 25,
                                backgroundColor: lightGrey,
                                child: Image.asset(
                                  socialIconList[index],
                                  width: 30,
                                ),
                              ),
                            )),
                  ),
                ],
              )
                  .box
                  .white
                  .rounded
                  .padding(const EdgeInsets.all(16))
                  .width(context.screenWidth - 70)
                  .shadowMd
                  .make(),
            ),
          ],
        ),
      ),
    ));
  }
}
