import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';

import '../domain/models/tournaments.dart';
import '../utils/app_assets.dart';
import '../utils/colors.dart';
import '../utils/constants.dart';
import '../utils/gap.dart';

class TournamentComponent extends StatelessWidget {
  const TournamentComponent({
    super.key,
    required this.tournaments,
  });

  final Tournament tournaments;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: context.width() * 0.8,
          padding: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: white,
            boxShadow: defaultBoxShadow(),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                  child: FadeInImage.assetNetwork(
                    placeholder: AppAssets.placeholder,
                    image: tournaments.thumbnailUrl!,
                    height: context.width() * 0.4,
                    width: context.width(),
                    fit: BoxFit.cover,
                  )),
              Gap.k8.height,
              SizedBox(
                  width: context.width() * 0.8,
                  child: Text(
                    tournaments.title!,
                    style: boldTextStyle(size: 20),
                    overflow: TextOverflow.ellipsis,
                  ).paddingLeft(16)),
              const Spacer(),
              Row(
                children: [
                  SvgPicture.asset(AppAssets.calendar, height: 16, width: 16, color: gray),
                  Gap.k4.width,
                  Text(
                    '${DateFormat('dd/MM/yyyy').format(DateTime.parse(tournaments.startTime!))} to ${DateFormat('dd/MM/yyyy').format(DateTime.parse(tournaments.endTime!))}',
                    style: primaryTextStyle(),
                  )
                ],
              ).paddingLeft(16),
              if (DateTime.now().isBefore(DateTime.parse(tournaments.registerDuration!))) ...[
                const Spacer(),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: primaryColor,
                  ),
                  child: Text(
                    'Register',
                    style: boldTextStyle(color: white, size: 14),
                  ).paddingSymmetric(horizontal: 32, vertical: 4),
                ).paddingSymmetric(horizontal: 16).onTap(() {
                  if (getStringAsync(AppConstant.TOKEN_KEY) == '') {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('Please login to register'),
                      backgroundColor: tomato,
                    ));
                  } else {
                    // Navigator.pushNamed(context, RegisterTournamentScreen.routeName, arguments: tournaments);
                  }
                })
              ],
              if (!DateTime.now().isBefore(DateTime.parse(tournaments.registerDuration!))) ...[
                const Spacer(),
                Row(
                  children: [
                    SvgPicture.asset(AppAssets.calendar_xmark, height: 16, width: 16, color: gray),
                    Gap.k8.width,
                    Text(
                      'Expired registration',
                      style: boldTextStyle(color: gray, size: 14),
                    ),
                  ],
                ).paddingSymmetric(horizontal: 16)
              ]
            ],
          ),
        );
  }
}
