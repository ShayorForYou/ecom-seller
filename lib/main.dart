import 'package:ecom_seller_app/helpers/addon_helper.dart';
import 'package:ecom_seller_app/helpers/business_setting_helper.dart';
import 'package:ecom_seller_app/helpers/shared_value_helper.dart';
import 'package:ecom_seller_app/lang_config.dart';
import 'package:ecom_seller_app/my_theme.dart';
import 'package:ecom_seller_app/providers/locale_provider.dart';
import 'package:ecom_seller_app/providers/product_provider.dart';
import 'package:ecom_seller_app/screens/splash.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:one_context/one_context.dart';
import 'package:provider/provider.dart';
import 'package:shared_value/shared_value.dart';

import 'app_config.dart';
import 'helpers/push_notification_service.dart';
import 'other_config.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Plugin must be initialized before using
  await FlutterDownloader.initialize(
      debug:
          true, // optional: set to false to disable printing logs to console (default: true)
      ignoreSsl:
          true // option: set to false to disable working with http links (default: false)
      );
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    systemNavigationBarDividerColor: Colors.transparent,
  ));
  runApp(
    SharedValue.wrapApp(
      MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  // This widget is the root of your application.

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  setShareValue() {
    //ResetHelper().clean();
    AddonsHelper().setAddonsData();
    BusinessSettingHelper().setBusinessSettingData();

    seller_id.load();
    access_token.load();
    is_logged_in.load();
  }

  @override
  void initState() {
    setShareValue();
    // await ResetHelper().clean();
    // AddonsHelper().setAddonsData();
    // BusinessSettingHelper().setBusinessSettingData();
    // access_token.load();

    Future.delayed(Duration.zero).then(
      (value) async {
        Firebase.initializeApp().then((value) {
          if (OtherConfig.USE_PUSH_NOTIFICATION) {
            Future.delayed(const Duration(milliseconds: 10), () async {
              PushNotificationService().initialise();
            });
          }
        });
      },
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => LocaleProvider()),
          ChangeNotifierProvider(create: (context) => ProductProvider()),

        ],
        child: Consumer<LocaleProvider>(builder: (context, provider, snapshot) {
          return MaterialApp(
            builder: OneContext().builder,
            navigatorKey: OneContext().navigator.key,
            title: AppConfig.app_name,
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              scaffoldBackgroundColor: MyTheme.white,
              primaryColor: MyTheme.white,
              visualDensity: VisualDensity.adaptivePlatformDensity,
              /*textTheme: TextTheme(
              bodyText1: TextStyle(),
              bodyText2: TextStyle(fontSize: 12.0),
            )*/
              //
              // the below code is getting fonts from http
              //textTheme: GoogleFonts.roboto(),
              // textTheme: GoogleFonts.sourceSansProTextTheme(textTheme).copyWith(
              //   bodyText1:
              //       GoogleFonts.sourceSansPro(textStyle: textTheme.bodyText1),
              //   bodyText2: GoogleFonts.sourceSansPro(
              //       textStyle: textTheme.bodyText2, fontSize: 12),
              // ),
            ),
            localizationsDelegates: [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
              AppLocalizations.delegate,
            ],
            locale: provider.locale,
            supportedLocales: LangConfig().supportedLocales(),
            home: Splash(),
            //home: Main(),
          );
        }));
  }
}
