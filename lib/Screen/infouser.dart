import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delayed_display/delayed_display.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:kurdivia/Screen/mainpage.dart';
import 'package:kurdivia/Screen/setting.dart';
import 'package:kurdivia/Screen/verifynumber.dart';
import 'package:kurdivia/Widgets/navigatebar.dart';
import 'package:kurdivia/provider/ApiService.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../Widgets/navigatebar.dart';
import '../constant.dart';
import '../provider/ApiService.dart';
import 'country.dart';

class InfoUser extends StatefulWidget {
  const InfoUser({Key? key}) : super(key: key);

  @override
  State<InfoUser> createState() => _InfoUserState();
}

class _InfoUserState extends State<InfoUser> implements ApiStatusLogin, UploadStatus {
  late BuildContext context;
  final phoneController = TextEditingController();
  final codeController = TextEditingController();
  String phone = '';

  @override
  Widget build(BuildContext context) {
    context.read<ApiService>();
    this.context = context;
    return Consumer<ApiService>(
      builder: (context, value, child) {
        value.apiListener(this);
        value.apiListenerUpload(this);
        return SafeArea(
            child: Scaffold(
              body: Stack(
                children: [
                  Container(
                    width: MediaQuery
                        .of(context)
                        .size
                        .width,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/images/2.jpg"),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  Positioned(
                    right: 30,
                    top: 30,
                    child: InkWell(
                      onTap: () {
                        // kNavigator(context, Setting());
                        value.signOut(context);
                      },
                      child: const Image(
                        height: 40,
                        width: 40,
                        image: AssetImage('assets/images/setting.png'),
                      ),
                    ),
                  ),
                  FutureBuilder<DocumentSnapshot>(
                    future: value.getAllUserData(),
                    builder: (BuildContext context,
                        AsyncSnapshot<DocumentSnapshot> snapshot) {
                      if (snapshot.hasError) {
                        return const Center(
                          child: Text("Something went wrong"),
                        );
                      }

                      if (snapshot.hasData && !snapshot.data!.exists) {
                        return const Center(
                          child: Text("Document does not exist"),
                        );
                      }

                      if (snapshot.connectionState == ConnectionState.done) {
                        Map<String, dynamic> data =
                        snapshot.data!.data() as Map<String, dynamic>;
                        return Container(
                          child: Positioned(
                            bottom: 0,
                            child: SizedBox(
                              height: 650,
                              child: Stack(
                                children: [
                                  Align(
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 40),
                                      width: MediaQuery
                                          .of(context)
                                          .size
                                          .width,
                                      height: 570,
                                      decoration: BoxDecoration(
                                          image: DecorationImage(
                                            colorFilter: ColorFilter.mode(
                                                Colors.lightBlue.withOpacity(
                                                    0.5), BlendMode.color),
                                            image: AssetImage(
                                                'assets/images/5.png'),
                                            opacity: 0.5,
                                            fit: BoxFit.cover,
                                          ),
                                          boxShadow: const [
                                            BoxShadow(
                                              color: Colors.black38,
                                              blurRadius: 20,
                                              offset: Offset(0, -20),
                                            )
                                          ],
                                          color: Colors.grey.shade300,
                                          borderRadius: const BorderRadius.only(
                                            topRight: Radius.circular(30),
                                            topLeft: Radius.circular(30),
                                          )),
                                      child: ClipRRect(

                                      ),
                                    ),
                                    alignment: Alignment.bottomCenter,
                                  ),
                                  Container(

                                    padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment
                                          .center,
                                      children: [
                                        const SizedBox(
                                          height: 30,
                                        ),
                                        Stack(
                                          children: [
                                            Container(
                                              child: CircleAvatar(
                                                  radius: 50,
                                                  backgroundColor: kDarkBlue,
                                                  child: (data['image'] == '')
                                                      ? Text(
                                                    data['name']
                                                        .split('')
                                                        .first,
                                                    style: const TextStyle(
                                                        fontWeight:
                                                        FontWeight.bold,
                                                        fontSize: 40,
                                                        color: Colors.black),
                                                  )
                                                      : Center(
                                                    child: ClipRRect(
                                                      borderRadius: BorderRadius
                                                          .circular(50),
                                                      child: Image.network(
                                                          data['image'],fit: BoxFit.fill,height: double.infinity,),
                                                    ),
                                                  )),
                                            ),
                                            Positioned(
                                                bottom: 0,
                                                right: -10,
                                                child: IconButton(
                                                  icon:
                                                  Icon(Icons
                                                      .add_a_photo_outlined,),
                                                  onPressed: () {
                                                    _pickImageFromGallery(
                                                        context);
                                                  },
                                                ))
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 30,
                                        ),
                                        Text(
                                          data['name'],
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 25),
                                        ),
                                        const SizedBox(
                                          height: 30,
                                        ),
                                        Container(
                                          decoration: const BoxDecoration(
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black38,
                                                  blurRadius: 30,
                                                  offset: Offset(0, 10),
                                                )
                                              ]
                                          ),
                                          width: MediaQuery
                                              .of(context)
                                              .size
                                              .width *
                                              0.9,
                                          height: 50,
                                          child: TextField(
                                            controller: value
                                                .fullNameController,
                                            textAlign: TextAlign.center,
                                            decoration: InputDecoration(
                                              fillColor: Colors.white,
                                              filled: true,
                                              suffixIcon: Container(
                                                  padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 10,
                                                      vertical: 10),
                                                  height: 10,
                                                  width: 10,
                                                  child: const Image(
                                                      image: AssetImage(
                                                          'assets/images/user.png'),
                                                      fit: BoxFit.fill)),
                                              hintText: data['name'],

                                              border: OutlineInputBorder(
                                                borderSide: BorderSide.none,
                                                borderRadius: BorderRadius
                                                    .circular(15),
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 30,
                                        ),
                                        Row(
                                          children: [
                                            Container(
                                              decoration: const BoxDecoration(
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.black38,
                                                      blurRadius: 30,
                                                      offset: Offset(0, 10),
                                                    )
                                                  ]
                                              ),
                                              width: MediaQuery
                                                  .of(context)
                                                  .size
                                                  .width *
                                                  0.6,
                                              height: 50,
                                              child: TextField(
                                                enabled: false,
                                                controller: value
                                                    .phoneNumbereditController,
                                                textAlign: TextAlign.center,
                                                decoration: InputDecoration(
                                                  fillColor: Colors.white,
                                                  filled: true,
                                                  suffixIcon: Container(
                                                      padding:
                                                      const EdgeInsets.symmetric(
                                                          horizontal: 10,
                                                          vertical: 10),
                                                      height: 10,
                                                      width: 10,
                                                      child: const Image(
                                                          image: AssetImage(
                                                              'assets/images/smartphone-call.png'),
                                                          fit: BoxFit.fill)),
                                                  hintText: data['phonenumber'],

                                                  border: OutlineInputBorder(
                                                    borderSide: BorderSide.none,
                                                    borderRadius: BorderRadius
                                                        .circular(15),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 20,
                                            ),
                                            InkWell(
                                              onTap: (){
                                                kNavigator(context, VerifyNumber());
                                              },
                                              child: Container(
                                                width: 100,
                                                height: 50,
                                                decoration: BoxDecoration(
                                                  boxShadow: const [
                                                    BoxShadow(
                                                      color: Colors.black38,
                                                      blurRadius: 30,
                                                      offset: Offset(0, 10),
                                                    )
                                                  ],
                                                  color: kDarkBlue,
                                                  borderRadius:
                                                  BorderRadius.circular(15),
                                                ),
                                                child: const Center(
                                                    child: Text(
                                                      'Change',
                                                      style: TextStyle(
                                                          fontWeight: FontWeight
                                                              .bold,
                                                          fontSize: 17),
                                                    )),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 60,
                                        ),
                                        InkWell(
                                          onTap: () {
                                            print(value.phoneNumbereditController.text);
                                            //context.read<ApiService>().signOut(context);
                                            value.occupationController.text =
                                            data['occupation'];
                                            value.locationController.text =
                                            data['location'];
                                            (data['image']
                                                .toString()
                                                .length > 3) ? Provider.of<
                                                ApiService>(
                                                context, listen: false)
                                                .setImagePath(data['image'])
                                            :Provider.of<ApiService>(context, listen: false).setImagePath('');
                                            value.ageController.text =
                                            data['age'];
                                            if (value
                                                .fullNameController.text
                                                .isEmpty) {
                                              value.fullNameController.text =
                                              data['name'];
                                              value.phoneNumbereditController.text =
                                              data['phonenumber'];
                                              value.signUpUser();
                                              print('1');
                                            } else
                                            if (value.phoneNumbereditController
                                                .text.isEmpty) {
                                              value.phoneNumbereditController.text =
                                              data['phonenumber'];
                                              print(
                                                  value.phoneNumbereditController);
                                              value.signUpUser();
                                              print('2');
                                            } else {

                                              print('3');
                                              value.signUpUser();
                                              print(
                                                  value.phoneNumbereditController);
                                            }
                                            print(value.auth.currentUser!.uid);
                                            value.InfoUser();
                                          },
                                          child: Container(
                                            width: 200,
                                            height: 40,
                                            decoration: BoxDecoration(
                                              boxShadow: const [
                                                BoxShadow(
                                                  color: Colors.black38,
                                                  blurRadius: 30,
                                                  offset: Offset(0, 10),
                                                )
                                              ],
                                              color: kDarkBlue,
                                              borderRadius:
                                              BorderRadius.circular(30),
                                            ),
                                            child: const Center(
                                                child: Text(
                                                  'Save',
                                                  style: TextStyle(
                                                      fontWeight: FontWeight
                                                          .bold,
                                                      fontSize: 17),
                                                )),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        Row(
                                          children: [
                                            DelayedDisplay(
                                              slidingCurve: Curves.bounceOut,
                                              slidingBeginOffset: Offset(0, 1),
                                              delay: Duration(
                                                  milliseconds: 500),
                                              child: InkWell(
                                                onTap: () async {
                                                  await Permission.location
                                                      .request();
                                                  var status = await Permission
                                                      .notification.status;
                                                  print(status);
                                                  final url = 'https://www.facebook.com/profile.php?id=100082014637747';
                                                  print(url);
                                                  await launch(url);
                                                  if (await canLaunch(
                                                      url)) {}
                                                },
                                                child: Image(
                                                  image: AssetImage(
                                                      'assets/images/facebook.png'),
                                                  height: 20,
                                                  width: 20,
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 20,
                                            ),
                                            DelayedDisplay(
                                              slidingCurve: Curves.bounceOut,
                                              slidingBeginOffset: Offset(0, 1),
                                              delay: Duration(
                                                  milliseconds: 800),
                                              child: InkWell(
                                                onTap: () async {
                                                  await Permission.location
                                                      .request();
                                                  var status = await Permission
                                                      .notification.status;
                                                  print(status);
                                                  final url = 'https://www.instagram.com/medquizz95/';
                                                  print(url);
                                                  await launch(url);
                                                  if (await canLaunch(
                                                      url)) {}
                                                },
                                                child: Image(
                                                  image: AssetImage(
                                                      'assets/images/instagram.png'),
                                                  height: 20,
                                                  width: 20,
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 20,
                                            ),
                                            DelayedDisplay(
                                              slidingCurve: Curves.bounceOut,
                                              slidingBeginOffset: Offset(0, 1),
                                              delay: Duration(
                                                  milliseconds: 1100),
                                              child: InkWell(
                                                onTap: () async {
                                                  await Permission.location
                                                      .request();
                                                  var status = await Permission
                                                      .notification.status;
                                                  print(status);
                                                  final url = 'https://www.tiktok.com/@medquizz?_t=8UiAcDIuZoT&_r=1';
                                                  print(url);
                                                  await launch(url);
                                                  if (await canLaunch(
                                                      url)) {}
                                                },
                                                child: Image(
                                                  image: AssetImage(
                                                      'assets/images/tik-tok.png'),
                                                  height: 20,
                                                  width: 20,
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 20,
                                            ),
                                            DelayedDisplay(
                                              slidingCurve: Curves.bounceOut,
                                              slidingBeginOffset: Offset(0, 1),
                                              delay: Duration(
                                                  milliseconds: 1400),
                                              child: Image(
                                                image: AssetImage(
                                                    'assets/images/telephone.png'),
                                                height: 20,
                                                width: 20,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }

                      return const Center(
                        child: Text(
                          "loading...",
                          style: TextStyle(color: kDarkBlue, fontSize: 20),
                        ),
                      );
                    },
                  )
                ],
              ),
            ));
      },
    );
  }

  @override
  void inputEmpty() {
    ModeSnackBar.show(
        context, 'username or password empty', SnackBarMode.warning);
  }

  @override
  void inputWrong() {
    ModeSnackBar.show(
        context, 'username or password incorrect', SnackBarMode.warning);
  }

  @override
  void login() {
    kNavigator(context, const NavigateBar());
  }

  @override
  void passwordWeak() {
    ModeSnackBar.show(context, 'password is weak', SnackBarMode.warning);
  }

  @override
  void accountAvailable() {
    // TODO: implement accountAvailable
  }

  @override
  void error() {
    ModeSnackBar.show(context, 'something go wrong', SnackBarMode.error);
  }

  @override
  void uploaded() {
    ModeSnackBar.show(context, 'Updated Profile', SnackBarMode.success);
  }

  @override
  void uploading() {
    // TODO: implement uploading
  }
}

Future<void> _pickImageFromGallery(BuildContext context) async {
  final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
  if (pickedFile != null) {
    context.read<ApiService>().updateProfileImage(pickedFile.path,);
  }
}
