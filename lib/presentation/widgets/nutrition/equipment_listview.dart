import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fullfit_app/domain/entities/entities.dart';

class EquipmentsListView extends StatelessWidget {
  final List<Equipment> equipments;

  const EquipmentsListView({Key? key, required this.equipments})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textStyles = Theme.of(context).textTheme;
    return SizedBox(
      height: 150.h,
      child: ListView(
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        children: [
          ...equipments.map((equipment) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(100)),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: Image.network(equipment.image,
                          height: 100.h,
                          width: 100.w,
                          fit: BoxFit.contain,
                          loadingBuilder: (context, child, loadingProgress) =>
                              loadingProgress == null
                                  ? FadeIn(child: child)
                                  : const Center(
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2.0,
                                      ),
                                    )),
                    ),
                  ),
                  Container(
                    width: 100.w,
                    padding: const EdgeInsets.all(8),
                    child: Text(
                      equipment.name,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      style: textStyles.bodyMedium?.copyWith(
                        color: colors.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}
