import 'package:edirnebenim/config.dart';
import 'package:edirnebenim/utilities/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeItem extends StatelessWidget {
  const HomeItem({
    required this.context,
    required this.title,
    required this.subtitle,
    required this.emptyText,
    this.targetPage,
    super.key,
  });

  final BuildContext context;
  final String? title;
  final String subtitle;
  final String emptyText;
  final Widget? targetPage;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          side: BorderSide(
            color: AppConfig.tradeTextColor,
          ),
        ),
        onPressed: () {
          if (targetPage != null) {
            Navigator.of(context).push(
              MaterialPageRoute<Widget>(
                builder: (context) {
                  return targetPage!;
                },
              ),
            );
          } else {
            context.snackbar('çok yakında...');
          }
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width - 100,
                    child: Text(
                      title == '' || title == null ? emptyText : title!,
                      textScaleFactor: 1,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      softWrap: false,
                      style: AppConfig.font.copyWith(
                        fontSize: 15,
                        color: AppConfig.tradeTextColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width - 100,
                    child: Text(
                      subtitle,
                      textScaleFactor: 1,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      softWrap: false,
                      style: AppConfig.font.copyWith(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox.square(
                dimension: 20,
                child: Icon(
                  Icons.arrow_forward_ios,
                  size: 20,
                  color: Colors.grey[850],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
