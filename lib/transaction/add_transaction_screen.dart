import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../theme/text_theme.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_date_picker.dart';
import 'controller/add_transaction_controller.dart';
import '../auth/controller/login_controller.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AddTransScreen extends StatefulWidget {
  @override
  _AddTransScreenState createState() => _AddTransScreenState();
}

class _AddTransScreenState extends State<AddTransScreen> {
  bool isIncome = true;
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime? _selectedDate;

  late AddTransactionController _controller;
  final FlutterSecureStorage secureStorage = FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)!.settings.arguments as LoginController?;
    if (args != null) {
      _controller = AddTransactionController(args.user!.userId.toString(), secureStorage);
    } else {
      // Tangani kasus di mana argumen tidak ada
      // Misalnya, navigasikan kembali ke layar sebelumnya atau tampilkan pesan kesalahan
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memuat data pengguna')),
      );
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ADD TRANSACTION', style: appBarText),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            fixedSize: Size(160, 60),
                            backgroundColor: isIncome ? tertiaryColor : Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () {
                            setState(() {
                              isIncome = true;
                            });
                          },
                          child: Text('Pemasukkan',
                              style: primaryText.copyWith(
                                  color: isIncome ? primaryColor : Colors.black,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14)),
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            fixedSize: Size(160, 60),
                            backgroundColor: !isIncome ? tertiaryColor : Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () {
                            setState(() {
                              isIncome = false;
                            });
                          },
                          child: Text('Pengeluaran',
                              style: primaryText.copyWith(
                                  color: !isIncome ? primaryColor : Colors.black,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14)),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: _titleController,
                    decoration: InputDecoration(
                      labelText: 'Judul',
                      hintText: 'Masukkan judul transaksi',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Judul wajib diisi';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: _amountController,
                    decoration: InputDecoration(
                      labelText: 'Nominal',
                      prefixText: 'Rp ',
                      hintText: 'Masukkan nominal transaksi',
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Nominal wajib diisi';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: _descriptionController,
                    decoration: InputDecoration(
                      labelText: 'Keterangan',
                      hintText: 'Masukkan keterangan',
                    ),
                  ),
                  SizedBox(height: 20),
                  GestureDetector(
                    onTap: () async {
                      DateTime? pickedDate = await showCustomDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2101),
                      );
                      if (pickedDate != null && pickedDate != _selectedDate)
                        setState(() {
                          _selectedDate = pickedDate;
                        });
                    },
                    child: AbsorbPointer(
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Tanggal',
                          hintText: 'Pilih tanggal',
                          suffixIcon: Icon(Icons.calendar_today),
                        ),
                        controller: TextEditingController(
                          text: _selectedDate == null
                              ? ''
                              : '${_selectedDate!.year}/${_selectedDate!.month}/${_selectedDate!.day}',
                        ),
                        validator: (value) {
                          if (_selectedDate == null) {
                            return 'Tanggal wajib diisi';
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: 90),
                  CustomButton(
                      buttonText: 'SIMPAN',
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          bool success = await _controller.addTransaction(
                            isIncome,
                            _titleController.text,
                            _amountController.text,
                            _descriptionController.text,
                            _selectedDate!,
                          );
                          if (success) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Transaksi disimpan')),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Gagal menyimpan transaksi')),
                            );
                          }
                        }
                      }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
