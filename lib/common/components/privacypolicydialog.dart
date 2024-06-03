import 'package:flutter/material.dart';
import 'package:flutter_debouncer/flutter_debouncer.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:kromenote_flutter/common/components/styleddialog.dart';
import 'package:kromenote_flutter/database/models/models.dart';
import 'package:realm/realm.dart';

class PrivacyPolicyDialog extends StatefulWidget {
  const PrivacyPolicyDialog({super.key});

  @override
  State<PrivacyPolicyDialog> createState() => _PrivacyPolicyDialogState();
}

class _PrivacyPolicyDialogState extends State<PrivacyPolicyDialog> {
  late Realm realm;
  final _debouncer = Debouncer();
  TextEditingController categoryController = TextEditingController();

  _PrivacyPolicyDialogState() {
    final config =
        Configuration.local([Note.schema, Category.schema], schemaVersion: 1);
    realm = Realm(config);
  }

  RealmResults<Category>? categories;

  void handleDeleteCategory(Category currentCategory) {
    realm.write(() {
      realm.delete<Category>(currentCategory);
      const duration = Duration(milliseconds: 250);
      _debouncer.debounce(
        duration: duration,
        onDebounce: () {
          setState(() {});
          Navigator.of(context).pop();
        },
      );
    });
  }

  void getCategories() async {
    setState(() {
      categories = realm.all<Category>();
    });
  }

  @override
  void initState() {
    getCategories();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Privacy Policy"),
      backgroundColor: Colors.white,
      shape: const Border(
        top: BorderSide(width: 2.0, color: Colors.black),
        left: BorderSide(width: 2.0, color: Colors.black),
        right: BorderSide(width: 2.0, color: Colors.black),
        bottom: BorderSide(width: 4.0, color: Colors.black),
      ),
      actions: [
        TextButton(
            onPressed: () {
              setState(() {});
              Navigator.of(context).pop();
            },
            child: const Text("Close"))
      ],
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 2,
            child: const SingleChildScrollView(
              child: Text(
                  "This privacy policy applies to the KromeNote app (hereby referred to as \"Application\") for mobile devices that was created by SKY Studios (hereby referred to as \"Service Provider\") as an Ad Supported service. This service is intended for use \"AS IS\".\n\n\nInformation Collection and Use\n\nThe Application collects information when you download and use it. This information may include information such as\n\nYour device's Internet Protocol address (e.g. IP address)\nThe pages of the Application that you visit, the time and date of your visit, the time spent on those pages\nThe time spent on the Application\nThe operating system you use on your mobile device\n\n\n\n\n \n\nThe Application does not gather precise information about the location of your mobile device.\n\nThe Application collects your device's location, which helps the Service Provider determine your approximate geographical location and make use of in below ways:\n\nGeolocation Services: The Service Provider utilizes location data to provide features such as personalized content, relevant recommendations, and location-based services.\nAnalytics and Improvements: Aggregated and anonymized location data helps the Service Provider to analyze user behavior, identify trends, and improve the overall performance and functionality of the Application.\nThird-Party Services: Periodically, the Service Provider may transmit anonymized location data to external services. These services assist them in enhancing the Application and optimizing their offerings.\n\n\n \n\nThe Service Provider may use the information you provided to contact you from time to time to provide you with important information, required notices and marketing promotions.\n\n\n \n\nFor a better experience, while using the Application, the Service Provider may require you to provide us with certain personally identifiable information. The information that the Service Provider request will be retained by them and used as described in this privacy policy.\n\n\nThird Party Access\n\nOnly aggregated, anonymized data is periodically transmitted to external services to aid the Service Provider in improving the Application and their service. The Service Provider may share your information with third parties in the ways that are described in this privacy statement.\n\n\n \n\nPlease note that the Application utilizes third-party services that have their own Privacy Policy about handling data. Below are the links to the Privacy Policy of the third-party service providers used by the Application:\n\nGoogle Play Services\nAdMob\n\n\n \n\nThe Service Provider may disclose User Provided and Automatically Collected Information:\n\nas required by law, such as to comply with a subpoena, or similar legal process;\nwhen they believe in good faith that disclosure is necessary to protect their rights, protect your safety or the safety of others, investigate fraud, or respond to a government request;\nwith their trusted services providers who work on their behalf, do not have an independent use of the information we disclose to them, and have agreed to adhere to the rules set forth in this privacy statement.\n\n\n\n\nOpt-Out Rights\n\nYou can stop all collection of information by the Application easily by uninstalling it. You may use the standard uninstall processes as may be available as part of your mobile device or via the mobile application marketplace or network.\n\n\nData Retention Policy\n\nThe Service Provider will retain User Provided data for as long as you use the Application and for a reasonable time thereafter. If you'd like them to delete User Provided Data that you have provided via the Application, please contact them at kromenote@gmail.com and they will respond in a reasonable time.\n\n\nChildren\n\nThe Service Provider does not use the Application to knowingly solicit data from or market to children under the age of 13.\n\n\n \n\nThe Application does not address anyone under the age of 13. The Service Provider does not knowingly collect personally identifiable information from children under 13 years of age. In the case the Service Provider discover that a child under 13 has provided personal information, the Service Provider will immediately delete this from their servers. If you are a parent or guardian and you are aware that your child has provided us with personal information, please contact the Service Provider (kromenote@gmail.com) so that they will be able to take the necessary actions.\n\n\nSecurity\n\nThe Service Provider is concerned about safeguarding the confidentiality of your information. The Service Provider provides physical, electronic, and procedural safeguards to protect information the Service Provider processes and maintains.\n\n\nChanges\n\nThis Privacy Policy may be updated from time to time for any reason. The Service Provider will notify you of any changes to the Privacy Policy by updating this page with the new Privacy Policy. You are advised to consult this Privacy Policy regularly for any changes, as continued use is deemed approval of all changes.\n\n\n \n\nThis privacy policy is effective as of 2024-06-03\n\n\nYour Consent\n\nBy using the Application, you are consenting to the processing of your information as set forth in this Privacy Policy now and as amended by us.\n\n\nContact Us\n\nIf you have any questions regarding privacy while using the Application, or have questions about the practices, please contact the Service Provider via email at kromenote@flycricket.support.\n\nThis privacy policy page was generated by App Privacy Policy Generator"),
            ),
          )
        ],
      ),
    );
  }
}
