import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zeusfile/constants.dart';

class PrivacyInfo extends StatelessWidget {
  final TextAlign textAlign;

  const PrivacyInfo({Key? key, this.textAlign = TextAlign.center})
      : super(key: key);

  static const privacyUrl = 'https://premiumkey.digital/privacy.html';
  static const licenseUrl =
      'https://www.apple.com/legal/internet-services/itunes/dev/stdeula/';

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          InkWell(
            onTap: () => launchUrl(Uri.parse(privacyUrl),
                mode: LaunchMode.platformDefault),
            child:
                Text(style: h3SbStyle, textAlign: textAlign, 'Privacy Policy'),
          ),
          const SizedBox(
            height: 5,
          ),
          InkWell(
            onTap: () => launchUrl(Uri.parse(licenseUrl),
                mode: LaunchMode.platformDefault),
            child: Text(
                style: h3SbStyle, textAlign: textAlign, 'License agreeement'),
          )
        ],
      ),
    );
  }
}
