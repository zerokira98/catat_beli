import 'package:bloc/bloc.dart';
import 'package:catatbeli/model/itemcard.dart';
import 'package:catatbeli/msc/db_moor.dart';
// import 'package:equatable/equatable.dart';

// part 'editstock_state.dart';

class EditstockCubit extends Cubit<ItemCards> {
  MyDatabase db;
  EditstockCubit(this.db) : super(ItemCards()) {}
  update(ItemCards item) {
    // var newdata = item;
    emit(item);
  }

  sendToDB() {
    var a = state;
    return db.updateStock(a);
  }
}
