import 'package:catatbeli/model/itemcard_formz.dart';
import 'package:equatable/equatable.dart';
// import 'package:flutter/material.dart';
import 'package:formz/formz.dart';
// import 'itemcard_formz.dart';

class ItemCards extends Equatable with FormzMixin {
  final NamaBarang namaBarang;
  final Hargabeli hargaBeli;
  final int? hargaJual;
  final Pcs pcs;
  final int? productId;
  final int? cardId; //~??????
  final String? note;
  final Tempatbeli tempatBeli;
  final Barcode barcode;
  final bool? open;
  final bool? created;
  final DateTime? ditambahkan;

  const ItemCards(
      {this.namaBarang = const NamaBarang.pure(),
      this.hargaBeli = const Hargabeli.pure(),
      this.productId,
      this.hargaJual,
      this.pcs = const Pcs.pure(),
      this.created,
      this.note,
      this.barcode = const Barcode.pure(),
      this.tempatBeli = const Tempatbeli.pure(),
      this.open,
      this.ditambahkan,
      this.cardId});
  ItemCards copywith(
      {NamaBarang? namaBarang,
      Hargabeli? hargaBeli,
      int? hargaJual,
      Pcs? pcs,
      Tempatbeli? tempatBeli,
      int? Function()? productId,
      bool? open,
      bool? created,
      String? note,
      // GlobalKey<FormState>? formkey,
      Barcode? barcode,
      DateTime? ditambahkan,
      int? id}) {
    return ItemCards(
        barcode: barcode ?? this.barcode,
        open: open ?? this.open,
        created: created ?? this.created,
        namaBarang: namaBarang ?? this.namaBarang,
        productId: productId != null ? productId() : this.productId,
        ditambahkan: ditambahkan ?? this.ditambahkan,
        hargaBeli: hargaBeli ?? this.hargaBeli,
        note: note ?? this.note,
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
        note,
        open,
        // created,
        barcode,
        productId,
        ditambahkan,
      ];

  @override
  String toString() {
    return [
      namaBarang,
      hargaBeli,
      hargaJual,
      note,
      pcs,
      tempatBeli,
      cardId,
      open,
      created,
      barcode,
      productId,
      ditambahkan,
    ].toString();
    // return 'open : $open';
    // return '''{id: $id,nama: $name,open:$open,$hargaBeli, $hargaJual,
    // $pcs, $tempatBeli, $id, $expdate, $barcode,$productId}''';
  }

  ItemCards fromJson(Map<String, dynamic> json) {
    print('ditambah' + json['ditambahkan'].toString());
    return ItemCards(
        barcode: json['barcode'],
        open: json['open'],
        namaBarang: NamaBarang.dirty(json['namaBarang']),
        created: true,
        // formkey: formkey ?? this.formkey,
        productId: json['productId'],
        ditambahkan: DateTime.tryParse(json['ditambahkan'].toString()),
        hargaBeli: Hargabeli.dirty(json['hargaBeli']),
        hargaJual: json['hargaJual'],
        pcs: Pcs.dirty(json['pcs']),
        tempatBeli: Tempatbeli.dirty(json['tempatBeli']),
        cardId: json['cardId'],
        note: json['note']
        // id: json['id']
        );
  }

  Map<String, dynamic>? toJson() {
    return {
      'barcode': this.barcode.value,
      'open': this.open,
      'created': true,
      'namaBarang': this.namaBarang.value,
      'productId': this.productId,
      'cardId': this.cardId,
      'pcs': this.pcs.value,
      'hargaBeli': this.hargaBeli.value,
      'hargaJual': this.hargaJual,
      'tempatBeli': this.tempatBeli.value,
      'ditambahkan': this.ditambahkan.toString(),
      'note': this.note,
    };
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

  @override
  // TODO: implement inputs
  List<FormzInput> get inputs =>
      [namaBarang, hargaBeli, pcs, tempatBeli, barcode];
}
