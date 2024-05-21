import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

final maskFormatter = MaskTextInputFormatter(
  mask: '+62 ###-###-###-###',
  filter: {"#": RegExp(r'[0-9]')},
  type: MaskAutoCompletionType.lazy,
);

class PengendaraDetailForm extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSubmit;
  const PengendaraDetailForm(
      {super.key, required this.controller, required this.onSubmit});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Lengkapi data diri"),
      content: TextField(
        controller: controller,
        inputFormatters: [maskFormatter],
        decoration: const InputDecoration(hintText: "+62 ###-###-###-###"),
      ),
      actions: [
        Theme(
          data: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.redAccent),
          ),
          child: TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Kembali'),
          ),
        ),
        TextButton(
          onPressed: onSubmit,
          child: const Text('Simpan'),
        ),
      ],
    );
  }
}
