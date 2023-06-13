import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fullfit_app/domain/entities/entities.dart';
import 'package:fullfit_app/presentation/widgets/widgets.dart';

class NutrientsInfo extends StatelessWidget {
  final List<Nutrient> nutrients;

  const NutrientsInfo({Key? key, required this.nutrients}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textStyles = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: Container(
        decoration: BoxDecoration(
          color: colors.surface,
        ),
        child: ExpandableGroup(
          isExpanded: false,
          collapsedIcon: const Icon(Icons.arrow_drop_down),
          header: Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: Text(
              "Nutrients Information.",
              style: textStyles.titleMedium?.copyWith(
                color: colors.primary,
                fontSize: 20.sp,
              ),
            ),
          ),
          items: [
            ...nutrients.map((nutrient) {
              return ListTile(
                contentPadding: const EdgeInsets.all(10),
                subtitle:
                    Text("${nutrient.percentOfDailyNeeds}% of Daily needs."),
                title: Text(nutrient.name.toString(),
                    style: textStyles.titleMedium?.copyWith(
                      fontSize: 15.sp,
                    )),
                trailing: Text(
                  '${nutrient.amount} ${nutrient.unit}',
                  style: textStyles.titleMedium?.copyWith(
                    color: colors.primary,
                    fontSize: 15.sp,
                  ),
                ),
              );
            }).toList()
          ],
        ),
      ),
    );
  }
}
