import 'package:flutter/material.dart';
import 'package:running_community_mobile/utils/gap.dart';

import '../utils/colors.dart';

Widget buildTimeCard({required String time, required String header}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Text(
            time,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 50,
              color: primaryColor,
            ),
          ),
        ),
        Gap.k8.height,
        Text(header),
      ],
    );
  }
