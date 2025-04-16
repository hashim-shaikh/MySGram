import 'package:foap/helper/imports/common_import.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter/material.dart';

Widget noUserFound(BuildContext context) {
  return Expanded(
    child: SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Lottie.asset(
            'assets/lottie/no_record.json',
            height: 200,
          ),
          const SizedBox(height: 20),
          Heading5Text(
            noUserFoundString.tr,
            weight: TextWeight.medium,
          ),
        ],
      ),
    ),
  );
}

Widget emptyPost({
  required String title,
  required String subTitle,
}) {
  return Expanded(
    child: SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset(
            'assets/lottie/no_record.json',
            height: 200,
          ),
          const SizedBox(height: 20),
          Heading6Text(title, weight: TextWeight.medium),
          const SizedBox(height: 10),
          BodyLargeText(subTitle),
        ],
      ),
    ),
  );
}

Widget emptyUser({
  required String title,
  required String subTitle,
}) {
  return Expanded(
    child: SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset(
            'assets/lottie/no_record.json',
            height: 200,
          ),
          const SizedBox(height: 20),
          Heading6Text(title, weight: TextWeight.medium),
          const SizedBox(height: 10),
          BodyLargeText(subTitle),
        ],
      ),
    ),
  );
}

Widget emptyData({required String title, required String subTitle}) {
  return Expanded(
    child: SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset(
            'assets/lottie/no_record.json',
            height: 200,
          ),
          const SizedBox(height: 20),
          Heading6Text(title, weight: TextWeight.medium),
          const SizedBox(height: 10),
          BodyLargeText(subTitle),
        ],
      ),
    ),
  );
}
