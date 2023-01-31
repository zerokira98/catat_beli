import 'package:formz/formz.dart';

enum NamaBarangValidationError { empty, atleast3 }

class NamaBarang extends FormzInput<String, NamaBarangValidationError> {
  const NamaBarang.pure() : super.pure('');
  const NamaBarang.dirty([super.value = '']) : super.dirty();

  @override
  NamaBarangValidationError? validator(String value) {
    if (value.isEmpty) return NamaBarangValidationError.empty;
    if (value.length < 3) return NamaBarangValidationError.atleast3;
    return null;
  }
}

enum HargabeliValidationError { empty, negative, toosmall }

class Hargabeli extends FormzInput<int, HargabeliValidationError> {
  const Hargabeli.pure() : super.pure(0);
  const Hargabeli.dirty([super.value = 0]) : super.dirty();

  @override
  HargabeliValidationError? validator(int value) {
    if (value == 0) return HargabeliValidationError.empty;
    if (value < 0) return HargabeliValidationError.negative;
    // if (value < 99) return HargabeliValidationError.toosmall;
    return null;
  }
}

enum TempatbeliValidationError { empty, mustnumber }

class Tempatbeli extends FormzInput<String, TempatbeliValidationError> {
  const Tempatbeli.pure() : super.pure('');
  const Tempatbeli.dirty([super.value = '']) : super.dirty();

  @override
  TempatbeliValidationError? validator(String value) {
    // if (value == '') return TempatbeliValidationError.empty;
    return null;
  }
}

enum PcsValidationError { empty, negative }

class Pcs extends FormzInput<double, PcsValidationError> {
  const Pcs.pure() : super.pure(0.0);
  const Pcs.dirty([super.value = 0.0]) : super.dirty();

  @override
  PcsValidationError? validator(double value) {
    if (value == 0.0) return PcsValidationError.empty;
    if (value < 0) return PcsValidationError.negative;
    return null;
  }
}

enum BarcodeValidationError { empty, negative }

class Barcode extends FormzInput<int, BarcodeValidationError> {
  const Barcode.pure() : super.pure(0);
  const Barcode.dirty([super.value = 0]) : super.dirty();

  @override
  BarcodeValidationError? validator(int value) {
    // if (value == 0) return BarcodeValidationError.empty;
    if (value < 0) return BarcodeValidationError.negative;
    return null;
  }
}
