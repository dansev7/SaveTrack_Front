// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_models.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TransactionAdapter extends TypeAdapter<Transaction> {
  @override
  final typeId = 0;

  @override
  Transaction read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Transaction(
      id: fields[0] as String,
      amount: (fields[1] as num).toDouble(),
      type: (fields[2] as num).toInt(),
      description: fields[3] as String,
      date: fields[4] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, Transaction obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.amount)
      ..writeByte(2)
      ..write(obj.type)
      ..writeByte(3)
      ..write(obj.description)
      ..writeByte(4)
      ..write(obj.date);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TransactionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class DashboardDataAdapter extends TypeAdapter<DashboardData> {
  @override
  final typeId = 1;

  @override
  DashboardData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DashboardData(
      totalBalance: (fields[0] as num).toDouble(),
      monthlyIncome: (fields[1] as num).toDouble(),
      monthlyExpenses: (fields[2] as num).toDouble(),
      monthlySavings: (fields[3] as num).toDouble(),
      recentTransactions: (fields[4] as List).cast<Transaction>(),
    );
  }

  @override
  void write(BinaryWriter writer, DashboardData obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.totalBalance)
      ..writeByte(1)
      ..write(obj.monthlyIncome)
      ..writeByte(2)
      ..write(obj.monthlyExpenses)
      ..writeByte(3)
      ..write(obj.monthlySavings)
      ..writeByte(4)
      ..write(obj.recentTransactions);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DashboardDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
