import 'package:ecom_seller_app/custom/buttons.dart';
import 'package:ecom_seller_app/custom/device_info.dart';
import 'package:ecom_seller_app/custom/localization.dart';
import 'package:ecom_seller_app/custom/my_app_bar.dart';
import 'package:ecom_seller_app/custom/route_transaction.dart';
import 'package:ecom_seller_app/helpers/shared_value_helper.dart';
import 'package:ecom_seller_app/my_theme.dart';
import 'package:ecom_seller_app/screens/shop_settings/shop_banner_settings.dart';
import 'package:ecom_seller_app/screens/shop_settings/shop_delivery_boy_pickup_point_setting.dart';
import 'package:ecom_seller_app/screens/shop_settings/shop_general_setting.dart';
import 'package:ecom_seller_app/screens/shop_settings/shop_social_media_setting.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ShopSettings extends StatefulWidget {
  const ShopSettings({super.key});

  @override
  ShopSettingsState createState() => ShopSettingsState();
}

class ShopSettingsState extends State<ShopSettings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
              title: AppLocalizations.of(context)!.shop_settings_ucf,
              context: context)
          .show(),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              Buttons(
                color: MyTheme.app_accent_color,
                width: DeviceInfo(context).getWidth(),
                height: 75,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                onPressed: () {
                  MyTransaction(context: context)
                      .push(const ShopGeneralSetting());
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0, left: 4),
                        child: Image.asset(
                          "assets/icon/general_setting.png",
                          height: 17,
                          width: 17,
                        ),
                      ),
                      Text(
                        LangText(context: context)
                            .getLocal()
                            .general_setting_ucf,
                        style: TextStyle(
                            fontSize: 14,
                            color: MyTheme.white,
                            fontWeight: FontWeight.bold),
                      ),
                      const Spacer(),
                      Icon(
                        Icons.navigate_next_rounded,
                        size: 20,
                        color: MyTheme.white,
                      )
                    ],
                  ),
                ),
              ),
              Visibility(
                visible: delivery_boy_addon.$,
                child: Column(
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    Buttons(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      color: MyTheme.app_accent_color,
                      width: DeviceInfo(context).getWidth(),
                      height: 75,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      onPressed: () {
                        MyTransaction(context: context)
                            .push(const ShopDeliveryBoyPickupPoint());
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 8.0, left: 4),
                            child: Image.asset(
                              "assets/icon/delivery_boy_setting.png",
                              height: 17,
                              width: 17,
                            ),
                          ),
                          Text(
                            LangText(context: context)
                                .getLocal()
                                .delivery_boy_pickup_point,
                            style: TextStyle(
                                fontSize: 14,
                                color: MyTheme.white,
                                fontWeight: FontWeight.bold),
                          ),
                          const Spacer(),
                          Icon(
                            Icons.navigate_next_rounded,
                            size: 20,
                            color: MyTheme.white,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Buttons(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  color: MyTheme.app_accent_color,
                  width: DeviceInfo(context).getWidth(),
                  height: 75,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  onPressed: () {
                    MyTransaction(context: context)
                        .push(const ShopBannerSettings());
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0, left: 4),
                        child: Image.asset(
                          "assets/icon/banner_setting.png",
                          height: 17,
                          width: 17,
                        ),
                      ),
                      Text(
                        LangText(context: context).getLocal().banner_settings,
                        style: TextStyle(
                            fontSize: 14,
                            color: MyTheme.white,
                            fontWeight: FontWeight.bold),
                      ),
                      const Spacer(),
                      Icon(
                        Icons.navigate_next_rounded,
                        size: 20,
                        color: MyTheme.white,
                      )
                    ],
                  )),
              const SizedBox(
                height: 20,
              ),
              Buttons(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  color: MyTheme.app_accent_color,
                  width: DeviceInfo(context).getWidth(),
                  height: 75,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  onPressed: () {
                    MyTransaction(context: context)
                        .push(const ShopSocialMedialSetting());
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0, left: 4),
                        child: Image.asset(
                          "assets/icon/social_setting.png",
                          height: 17,
                          width: 17,
                        ),
                      ),
                      Text(
                        LangText(context: context).getLocal().social_media_link,
                        style: TextStyle(
                            fontSize: 14,
                            color: MyTheme.white,
                            fontWeight: FontWeight.bold),
                      ),
                      const Spacer(),
                      Icon(
                        Icons.navigate_next_rounded,
                        size: 20,
                        color: MyTheme.white,
                      )
                    ],
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
