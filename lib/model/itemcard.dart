import 'package:catatbeli/model/itemcard_formz.dart';
import 'package:equatable/equatable.dart';
// import 'package:flutter/material.dart';
import 'package:formz/formz.dart';
// import 'itemcard_formz.dart';

enum DiscountMode { total, perPcs }

enum ModeHarga { total, pcs }

class ItemCards extends Equatable with FormzMixin {
  final NamaBarang namaBarang;
  final Hargabeli hargaBeli;
  final int? hargaJual;
  final Discount discount;
  final DiscountMode discountMode;
  final ModeHarga modeHarga;
  final Pcs pcs;
  final int? productId;
  final int? cardId; //~??????
  final String? note;
  final Tempatbeli tempatBeli;
  final Barcode barcode;
  final bool? open;
  final bool? created;
  final bool? fromOCR;
  final DateTime? ditambahkan;

  const ItemCards(
      {this.namaBarang = const NamaBarang.pure(),
      this.hargaBeli = const Hargabeli.pure(),
      this.discount = const Discount.pure(),
      this.productId,
      this.hargaJual,
      this.modeHarga = ModeHarga.pcs,
      this.discountMode = DiscountMode.total,
      this.pcs = const Pcs.pure(),
      this.created,
      this.note,
      this.barcode = const Barcode.pure(),
      this.tempatBeli = const Tempatbeli.pure(),
      this.open,
      this.ditambahkan,
      this.cardId,
      this.fromOCR});
  ItemCards copywith(
      {NamaBarang? namaBarang,
      Discount? discount,
      Hargabeli? hargaBeli,
      int? hargaJual,
      Pcs? pcs,
      ModeHarga? modeHarga,
      DiscountMode? discountMode,
      Tempatbeli? tempatBeli,
      int? Function()? productId,
      bool? Function()? open,
      bool? Function()? fromOCR,
      bool? Function()? created,
      String? note,
      // GlobalKey<FormState>? formkey,
      Barcode? barcode,
      DateTime? ditambahkan,
      int? id}) {
    return ItemCards(
        discount: discount ?? this.discount,
        barcode: barcode ?? this.barcode,
        modeHarga: modeHarga ?? this.modeHarga,
        discountMode: discountMode ?? this.discountMode,
        open: open != null ? open() : this.open,
        fromOCR: fromOCR != null ? fromOCR() : this.fromOCR,
        created: created != null ? created() : this.created,
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
        namaBarang.value,
        hargaBeli.value,
        hargaJual,
        pcs.value,
        modeHarga.index,
        discountMode.index,
        tempatBeli.value,
        cardId,
        note,
        open,
        discount.value,
        // created,
        barcode.value,
        productId,
        ditambahkan,
      ];

  static ItemCards fromJson(Map<String, dynamic> json) {
    // print('ditambah' + json['ditambahkan'].toString());
    return ItemCards(
        barcode: Barcode.dirty(json['barcode']),
        open: json['open'] ?? true,
        discount: Discount.dirty(json['discount']),
        namaBarang: NamaBarang.dirty(json['namaBarang']),
        created: json['created'],
        // created: json['namaBarang'],
        modeHarga: ModeHarga.values[json['modeHarga']],
        discountMode: DiscountMode.values[json['discountMode']],
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
      'discount': this.discount.value,
      'open': this.open ?? true,
      'created': this.created ?? true,
      'modeHarga': this.modeHarga.index,
      'discountMode': this.discountMode.index,
      'namaBarang': this.namaBarang.value,
      'productId': this.productId,
      'cardId': this.cardId,
      'pcs': this.pcs.value,
      'hargaBeli': this.hargaBeli.value,
      // 'hargaJual': this.hargaJual,
      'tempatBeli': this.tempatBeli.value,
      'ditambahkan': this.ditambahkan.toString(),
      'note': this.note,
    };
  }

  @override
  List<FormzInput> get inputs =>
      [namaBarang, hargaBeli, pcs, tempatBeli, barcode, discount];
}
