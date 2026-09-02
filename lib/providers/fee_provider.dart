import 'package:flutter/material.dart';
import 'package:madrasa_soffa/models/fee.dart';
import 'package:madrasa_soffa/repositories/fee_repository.dart';

class FeeProvider with ChangeNotifier {
  final FeeRepository _feeRepository = FeeRepository();
  List<Fee> _fees = [];

  List<Fee> get fees => _fees;

  Future<void> loadFees() async {
    _fees = await _feeRepository.getAllFees();
    notifyListeners();
  }

  Future<void> loadFeesForStudent(int studentId) async {
    _fees = await _feeRepository.getFeesForStudent(studentId);
    notifyListeners();
  }

  Future<void> addFee(Fee fee) async {
    await _feeRepository.addFee(fee);
    await loadFees();
  }
}
