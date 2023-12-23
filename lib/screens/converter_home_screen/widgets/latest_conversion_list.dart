import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../constants/size_constants.dart';
import '../../../controller/converter_home_controller.dart';

class LatestConversionList extends StatelessWidget {
  const LatestConversionList({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.lastConversions,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 18.0),
        ),
        verticalSpace12,
        Consumer<ConverterHomeController>(builder: (context, controller, _) {
          return Expanded(
            child: controller.latestConversions.isEmpty
                ? Text(
                    AppLocalizations.of(context)!.noConversion,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontWeight: FontWeight.w400, fontSize: 18),
                  )
                : RefreshIndicator.adaptive(
                    onRefresh: () async {
                      await controller
                          .getLatestConversionsFromHive()
                          .whenComplete(() => ScaffoldMessenger.of(context)
                              .showSnackBar(SnackBar(
                                  content: Text(AppLocalizations.of(context)!
                                      .flowRenewed))));
                    },
                    child: ListView.separated(
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          final conversion =
                              controller.latestConversions.elementAt(index);
                          debugPrint(conversion.toJson().toString());
                          return ListTile(
                            leading: Text(
                              conversion.rate?.currency ?? "",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green[800],
                                  fontSize: 18.0),
                            ),
                            title: Text(
                              "${conversion.amount ?? 0.0} ${conversion.base ?? ''} to ${conversion.rate?.currency ?? ''} = ${(conversion.rate?.result ?? 0.0).toStringAsFixed(3)}",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.green[800],
                                  fontSize: 16.0),
                            ),
                          );
                        },
                        separatorBuilder: (context, index) => const Divider(),
                        itemCount: controller.latestConversions.length),
                  ),
          );
        }),
      ],
    );
  }
}
