import 'package:edirnebenim/utilities/hero_dialog_route.dart';
import 'package:flutter/material.dart';

class FabMenu extends StatefulWidget {
  /// Animated FAB menu button.
  const FabMenu({
    required this.children,
    super.key,
    this.fabIcon,
    this.fabBackgroundColor,
    this.fabAlignment,
    this.overlayColor,
    this.overlayOpacity,
    this.elevation,
    this.closeMenuButton,
  });

  /// Used to set the fab Icon.
  final Widget? fabIcon;

  /// Used to set the fab background color.
  final Color? fabBackgroundColor;

  /// Used to set the menu close Icon.
  final Widget? closeMenuButton;

  /// Used to set the fab alignment.
  final Alignment? fabAlignment;

  /// The color of the menu background overlay.
  final Color? overlayColor;

  /// The opacity of the menu background overlay.
  /// Default: 0.8
  final double? overlayOpacity;

  /// Used to set the elevation of the fab button.
  /// Default: 1.0
  final double? elevation;

  /// Children buttons of the menu, from the lowest to the highest.
  final List<Widget> children;

  @override
  _FabMenuState createState() => _FabMenuState();
}

class _FabMenuState extends State<FabMenu> {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: widget.fabAlignment ?? Alignment.bottomCenter,
      child: FloatingActionButton(
        heroTag: 'main-btn-taasdsag',
        backgroundColor: widget.fabBackgroundColor ?? Colors.black,
        elevation: widget.elevation ?? 1.0,
        onPressed: () {
          Navigator.of(context).push(
            HeroDialogRoute<Widget>(
              builder: (context) {
                return MainMenu(
                  closeMenuButton: widget.closeMenuButton ??
                      const Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                      ),
                  backgroundColor: widget.overlayColor ?? Colors.black,
                  overlayOpacity: widget.overlayOpacity ?? 0.8,
                  children: widget.children,
                );
              },
            ),
          );
        },
        child: widget.fabIcon ?? const Icon(Icons.more_horiz),
      ),
    );
  }
}

// Full screen main menu
class MainMenu extends StatefulWidget {
  const MainMenu({
    required this.backgroundColor,
    required this.overlayOpacity,
    required this.closeMenuButton,
    required this.children,
    super.key,
  });

  /// Used to set the menu close Icon.
  final Widget closeMenuButton;

  /// Used to get the background color of the menu list.
  final Color backgroundColor;

  /// Used to get the opacity of the background color of the menu list.
  final double overlayOpacity;

  /// Children buttons of the menu, from the lowest to the highest.
  final List<Widget> children;

  @override
  State<MainMenu> createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'main-btn-taasdasg',
      child: Material(
        color: widget.backgroundColor.withOpacity(widget.overlayOpacity),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                children: [
                  Expanded(
                    flex: 3,
                    child: ListView(
                      physics: const BouncingScrollPhysics(),
                      reverse: true,
                      children: List.from(widget.children),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        height: 50,
                        width: 100,
                        color: Colors.transparent,
                        child: widget.closeMenuButton,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
