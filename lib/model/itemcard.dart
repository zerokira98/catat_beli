import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class ItemCards extends Equatable {
  final String? namaBarang;
  final int? hargaBeli;
  final int? hargaJual;
  final double? pcs;
  final GlobalKey<FormState>? formkey;
  final int? productId;
  final int? cardId; //~??????
  final String? tempatBeli;
  final int? barcode;
  final bool? open;
  final DateTime? ditambahkan;

  ItemCards(
      {this.namaBarang,
      this.hargaBeli,
      this.productId,
      this.hargaJual,
      this.pcs,
      this.formkey,
      this.barcode,
      this.tempatBeli,
      this.open,
      this.ditambahkan,
      this.cardId});
  ItemCards copywith(
      {String? namaBarang,
      int? hargaBeli,
      int? hargaJual,
      double? pcs,
      String? tempatBeli,
      int? productId,
      bool? open,
      GlobalKey<FormState>? formkey,
      int? barcode,
      DateTime? ditambahkan,
      int? id}) {
    return ItemCards(
        barcode: barcode ?? this.barcode,
        open: open ?? this.open,
        namaBarang: namaBarang ?? this.namaBarang,
        formkey: formkey ?? this.formkey,
        productId: productId ?? this.productId,
        ditambahkan: ditambahkan ?? this.ditambahkan,
        hargaBeli: hargaBeli ?? this.hargaBeli,
        hargaJual: hargaJual ?? this.hargaJual,
        pcs: pcs ?? this.pcs,
        tempatBeli: tempatBeli ?? this.tempatBeli,
        cardId: id ?? this.cardId);
  }

  @override
  List<Object?> get props => [
        namaBarang,
        hargaBeli,
        hargaJual,
        pcs,
        tempatBeli,
        cardId,
        open,
        barcode,
        productId,
        ditambahkan,
        formkey
      ];

  @override
  String toString() {
    return 'open : $open';
    // return '''{id: $id,nama: $name,open:$open,$hargaBeli, $hargaJual,
    // $pcs, $tempatBeli, $id, $expdate, $barcode,$productId}''';
  }

  static ItemCards fromMap(Map data) {
    return ItemCards(
      barcode: data['BARCODE'],
      // open: data[''],
      namaBarang: data['NAMA'],
      // formkey: formkey ?? this.formkey,
      productId: data['ID'],
      // ditambahkan: DateTime.parse(data['ADD_DATE']),
      // hargaBeli: data['HARGA_BELI'],
      hargaJual: data['HARGA_JUAL'],
      pcs: data['JUMLAH'],
      // tempatBeli: data['SUPPLIER'],
      // id: data['id']
    );
  }
}
