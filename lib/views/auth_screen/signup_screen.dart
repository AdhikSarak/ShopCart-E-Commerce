import 'package:get/get.dart';
import 'package:shiv/consts/consts.dart';
import 'package:shiv/controllers/auth_controller.dart';
import 'package:shiv/views/home_screen/home.dart';
import 'package:shiv/widgets/common/applogo_widget.dart';
import 'package:shiv/widgets/common/bg_widget.dart';
import 'package:shiv/widgets/common/custom_textfield.dart';
//import 'package:shiv/widgets/common/my_checkbox.dart';
import 'package:shiv/widgets/common/our_button.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  bool? isChecked = false;
  var controller = Get.put(AuthController());

  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController passController = TextEditingController();
  TextEditingController repassController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return bgWidget(Scaffold(
      resizeToAvoidBottomInset: false,
      body: Center(
        child: Column(
          children: [
            (context.screenHeight * 0.1).heightBox,
            applogoWidget(),
            10.heightBox,
            "Join the $appname".text.white.fontFamily(bold).size(18).make(),
            15.heightBox,
            Obx(
              () => Column(
                children: [
                  customTextfield(
                      controller: nameController,
                      hint: nameHint,
                      title: name,
                      isPass: false),
                  customTextfield(
                      controller: emailController,
                      hint: emailHint,
                      title: email,
                      isPass: false),
                  customTextfield(
                      isPass: true,
                      controller: passController,
                      hint: passwordHint,
                      title: password),
                  customTextfield(
                      isPass: true,
                      controller: repassController,
                      hint: retypePassHint,
                      title: retypePass),
                  5.heightBox,
                  Row(
                    children: [
                      Checkbox(
                          activeColor: redColor,
                          checkColor: whiteColor,
                          value: isChecked,
                          onChanged: (newValue) {
                            setState(() {
                              isChecked = newValue;
                            });
                          }),
                      //const MyCheckbox(),
                      10.widthBox,
                      Expanded(
                        child: RichText(
                            text: const TextSpan(children: [
                          TextSpan(
                            text: "I agree to the ",
                            style: TextStyle(
                              fontFamily: regular,
                              color: fontGrey,
                            ),
                          ),
                          TextSpan(
                            text: termsAndCondi,
                            style: TextStyle(
                              fontFamily: regular,
                              color: redColor,
                            ),
                          ),
                          TextSpan(
                            text: " & ",
                            style: TextStyle(
                              fontFamily: regular,
                              color: fontGrey,
                            ),
                          ),
                          TextSpan(
                            text: privacyPolicy,
                            style: TextStyle(
                              fontFamily: regular,
                              color: redColor,
                            ),
                          ),
                        ])),
                      )
                    ],
                  ),
                  5.heightBox,
                  controller.isLoading.value
                      ? const CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation(redColor),
                        )
                      : ourButton(
                          color: isChecked == true ? redColor : lightGrey,
                          textColor: whiteColor,
                          title: signUp,
                          onPress: () async {
                            if (isChecked != false) {
                              try {
                                controller.isLoading(true);
                                await controller
                                    .signUpMethod(
                                        context: context,
                                        email: emailController.text,
                                        password: passController.text)
                                    .then((value) async {
                                  return await controller.storeUserData(
                                    uid: value!.user!.uid,
                                    email: emailController.text,
                                    password: passController.text,
                                    name: nameController.text,
                                  ).then((value) {
                                  VxToast.show(context, msg: loggedIn);
                                  Get.offAll(() => const Home());
                                });
                                });
                              } catch (e) {
                                auth.signOut();
                                VxToast.show(context, msg: loggedOut);
                                controller.isLoading(false);
                              }
                            }
                          }).box.width(context.screenWidth - 50).make(),
                  10.heightBox,
                  RichText(
                    text: const TextSpan(children: [
                      TextSpan(
                          text: alreadyHaveAcc,
                          style: TextStyle(
                            fontFamily: bold,
                            color: fontGrey,
                          )),
                      TextSpan(
                          text: login,
                          style: TextStyle(
                            fontFamily: bold,
                            color: redColor,
                          )),
                    ]),
                  ).onTap(() {
                    Get.back();
                  }),
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
