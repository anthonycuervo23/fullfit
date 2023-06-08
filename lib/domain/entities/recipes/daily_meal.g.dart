// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daily_meal.dart';

// **************************************************************************
// IsarEmbeddedGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const DailyMealSchema = Schema(
  name: r'DailyMeal',
  id: 9210083310060916309,
  properties: {
    r'meals': PropertySchema(
      id: 0,
      name: r'meals',
      type: IsarType.objectList,
      target: r'Meal',
    ),
    r'nutrients': PropertySchema(
      id: 1,
      name: r'nutrients',
      type: IsarType.object,
      target: r'MealNutrients',
    )
  },
  estimateSize: _dailyMealEstimateSize,
  serialize: _dailyMealSerialize,
  deserialize: _dailyMealDeserialize,
  deserializeProp: _dailyMealDeserializeProp,
);

int _dailyMealEstimateSize(
  DailyMeal object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final list = object.meals;
    if (list != null) {
      bytesCount += 3 + list.length * 3;
      {
        final offsets = allOffsets[Meal]!;
        for (var i = 0; i < list.length; i++) {
          final value = list[i];
          bytesCount += MealSchema.estimateSize(value, offsets, allOffsets);
        }
      }
    }
  }
  {
    final value = object.nutrients;
    if (value != null) {
      bytesCount += 3 +
          MealNutrientsSchema.estimateSize(
              value, allOffsets[MealNutrients]!, allOffsets);
    }
  }
  return bytesCount;
}

void _dailyMealSerialize(
  DailyMeal object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeObjectList<Meal>(
    offsets[0],
    allOffsets,
    MealSchema.serialize,
    object.meals,
  );
  writer.writeObject<MealNutrients>(
    offsets[1],
    allOffsets,
    MealNutrientsSchema.serialize,
    object.nutrients,
  );
}

DailyMeal _dailyMealDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = DailyMeal(
    meals: reader.readObjectList<Meal>(
      offsets[0],
      MealSchema.deserialize,
      allOffsets,
      Meal(),
    ),
    nutrients: reader.readObjectOrNull<MealNutrients>(
      offsets[1],
      MealNutrientsSchema.deserialize,
      allOffsets,
    ),
  );
  return object;
}

P _dailyMealDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readObjectList<Meal>(
        offset,
        MealSchema.deserialize,
        allOffsets,
        Meal(),
      )) as P;
    case 1:
      return (reader.readObjectOrNull<MealNutrients>(
        offset,
        MealNutrientsSchema.deserialize,
        allOffsets,
      )) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

extension DailyMealQueryFilter
    on QueryBuilder<DailyMeal, DailyMeal, QFilterCondition> {
  QueryBuilder<DailyMeal, DailyMeal, QAfterFilterCondition> mealsIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'meals',
      ));
    });
  }

  QueryBuilder<DailyMeal, DailyMeal, QAfterFilterCondition> mealsIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'meals',
      ));
    });
  }

  QueryBuilder<DailyMeal, DailyMeal, QAfterFilterCondition> mealsLengthEqualTo(
      int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'meals',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<DailyMeal, DailyMeal, QAfterFilterCondition> mealsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'meals',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<DailyMeal, DailyMeal, QAfterFilterCondition> mealsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'meals',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<DailyMeal, DailyMeal, QAfterFilterCondition> mealsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'meals',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<DailyMeal, DailyMeal, QAfterFilterCondition>
      mealsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'meals',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<DailyMeal, DailyMeal, QAfterFilterCondition> mealsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'meals',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<DailyMeal, DailyMeal, QAfterFilterCondition> nutrientsIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'nutrients',
      ));
    });
  }

  QueryBuilder<DailyMeal, DailyMeal, QAfterFilterCondition>
      nutrientsIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'nutrients',
      ));
    });
  }
}

extension DailyMealQueryObject
    on QueryBuilder<DailyMeal, DailyMeal, QFilterCondition> {
  QueryBuilder<DailyMeal, DailyMeal, QAfterFilterCondition> mealsElement(
      FilterQuery<Meal> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'meals');
    });
  }

  QueryBuilder<DailyMeal, DailyMeal, QAfterFilterCondition> nutrients(
      FilterQuery<MealNutrients> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'nutrients');
    });
  }
}
