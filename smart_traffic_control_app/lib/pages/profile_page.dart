import 'package:flutter/material.dart';
import 'package:smart_traffic_control_app/components/my_button.dart';
import 'package:smart_traffic_control_app/components/my_scrollbar.dart';
import 'package:smart_traffic_control_app/components/my_textfield.dart';
import 'package:smart_traffic_control_app/constants/style_constants.dart';
import 'package:smart_traffic_control_app/constants/text_constants.dart';
import 'package:smart_traffic_control_app/models/user.dart';
import 'package:smart_traffic_control_app/services/auth_service.dart';
import 'package:smart_traffic_control_app/services/hive_service.dart';

class UserProfilePage extends StatefulWidget {

  const UserProfilePage({super.key});

  @override
  State<UserProfilePage> createState() => _IntersectionPageState();
}


class _IntersectionPageState extends State<UserProfilePage> {
  late User user;
  late TextEditingController firstNameController;
  late TextEditingController lastNameController;
  late TextEditingController phoneNumberController;
  late TextEditingController countryController;
  late TextEditingController countyOrStateController;
  late TextEditingController cityController;

  final double topContainerPercentage = 0.3; //bottom percentage will be the rest of the page

  late bool _isSaving;

  @override
  void initState() {
     user = HiveService().getUser()!;

    lastNameController = TextEditingController(text: user.lastName);
    firstNameController = TextEditingController(text: user.firstName);
    phoneNumberController = TextEditingController(text: user.phoneNumber);
    countryController = TextEditingController(text: user.country);
    countyOrStateController = TextEditingController(text: user.countyOrState);
    cityController = TextEditingController(text: user.city);

    _isSaving = false;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        color: backgroundColor,
        child: Form(
          child: Column(
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.height * topContainerPercentage,
                color: primaryHeaderColor,
                child: const Center(
                  child: SafeArea(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(appTitle, style: TextStyle(fontSize: 45.0, color: primaryTextColor, fontWeight: FontWeight.bold)),
                        SizedBox(
                          height: 20,
                        ),
                        //Add Profile Icon
                        Icon(
                          Icons.person,
                          size: 100,
                          color: primaryTextColor,
                        )
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * (1 - topContainerPercentage),
                child: MyScrollbar(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Padding(
                          padding: EdgeInsets.fromLTRB(35.0, 30.0, 0.0, 15.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text('Edit Profile',
                                  style: TextStyle(
                                    fontSize: 30.0,
                                    color: primaryTextColor,
                                  )),
                            ],
                          ),
                        ),
                        MyTextField(
                          controller: firstNameController,
                          hintText: 'First Name',
                          obscureText: false,
                        ),
                        MyTextField(
                          controller: lastNameController,
                          hintText: 'Last Name',
                          obscureText: false,
                        ),
                        MyTextField(
                          controller: phoneNumberController,
                          hintText: 'Phone Number',
                          obscureText: false,
                        ),
                        MyTextField(
                          controller: countryController,
                          hintText: 'Country',
                          obscureText: false,
                        ),
                        MyTextField(
                          controller: countyOrStateController,
                          hintText: 'County/State',
                          obscureText: false,
                        ),
                        MyTextField(
                          controller: cityController,
                          hintText: 'City',
                          obscureText: false,
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(40.0, 15.0, 35.0, 20.0),
                          child: Column(
                            children: [
                              MyButton(
                                  buttonColor: utilityButtonColor,
                                  textColor: buttonTextColor,
                                  buttonText: _isSaving ? 'Saving...' : 'Save',
                                  onPressed: _isSaving ? null : () async {

                                        setState(() {
                                        _isSaving = true;
                                        });

                                        showDialog(
                                          context: context,
                                          barrierDismissible: false, // User cannot dismiss it
                                          builder: (BuildContext context) {
                                            return const Center(child: CircularProgressIndicator(color: utilityButtonColor));
                                          },
                                        );

                                        try {
                                          user = User(
                                            id: user.id,
                                            email: user.email,
                                            username: user.username,
                                            firstName: firstNameController.text,
                                            lastName: lastNameController.text,
                                            phoneNumber: phoneNumberController.text,
                                            country: countryController.text,
                                            countyOrState: countyOrStateController.text,
                                            city: cityController.text,
                                          );

                                          await AuthService.updateCurrentUser(user);

                                          if (context.mounted) Navigator.of(context, rootNavigator: true).pop();
                                          if (context.mounted) {
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              const SnackBar(
                                                content: Text(
                                                    'Account edited successfully!',
                                                    style: TextStyle(color: primaryTextColor)),
                                                backgroundColor: Colors.green,
                                              ),
                                            );
                                          }

                                        } catch (e) {
                                          if (context.mounted) Navigator.of(context, rootNavigator: true).pop(); // Dismiss loading dialog on error
                                          if (context.mounted) {
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(
                                                content: Text('Error editing profile: $e', style: const TextStyle(color: primaryTextColor)),
                                                backgroundColor: Colors.red,
                                              ),
                                            );
                                          }
                                        } finally {
                                          if (context.mounted) {
                                            setState(() {
                                              _isSaving = false; // End loading
                                            });
                                          }
                                        }
                                  }),
                              MyButton(
                                  buttonColor: importantButtonColor,
                                  textColor: primaryTextColor,
                                  buttonText: _isSaving ? 'Deleting...' : "Delete Account",
                                  onPressed: _isSaving ? null : () async {

                                    setState(() {
                                      _isSaving = true;
                                    });

                                    showDialog(
                                        context: context,
                                        barrierDismissible: false, // User cannot dismiss it
                                        builder: (BuildContext context) {
                                          return const Center(child: CircularProgressIndicator(
                                              color: utilityButtonColor));
                                        });

                                    try {
                                      await AuthService.deleteAccount(user);

                                      if (context.mounted) Navigator.of(context, rootNavigator: true).pop();
                                      if (context.mounted) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                                'Account deleted successfully!',
                                                style: TextStyle(color: primaryTextColor)),
                                            backgroundColor: Colors.green,
                                          ),
                                        );
                                      }

                                    } catch (e) {
                                      if (context.mounted) Navigator.of(context, rootNavigator: true).pop(); // Dismiss loading dialog on error
                                      if (context.mounted) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text('Error deleting account: $e', style: const TextStyle(color: primaryTextColor)),
                                            backgroundColor: Colors.red,
                                          ),
                                        );
                                      }
                                    } finally {
                                      if (context.mounted) {
                                        setState(() {
                                          _isSaving = false; // End loading
                                        });
                                      }
                                    }
                                  })
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
