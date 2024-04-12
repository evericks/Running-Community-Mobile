import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '../domain/models/tournaments.dart';
import '../screens/TournamentDetailScreen.dart';
import '../utils/gap.dart';
import 'TournamentComponent.dart';

class TournamentsList extends StatelessWidget {
  const TournamentsList({
    super.key,
    required this.tournaments,
  });

  final List<Tournament> tournaments;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
          height: context.width() * 0.8,
          width: context.width(),
          child: ListView.separated(
              padding: const EdgeInsets.only(bottom: 16, left: 16, right: 16),
              shrinkWrap: true,
              physics: const AlwaysScrollableScrollPhysics(),
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) => TournamentComponent(tournaments: tournaments[index]).onTap(() {
                    Navigator.pushNamed(context, TournamentDetailScreen.routeName, arguments: tournaments[index].id);
                  }),
              separatorBuilder: (context, index) => Gap.k16.width,
              itemCount: tournaments.length),
        ),
      ],
    );
  }
}

