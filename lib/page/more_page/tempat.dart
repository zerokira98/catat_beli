import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:catatbeli/msc/db_moor.dart';

class TempatEdit extends StatefulWidget {
  const TempatEdit({Key? key}) : super(key: key);

  @override
  State<TempatEdit> createState() => _TempatEditState();
}

class _TempatEditState extends State<TempatEdit> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Tempat'),
      ),
      body: FutureBuilder<List<TempatBeli>>(
          future: RepositoryProvider.of<MyDatabase>(context).datatempat(),
          builder: (context, snap) {
            if (snap.hasData && snap.data != null) {
              print(snap.data);
              return ListView.builder(
                itemBuilder: (context, i) {
                  return i != 0
                      ? ListTile(
                          onTap: () async {
                            await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        FormTempatEdit(snap.data![i])));
                            setState(() {});
                          },
                          title: Text('${snap.data![i].nama}'),
                        )
                      : Container();
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
  final TempatBeli tempatBeli;
  final TextEditingController namaController;
  final TextEditingController alamatController;
  FormTempatEdit(this.tempatBeli, {Key? key})
      : namaController = TextEditingController(text: tempatBeli.nama),
        alamatController = TextEditingController(text: tempatBeli.alamat ?? ''),
        // : this.tempatBeli = tempatBeli,
        super(key: key);
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Card(
        margin: EdgeInsets.all(8.0),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: Row(
            children: [
              Expanded(
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        validator: (value) {
                          if (value == null) {
                            return "Can't be empty";
                          }
                          if (value.length < 2) {
                            return "At least 3 char";
                          }
                          return null;
                        },
                        controller: namaController,
                        decoration: InputDecoration(label: Text('Nama Tempat')),
                      ),
                      TextFormField(
                        validator: (value) {
                          if (value == null) {
                            return "Can't be empty";
                          }
                          if (value.length < 2) {
                            return "At least 3 char";
                          }
                          return null;
                        },
                        controller: alamatController,
                        decoration: InputDecoration(label: Text('Alamat')),
                      )
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
              ),
              ElevatedButton(
                  child: Text('Save'),
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      print('here');
                      await RepositoryProvider.of<MyDatabase>(context)
                          .updateNamaTempat(
                        tempatBeli.id,
                        namaController.text,
                        alamatController.text,
                      );
                      print('here' + namaController.text);
                      Navigator.pop(context);
                    } else {
                      print('Hello');
                    }
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
