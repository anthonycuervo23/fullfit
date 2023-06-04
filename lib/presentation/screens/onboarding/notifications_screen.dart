import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

//TODO: solicitar los permisos de notificaciones push
class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  NotificationsScreenState createState() => NotificationsScreenState();
}

class NotificationsScreenState extends State<NotificationsScreen> {
  List<String> notificationTips = [
    'Nuevo recordatorio saludable semanal',
    'Recordatorio motivacional',
    'Programa personalizado'
  ];

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textStyles = Theme.of(context).textTheme;

    return SingleChildScrollView(
      padding: EdgeInsets.only(top: 32.h, right: 28.w, left: 28.w),
      child: Column(
        children: [
          Text(
            '¿Quieres activar las notificaciones?',
            textAlign: TextAlign.center,
            style: textStyles.titleMedium,
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 34.0.h),
            child: Image.asset('assets/images/notification_image.png'),
          ),
          ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      children: [
                        Icon(
                          Icons.check,
                          color: colors.primary.withOpacity(0.5),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 11),
                          child: Text(
                            notificationTips[index],
                            style: textStyles.bodyMedium,
                          ),
                        ),
                      ],
                    ),
                  ),
              separatorBuilder: (context, index) => const Divider(),
              itemCount: notificationTips.length)
        ],
      ),
    );
  }
}
