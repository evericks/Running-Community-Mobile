import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nb_utils/nb_utils.dart';

import '../interfaces/react_action_interface.dart';
import '../utils/app_assets.dart';
import '../utils/colors.dart';
import '../utils/gap.dart';

// ignore: must_be_immutable
class ReactWidget extends StatefulWidget {
  ReactWidget({
    super.key,
    required this.delegate,
    required this.isReacted,
    required this.ctt,
  });
  final ReactActionInterface delegate;
  bool isReacted;
  final BuildContext ctt;

  @override
  State<ReactWidget> createState() => _ReactWidgetState();
}

class _ReactWidgetState extends State<ReactWidget> {
  // late final StreamController<int> _reactsCountController;
  bool isReacted = false;

  @override
  void initState() {
    super.initState();
    isReacted = widget.isReacted;
  }

  @override
  Widget build(BuildContext ctt) {
    return FutureBuilder<int?>(
        future: widget.delegate.getReactsCount(),
        builder: (ctt, snapshot) {
          // var reacts = state.reacts.reacts;
          var likeCount = snapshot.data ?? 0;
          return Wrap(
            children: [
              SvgPicture.asset(
                AppAssets.thumbs_up,
                width: 20,
                height: 20,
                color: isReacted ? primaryColor : textPrimaryColor,
              ).onTap(() async {
                if (isReacted) {
                  widget.delegate.onUnReact();
                } else {
                  widget.delegate.onReact();
                }
                setState(() {
                  isReacted = !isReacted;
                });
              }),
              Gap.k8.width,
              Text(likeCount.toString(), style: secondaryTextStyle(size: 16))
            ],
          );
        });
  }
}
