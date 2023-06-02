import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fullfit_app/presentation/widgets/widgets.dart';

class HeightCard extends StatelessWidget {
  final int height;
  final ValueChanged<int> onChanged;
  final GlobalKey pickerKey = GlobalKey();

  HeightCard({
    Key? key,
    this.height = 170,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints:
          BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.5),
      child: Card(
        margin: EdgeInsets.only(
          right: 24.0.w,
          left: 24.0.w,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const CardTitle(title: "Altura", subtitle: "(cm)"),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(bottom: 8.0.h),
                child: LayoutBuilder(builder: (context, constraints) {
                  return HeightPicker(
                    // key: pickerKey,
                    widgetHeight: constraints.maxHeight,
                    height: height,
                    onChange: (val) => onChanged(val),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
