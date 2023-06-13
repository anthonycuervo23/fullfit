// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meal_planner.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetMealPlannerCollection on Isar {
  IsarCollection<MealPlanner> get mealPlanners => this.collection();
}

const MealPlannerSchema = CollectionSchema(
  name: r'MealPlanner',
  id: 5787876578847387228,
  properties: {
    r'friday': PropertySchema(
      id: 0,
      name: r'friday',
      type: IsarType.object,
      target: r'DailyMeal',
    ),
    r'monday': PropertySchema(
      id: 1,
      name: r'monday',
      type: IsarType.object,
      target: r'DailyMeal',
    ),
    r'saturday': PropertySchema(
      id: 2,
      name: r'saturday',
      type: IsarType.object,
      target: r'DailyMeal',
    ),
    r'sunday': PropertySchema(
      id: 3,
      name: r'sunday',
      type: IsarType.object,
      target: r'DailyMeal',
    ),
    r'thursday': PropertySchema(
      id: 4,
      name: r'thursday',
      type: IsarType.object,
      target: r'DailyMeal',
    ),
    r'tuesday': PropertySchema(
      id: 5,
      name: r'tuesday',
      type: IsarType.object,
      target: r'DailyMeal',
    ),
    r'wednesday': PropertySchema(
      id: 6,
      name: r'wednesday',
      type: IsarType.object,
      target: r'DailyMeal',
    )
  },
  estimateSize: _mealPlannerEstimateSize,
  serialize: _mealPlannerSerialize,
  deserialize: _mealPlannerDeserialize,
  deserializeProp: _mealPlannerDeserializeProp,
  idName: r'isarId',
  indexes: {},
  links: {},
  embeddedSchemas: {
    r'DailyMeal': DailyMealSchema,
    r'Meal': MealSchema,
    r'MealNutrients': MealNutrientsSchema
  },
  getId: _mealPlannerGetId,
  getLinks: _mealPlannerGetLinks,
  attach: _mealPlannerAttach,
  version: '3.1.0+1',
);

int _mealPlannerEstimateSize(
  MealPlanner object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 +
      DailyMealSchema.estimateSize(
          object.friday, allOffsets[DailyMeal]!, allOffsets);
  bytesCount += 3 +
      DailyMealSchema.estimateSize(
          object.monday, allOffsets[DailyMeal]!, allOffsets);
  bytesCount += 3 +
      DailyMealSchema.estimateSize(
          object.saturday, allOffsets[DailyMeal]!, allOffsets);
  bytesCount += 3 +
      DailyMealSchema.estimateSize(
          object.sunday, allOffsets[DailyMeal]!, allOffsets);
  bytesCount += 3 +
      DailyMealSchema.estimateSize(
          object.thursday, allOffsets[DailyMeal]!, allOffsets);
  bytesCount += 3 +
      DailyMealSchema.estimateSize(
          object.tuesday, allOffsets[DailyMeal]!, allOffsets);
  bytesCount += 3 +
      DailyMealSchema.estimateSize(
          object.wednesday, allOffsets[DailyMeal]!, allOffsets);
  return bytesCount;
}

void _mealPlannerSerialize(
  MealPlanner object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeObject<DailyMeal>(
    offsets[0],
    allOffsets,
    DailyMealSchema.serialize,
    object.friday,
  );
  writer.writeObject<DailyMeal>(
    offsets[1],
    allOffsets,
    DailyMealSchema.serialize,
    object.monday,
  );
  writer.writeObject<DailyMeal>(
    offsets[2],
    allOffsets,
    DailyMealSchema.serialize,
    object.saturday,
  );
  writer.writeObject<DailyMeal>(
    offsets[3],
    allOffsets,
    DailyMealSchema.serialize,
    object.sunday,
  );
  writer.writeObject<DailyMeal>(
    offsets[4],
    allOffsets,
    DailyMealSchema.serialize,
    object.thursday,
  );
  writer.writeObject<DailyMeal>(
    offsets[5],
    allOffsets,
    DailyMealSchema.serialize,
    object.tuesday,
  );
  writer.writeObject<DailyMeal>(
    offsets[6],
    allOffsets,
    DailyMealSchema.serialize,
    object.wednesday,
  );
}

MealPlanner _mealPlannerDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = MealPlanner(
    friday: reader.readObjectOrNull<DailyMeal>(
          offsets[0],
          DailyMealSchema.deserialize,
          allOffsets,
        ) ??
        DailyMeal(),
    monday: reader.readObjectOrNull<DailyMeal>(
          offsets[1],
          DailyMealSchema.deserialize,
          allOffsets,
        ) ??
        DailyMeal(),
    saturday: reader.readObjectOrNull<DailyMeal>(
          offsets[2],
          DailyMealSchema.deserialize,
          allOffsets,
        ) ??
        DailyMeal(),
    sunday: reader.readObjectOrNull<DailyMeal>(
          offsets[3],
          DailyMealSchema.deserialize,
          allOffsets,
        ) ??
        DailyMeal(),
    thursday: reader.readObjectOrNull<DailyMeal>(
          offsets[4],
          DailyMealSchema.deserialize,
          allOffsets,
        ) ??
        DailyMeal(),
    tuesday: reader.readObjectOrNull<DailyMeal>(
          offsets[5],
          DailyMealSchema.deserialize,
          allOffsets,
        ) ??
        DailyMeal(),
    wednesday: reader.readObjectOrNull<DailyMeal>(
          offsets[6],
          DailyMealSchema.deserialize,
          allOffsets,
        ) ??
        DailyMeal(),
  );
  object.isarId = id;
  return object;
}

P _mealPlannerDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readObjectOrNull<DailyMeal>(
            offset,
            DailyMealSchema.deserialize,
            allOffsets,
          ) ??
          DailyMeal()) as P;
    case 1:
      return (reader.readObjectOrNull<DailyMeal>(
            offset,
            DailyMealSchema.deserialize,
            allOffsets,
          ) ??
          DailyMeal()) as P;
    case 2:
      return (reader.readObjectOrNull<DailyMeal>(
            offset,
            DailyMealSchema.deserialize,
            allOffsets,
          ) ??
          DailyMeal()) as P;
    case 3:
      return (reader.readObjectOrNull<DailyMeal>(
            offset,
            DailyMealSchema.deserialize,
            allOffsets,
          ) ??
          DailyMeal()) as P;
    case 4:
      return (reader.readObjectOrNull<DailyMeal>(
            offset,
            DailyMealSchema.deserialize,
            allOffsets,
          ) ??
          DailyMeal()) as P;
    case 5:
      return (reader.readObjectOrNull<DailyMeal>(
            offset,
            DailyMealSchema.deserialize,
            allOffsets,
          ) ??
          DailyMeal()) as P;
    case 6:
      return (reader.readObjectOrNull<DailyMeal>(
            offset,
            DailyMealSchema.deserialize,
            allOffsets,
          ) ??
          DailyMeal()) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _mealPlannerGetId(MealPlanner object) {
  return object.isarId ?? Isar.autoIncrement;
}

List<IsarLinkBase<dynamic>> _mealPlannerGetLinks(MealPlanner object) {
  return [];
}

void _mealPlannerAttach(
    IsarCollection<dynamic> col, Id id, MealPlanner object) {
  object.isarId = id;
}

extension MealPlannerQueryWhereSort
    on QueryBuilder<MealPlanner, MealPlanner, QWhere> {
  QueryBuilder<MealPlanner, MealPlanner, QAfterWhere> anyIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension MealPlannerQueryWhere
    on QueryBuilder<MealPlanner, MealPlanner, QWhereClause> {
  QueryBuilder<MealPlanner, MealPlanner, QAfterWhereClause> isarIdEqualTo(
      Id isarId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: isarId,
        upper: isarId,
      ));
    });
  }

  QueryBuilder<MealPlanner, MealPlanner, QAfterWhereClause> isarIdNotEqualTo(
      Id isarId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: isarId, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: isarId, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: isarId, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: isarId, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<MealPlanner, MealPlanner, QAfterWhereClause> isarIdGreaterThan(
      Id isarId,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: isarId, includeLower: include),
      );
    });
  }

  QueryBuilder<MealPlanner, MealPlanner, QAfterWhereClause> isarIdLessThan(
      Id isarId,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: isarId, includeUpper: include),
      );
    });
  }

  QueryBuilder<MealPlanner, MealPlanner, QAfterWhereClause> isarIdBetween(
    Id lowerIsarId,
    Id upperIsarId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerIsarId,
        includeLower: includeLower,
        upper: upperIsarId,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension MealPlannerQueryFilter
    on QueryBuilder<MealPlanner, MealPlanner, QFilterCondition> {
  QueryBuilder<MealPlanner, MealPlanner, QAfterFilterCondition> isarIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'isarId',
      ));
    });
  }

  QueryBuilder<MealPlanner, MealPlanner, QAfterFilterCondition>
      isarIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'isarId',
      ));
    });
  }

  QueryBuilder<MealPlanner, MealPlanner, QAfterFilterCondition> isarIdEqualTo(
      Id? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<MealPlanner, MealPlanner, QAfterFilterCondition>
      isarIdGreaterThan(
    Id? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<MealPlanner, MealPlanner, QAfterFilterCondition> isarIdLessThan(
    Id? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<MealPlanner, MealPlanner, QAfterFilterCondition> isarIdBetween(
    Id? lower,
    Id? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'isarId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension MealPlannerQueryObject
    on QueryBuilder<MealPlanner, MealPlanner, QFilterCondition> {
  QueryBuilder<MealPlanner, MealPlanner, QAfterFilterCondition> friday(
      FilterQuery<DailyMeal> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'friday');
    });
  }

  QueryBuilder<MealPlanner, MealPlanner, QAfterFilterCondition> monday(
      FilterQuery<DailyMeal> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'monday');
    });
  }

  QueryBuilder<MealPlanner, MealPlanner, QAfterFilterCondition> saturday(
      FilterQuery<DailyMeal> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'saturday');
    });
  }

  QueryBuilder<MealPlanner, MealPlanner, QAfterFilterCondition> sunday(
      FilterQuery<DailyMeal> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'sunday');
    });
  }

  QueryBuilder<MealPlanner, MealPlanner, QAfterFilterCondition> thursday(
      FilterQuery<DailyMeal> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'thursday');
    });
  }

  QueryBuilder<MealPlanner, MealPlanner, QAfterFilterCondition> tuesday(
      FilterQuery<DailyMeal> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'tuesday');
    });
  }

  QueryBuilder<MealPlanner, MealPlanner, QAfterFilterCondition> wednesday(
      FilterQuery<DailyMeal> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'wednesday');
    });
  }
}

extension MealPlannerQueryLinks
    on QueryBuilder<MealPlanner, MealPlanner, QFilterCondition> {}

extension MealPlannerQuerySortBy
    on QueryBuilder<MealPlanner, MealPlanner, QSortBy> {}

extension MealPlannerQuerySortThenBy
    on QueryBuilder<MealPlanner, MealPlanner, QSortThenBy> {
  QueryBuilder<MealPlanner, MealPlanner, QAfterSortBy> thenByIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.asc);
    });
  }

  QueryBuilder<MealPlanner, MealPlanner, QAfterSortBy> thenByIsarIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.desc);
    });
  }
}

extension MealPlannerQueryWhereDistinct
    on QueryBuilder<MealPlanner, MealPlanner, QDistinct> {}

extension MealPlannerQueryProperty
    on QueryBuilder<MealPlanner, MealPlanner, QQueryProperty> {
  QueryBuilder<MealPlanner, int, QQueryOperations> isarIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isarId');
    });
  }

  QueryBuilder<MealPlanner, DailyMeal, QQueryOperations> fridayProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'friday');
    });
  }

  QueryBuilder<MealPlanner, DailyMeal, QQueryOperations> mondayProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'monday');
    });
  }

  QueryBuilder<MealPlanner, DailyMeal, QQueryOperations> saturdayProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'saturday');
    });
  }

  QueryBuilder<MealPlanner, DailyMeal, QQueryOperations> sundayProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'sunday');
    });
  }

  QueryBuilder<MealPlanner, DailyMeal, QQueryOperations> thursdayProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'thursday');
    });
  }

  QueryBuilder<MealPlanner, DailyMeal, QQueryOperations> tuesdayProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'tuesday');
    });
  }

  QueryBuilder<MealPlanner, DailyMeal, QQueryOperations> wednesdayProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'wednesday');
    });
  }
}
