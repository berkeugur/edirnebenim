import 'package:edirnebenim/Authentication/auth_service.dart';
import 'package:edirnebenim/Message/channels_view.dart';
import 'package:edirnebenim/Notification/notification_view.dart';
import 'package:edirnebenim/Trade/view/categories.dart';
import 'package:edirnebenim/Trade/view/savedandmyTradesScaffold.dart';
import 'package:edirnebenim/Trade/view/trade_home.dart';
import 'package:edirnebenim/Values/my_user.dart';
import 'package:edirnebenim/config.dart';
import 'package:edirnebenim/locator.dart';
import 'package:edirnebenim/utilities/date_format.dart';
import 'package:edirnebenim/utilities/fab_menu.dart';
import 'package:edirnebenim/utilities/hero_dialog_route.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/date_symbol_data_local.dart' show initializeDateFormatting;
import 'package:intl/intl.dart' show DateFormat;

class TradeScaffold extends StatefulWidget {
  const TradeScaffold({super.key});

  @override
  State<TradeScaffold> createState() => _TradeScaffoldState();
}

class _TradeScaffoldState extends State<TradeScaffold>
    with WidgetsBindingObserver {
  AuthService authService = AuthService();

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      authService.setOnlineStatus(isOnline: true);
    } else if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached) {
      authService.setOnlineStatus(isOnline: false);
    }

    super.didChangeAppLifecycleState(state);
  }

  ValueNotifier<int> selectedIndex = ValueNotifier(0);
  late PageController pageController;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    pageController = PageController();

    initializeDateFormatting();
    AppDateFormat.dateFormat = DateFormat.yMMMMd('tr');
    AppDateFormat.timeFormat = DateFormat.Hms('tr');
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: locator<MyUser>(),
      builder: (context, _, __) {
        return Scaffold(
          bottomNavigationBar: ValueListenableBuilder(
            valueListenable: selectedIndex,
            builder: (context, index, i) {
              return Padding(
                padding: EdgeInsets.only(
                  left: 8,
                  bottom: MediaQuery.of(context).viewPadding.bottom,
                  right: 8,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    customBottomNavBarItem(0, Iconsax.home_1, pageController),
                    customBottomNavBarItem(
                      1,
                      Iconsax.notification,
                      pageController,
                    ),
                    Expanded(
                      child: SizedBox.square(
                        dimension: 70,
                        child: FloatingActionButton(
                          backgroundColor: AppConfig.tradePrimaryColor,
                          elevation: 2,
                          child: const Icon(
                            Iconsax.menu,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            Navigator.of(context).push(
                              HeroDialogRoute<Widget>(
                                builder: (context) {
                                  return MainMenu(
                                    closeMenuButton: const Icon(
                                      Icons.arrow_back,
                                      color: Colors.white,
                                    ),
                                    backgroundColor:
                                        AppConfig.tradePrimaryColor,
                                    overlayOpacity: 0.8,
                                    children: const [
                                      Text('deneme1'),
                                      Text('deneme 2'),
                                    ],
                                  );
                                },
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    customBottomNavBarItem(2, Iconsax.message, pageController),
                    customBottomNavBarItem(3, Iconsax.save_2, pageController),
                  ],
                ),
              );
            },
          ),
          floatingActionButton: FloatingActionButton.extended(
            heroTag: 'new',
            label: Text(
              'SAT',
              style: AppConfig.font.copyWith(fontWeight: FontWeight.bold),
            ),
            backgroundColor: AppConfig.tradePrimaryColor,
            icon: const Icon(
              Iconsax.camera,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute<Widget>(
                  builder: (context) => TradeCategoriesView(
                    isForAddNewTrade: true,
                  ),
                ),
              );
            },
          ),
          body: PageView(
            controller: pageController,
            onPageChanged: (value) {
              selectedIndex.value = value;
            },
            children: [
              const TradeHome(),
              const NotificationView(),
              const ChannelsView(),
              SavedTradesScaffold()
            ],
          ),
        );
      },
    );
  }

  Expanded customBottomNavBarItem(
    int index,
    IconData iconData,
    PageController pageController,
  ) {
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () {
          switch (index) {
            case 0:
              if (pageController.hasClients) {
                pageController.jumpToPage(index);
              }
              break;
            case 1:
              AuthService().authorizedControl(
                context,
                function: () {
                  if (pageController.hasClients) {
                    pageController.jumpToPage(index);
                  }
                },
              )?.call();
              break;
            case 2:
              AuthService().authorizedControl(
                context,
                function: () {
                  if (pageController.hasClients) {
                    pageController.jumpToPage(index);
                  }
                },
              )?.call();
              break;
            case 3:
              AuthService().authorizedControl(
                context,
                function: () {
                  if (pageController.hasClients) {
                    pageController.jumpToPage(index);
                  }
                },
              )?.call();
              break;
            default:
              if (pageController.hasClients) {
                pageController.jumpToPage(index);
              }
          }
        },
        child: AnimatedContainer(
          duration: const Duration(seconds: 1),
          padding: const EdgeInsets.only(
            bottom: 18,
            left: 10,
            right: 10,
            top: 18,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                iconData,
                color: index == selectedIndex.value
                    ? AppConfig.tradePrimaryColor
                    : Colors.grey[500],
              ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: index == selectedIndex.value ? 7 : 0,
                height: index == selectedIndex.value ? 3 : 0,
                margin: const EdgeInsets.only(top: 3),
                decoration: BoxDecoration(
                  color: AppConfig.tradePrimaryColor,
                  borderRadius: BorderRadius.circular(10),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
