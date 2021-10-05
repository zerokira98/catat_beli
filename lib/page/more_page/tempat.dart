import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kasir/msc/db_moor.dart';

class TempatEdit extends StatelessWidget {
  const TempatEdit({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<TempatBeli>>(
          future: RepositoryProvider.of<MyDatabase>(context).datatempat(),
          builder: (context, snap) {
            if (snap.hasData && snap.data != null) {
              return ListView.builder(
                itemBuilder: (context, i) {
                  return ListTile(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  FormTempatEdit(snap.data![i])));
                    },
                    title: Text('${snap.data![i].nama}'),
                  );
                },
                itemCount: snap.data!.length,
              );
            }
            return Container();
          }),
    );
  }
}

class FormTempatEdit extends StatelessWidget {
  final namaController = TextEditingController();
  final TempatBeli tempatBeli;
  FormTempatEdit(TempatBeli tempatBeli, {Key? key})
      : this.tempatBeli = tempatBeli,
        super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        child: Column(
          children: [
            TextFormField(
              controller: namaController,
              decoration: InputDecoration(label: Text('Nama Tempat')),
            )
          ],
        ),
      ),
    );
  }
}
