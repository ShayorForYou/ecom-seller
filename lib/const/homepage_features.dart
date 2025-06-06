import 'package:ecom_seller_app/custom/localization.dart';
import 'package:ecom_seller_app/custom/route_transaction.dart';
import 'package:ecom_seller_app/helpers/shared_value_helper.dart';
import 'package:ecom_seller_app/my_theme.dart';
import 'package:ecom_seller_app/screens/chat_list.dart';
import 'package:ecom_seller_app/screens/coupon/coupons.dart';
import 'package:ecom_seller_app/screens/money_withdraw.dart';
import 'package:ecom_seller_app/screens/payment_history.dart';
import 'package:ecom_seller_app/screens/pos/pos_manager.dart';
import 'package:ecom_seller_app/screens/refund_request.dart';
import 'package:flutter/material.dart';

class FeaturesList {
  BuildContext context;

  FeaturesList(this.context);

  List<Widget> getFeatureList() {
    List<Widget> featureList = [];
    featureList.add(Visibility(
      visible: pos_manager_activation.$,
      child: InkWell(
          onTap: () {
            MyTransaction(context: context).push(const PosManager());
          },
          child: SizedBox(
            height: 40,
            child: Column(
              children: [
                Image.asset(
                  'assets/icon/pos_system.png',
                  width: 16,
                  height: 16,
                  color: MyTheme.white,
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  "Pos Manager",
                  style: TextStyle(
                    fontSize: 12,
                    color: MyTheme.white,
                  ),
                ),
              ],
            ),
          )),
    ));
    featureList.add(Visibility(
      visible: conversation_activation.$,
      child: InkWell(
          onTap: () {
            MyTransaction(context: context).push(ChatList());
          },
          child: SizedBox(
            height: 40,
            child: Column(
              children: [
                Image.asset(
                  'assets/icon/chat.png',
                  width: 16,
                  height: 16,
                  color: MyTheme.white,
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  LangText(context: context).getLocal().messages_ucf,
                  style: TextStyle(
                    fontSize: 12,
                    color: MyTheme.white,
                  ),
                ),
              ],
            ),
          )),
    ));
    featureList.add(
      Visibility(
        visible: refund_addon.$,
        child: InkWell(
            onTap: () {
              //MyTransaction(context: context).push(RefundRequest());
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => RefundRequest()));
            },
            child: SizedBox(
              height: 40,
              child: Column(
                children: [
                  Image.asset(
                    'assets/icon/refund.png',
                    width: 16,
                    height: 16,
                    color: MyTheme.white,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    LangText(context: context).getLocal().refund_requests_ucf,
                    style: TextStyle(
                      fontSize: 12,
                      color: MyTheme.white,
                    ),
                  ),
                ],
              ),
            )),
      ),
    );
    /*featureList.add(InkWell(
          onTap: () {
            MyTransaction(context: context).push(SupportTicket());
          },
          child: Container(
            width: DeviceInfo(context).getWidth() / 3.5,
            height:40,
            child: Column(
              children: [
                Image.asset(
                  'assets/icon/support_ticket.png',
                  width: 16,
                  height: 16,
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  LangText(context: context)
                      .getLocal()
                      .dashboard_support_tickets,
                  style:
                  TextStyle(fontSize: 12, color: Colors.white),
                ),
              ],
            ),
          )),);*/
    featureList.add(
      Visibility(
        visible: coupon_activation.$,
        child: InkWell(
            onTap: () {
              MyTransaction(context: context).push(Coupons());
            },
            child: SizedBox(
              height: 40,
              child: Column(
                children: [
                  Image.asset(
                    'assets/icon/coupon.png',
                    width: 16,
                    height: 16,
                    color: MyTheme.white,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    LangText(context: context).getLocal().coupons_ucf,
                    style: TextStyle(
                      fontSize: 12,
                      color: MyTheme.white,
                    ),
                  ),
                ],
              ),
            )),
      ),
    );
    featureList.add(
      InkWell(
          onTap: () {
            MyTransaction(context: context).push(MoneyWithdraw());
          },
          child: SizedBox(
            height: 40,
            child: Column(
              children: [
                Image.asset(
                  'assets/icon/withdraw.png',
                  width: 16,
                  height: 16,
                  color: MyTheme.white,
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  LangText(context: context).getLocal().money_withdraw_ucf,
                  style: TextStyle(
                    fontSize: 12,
                    color: MyTheme.white,
                  ),
                ),
              ],
            ),
          )),
    );
    featureList.add(
      InkWell(
          onTap: () {
            MyTransaction(context: context).push(PaymentHistory());
          },
          child: SizedBox(
            height: 40,
            child: Column(
              children: [
                Image.asset(
                  'assets/icon/payment_history.png',
                  width: 16,
                  height: 16,
                  color: MyTheme.white,
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  LangText(context: context).getLocal().payment_history_ucf,
                  style: TextStyle(
                    fontSize: 12,
                    color: MyTheme.white,
                  ),
                ),
              ],
            ),
          )),
    );
    return featureList;
  }
}
