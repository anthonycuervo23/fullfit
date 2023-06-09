import 'package:fullfit_app/domain/entities/entities.dart';

// {
//     "equipment": [
//         {
//             "image": "pie-pan.png",
//             "name": "pie form"
//         },
//         {
//             "image": "bowl.jpg",
//             "name": "bowl"
//         },
//         {
//             "image": "oven.jpg",
//             "name": "oven"
//         },
//         {
//             "image": "pan.png",
//             "name": "frying pan"
//         }
//     ]
// }

class EquipmentMapper {
  static equipmentJsonToEntityList(Map<String, dynamic> json) {
    final List<Equipment> equipments = [];
    for (final item in json['equipment']) {
      equipments.add(Equipment(
        image: item['image'] != null
            ? 'https://spoonacular.com/cdn/equipment_100x100/${item['image']}'
            : 'https://st4.depositphotos.com/14953852/22772/v/600/depositphotos_227725020-stock-illustration-image-available-icon-flat-vector.jpg',
        name: item['name'],
      ));
    }
    return equipments;
  }
}
