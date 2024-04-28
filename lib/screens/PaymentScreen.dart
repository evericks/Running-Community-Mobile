import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:running_community_mobile/screens/TournamentDetailScreen.dart';
import 'package:running_community_mobile/utils/app_assets.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key, required this.paymentUrl, required this.tournamentId});
  static const String routeName = '/payment';
  final String paymentUrl;
  final String tournamentId;

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {

  @override
  void initState() {
    // _webViewController = WebViewController()..setJavaScriptMode(JavaScriptMode.unrestricted)..setBackgroundColor(black)..loadRequest(Uri.parse(widget.paymentUrl));
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context);
        Navigator.pushReplacementNamed(context, TournamentDetailScreen.routeName, arguments: widget.tournamentId);
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Payment'),
          leading: SvgPicture.asset(AppAssets.arrow_left, color: textPrimaryColor).onTap(() {
            Navigator.pop(context);
            Navigator.pushReplacementNamed(context, TournamentDetailScreen.routeName, arguments: widget.tournamentId);
          },).paddingSymmetric(vertical: 18).paddingLeft(16),
        ),
        body: WebView(
          initialUrl: widget.paymentUrl,
          javascriptMode: JavascriptMode.unrestricted,
          // onWebViewCreated: (WebViewController webViewController) {
          //   _webViewController = webViewController;
          // },
        )
      ),
    );
  }
}