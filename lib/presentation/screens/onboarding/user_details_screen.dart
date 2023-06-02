import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UserDetailsScreen extends StatefulWidget {
  const UserDetailsScreen({Key? key}) : super(key: key);

  @override
  _UserDetailsScreenState createState() => _UserDetailsScreenState();
}

class _UserDetailsScreenState extends State<UserDetailsScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _surnameController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  String? _ageGroup;

  final List<String> _ageGroups = [
    '18-24',
    '25-34',
    '35-54',
    '55+',
  ];

  @override
  Widget build(BuildContext context) {
    final textStyles = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        //TODO: crear un widget para este titulo que se repite en todas las paginas
        title: Text(
          'Introduce tus datos',
          textAlign: TextAlign.center,
          style: textStyles.titleMedium,
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.w),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              TextFormField(
                initialValue: '',
                keyboardType: TextInputType.emailAddress,
                textAlign: TextAlign.center,
                // onChanged:
                //     ref.watch(onBoardingNotifierProvider.notifier).onEmailChanged,
                decoration: InputDecoration(
                  filled: true,
                  hintText: 'Ingresa tu nombre',
                  hintStyle: textStyles.bodyMedium?.copyWith(
                    color: colors.onBackground.withOpacity(0.5),
                    fontSize: 18.sp,
                  ),
                  contentPadding: const EdgeInsets.all(20),
                  fillColor: colors.surface,
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none),
                ),
              ),
              TextFormField(
                initialValue: '',
                keyboardType: TextInputType.emailAddress,
                textAlign: TextAlign.center,
                // onChanged:
                //     ref.watch(onBoardingNotifierProvider.notifier).onEmailChanged,
                decoration: InputDecoration(
                  filled: true,
                  hintText: 'Ingresa tu apellido',
                  hintStyle: textStyles.bodyMedium?.copyWith(
                    color: colors.onBackground.withOpacity(0.5),
                    fontSize: 18.sp,
                  ),
                  contentPadding: const EdgeInsets.all(20),
                  fillColor: colors.surface,
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none),
                ),
              ),
              //TODO: elegir el peso y la altura con un slider
              TextFormField(
                initialValue: '',
                keyboardType: TextInputType.emailAddress,
                textAlign: TextAlign.center,
                // onChanged:
                //     ref.watch(onBoardingNotifierProvider.notifier).onEmailChanged,
                decoration: InputDecoration(
                  filled: true,
                  hintText: 'Ingresa tu peso (kg)',
                  hintStyle: textStyles.bodyMedium?.copyWith(
                    color: colors.onBackground.withOpacity(0.5),
                    fontSize: 18.sp,
                  ),
                  contentPadding: const EdgeInsets.all(20),
                  fillColor: colors.surface,
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none),
                ),
              ),
              TextFormField(
                initialValue: '',
                keyboardType: TextInputType.emailAddress,
                textAlign: TextAlign.center,
                // onChanged:
                //     ref.watch(onBoardingNotifierProvider.notifier).onEmailChanged,
                decoration: InputDecoration(
                  filled: true,
                  hintText: 'Ingresa tu altura (cm)',
                  hintStyle: textStyles.bodyMedium?.copyWith(
                    color: colors.onBackground.withOpacity(0.5),
                    fontSize: 18.sp,
                  ),
                  contentPadding: const EdgeInsets.all(20),
                  fillColor: colors.surface,
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none),
                ),
              ),
              DropdownButton<String>(
                hint: Text('Selecciona tu grupo de edad',
                    style: textStyles.bodyMedium),
                value: _ageGroup,
                onChanged: (String? newValue) {
                  setState(() {
                    _ageGroup = newValue;
                  });
                },
                items: _ageGroups.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value, style: textStyles.bodyMedium),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
