import 'package:edirnebenim/Authentication/auth_service.dart';
import 'package:edirnebenim/Notification/notification_model.dart';
import 'package:edirnebenim/Notification/notification_pagination.dart';
import 'package:edirnebenim/Notification/notification_value.dart';
import 'package:edirnebenim/Trade/view/widgets/last_seen_text.dart';
import 'package:edirnebenim/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';

class NotificationView extends StatefulWidget {
  const NotificationView({super.key});

  @override
  State<NotificationView> createState() => _NotificationViewState();
}

class _NotificationViewState extends State<NotificationView> {
  late ScrollController _scrollController;
  @override
  void initState() {
    _scrollController = ScrollController();
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Notifications notifications = Notifications();
  @override
  Widget build(BuildContext context) {
    var loading = false;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      decoration: BoxDecoration(
        color: Colors.grey[100],
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).viewPadding.top,
            ),
            child: Column(
              children: [
                Text(
                  'Bildirimler',
                  style: GoogleFonts.rubik(
                    color: AppConfig.tradeTextColor,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 18),
                ValueListenableBuilder(
                  valueListenable: notifications,
                  builder: (context, value, child) => NotificationListener(
                    onNotification: (t) {
                      final nextPageTrigger = 0.8 *
                          _scrollController.positions.last.maxScrollExtent;

                      if (_scrollController.positions.last.axisDirection ==
                              AxisDirection.down &&
                          _scrollController.positions.last.pixels >=
                              nextPageTrigger) {
                        if (loading == false) {
                          loading = true;
                          NotificationPaginationService().addMoreTradeData();
                          loading = false;
                        }
                      }
                      return true;
                    },
                    child: MasonryGridView.count(
                      controller: _scrollController,
                      padding: const EdgeInsets.only(bottom: 70),
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: notifications.length,
                      crossAxisCount: 1,
                      mainAxisSpacing: 2,
                      crossAxisSpacing: 2,
                      itemBuilder: (context, index) => _notificationWidget(
                        notifications.getIndex(atIndex: index)!,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _notificationWidget(NotificationModel notification) {
    final br = BorderRadius.circular(20);
    return Container(
      margin: EdgeInsets.only(bottom: 18),
      child: InkWell(
        onTap: () {},
        borderRadius: br,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 9,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: br,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(.03),
                offset: const Offset(0, 1),
                blurRadius: 3,
                spreadRadius: 1,
              )
            ],
          ),
          child: ListTile(
            title: Text(notification.title),
            subtitle: notification.subtitle == null
                ? null
                : Text(notification.subtitle!),
            trailing: notification.createdAt == null
                ? null
                : Text(notificationDateTime(date: notification.createdAt!)),
          ),
        ),
      ),
    );
  }
}
