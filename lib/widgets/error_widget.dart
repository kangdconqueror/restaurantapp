import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class CustomErrorWidget extends StatelessWidget {
  final String message;

  CustomErrorWidget({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            'assets/no_connection.svg', // Pastikan file SVG ini ada di folder assets
            width: 150,
            height: 150,
          ),
          SizedBox(height: 20),
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
          SizedBox(height: 20),
          SpinKitWave(
            color: Colors.blue,
            size: 50.0,
          ),
        ],
      ),
    );
  }
}
