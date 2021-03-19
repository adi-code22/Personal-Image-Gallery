import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter/material.dart';

import 'package:image/image.dart';

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SpinKitFadingCircle(
            color:
                brightness == Brightness.dark ? Colors.teal[700] : Colors.white,
            size: 80.0,
          ),
          SizedBox(
            height: 10,
          ),
          Text("Logging In",
              style: TextStyle(
                  fontSize: 15,
                  color: Colors.white,
                  fontWeight: FontWeight.bold))
        ],
      ),
    ));
  }
}
