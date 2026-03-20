import 'package:flutter/material.dart';
import 'package:place_see_app/features/user_location/screen/widgets/user_location_background.dart';
import 'package:place_see_app/features/user_location/screen/widgets/user_location_content.dart';

class UserLocationScreen extends StatelessWidget {
  const UserLocationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    print("Дошли до userLocation");
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        fit: StackFit.expand,
        children: [
          UserLocationBackground(),
          UserLocationContent(),
        ],
      ),
    );
  }
}
