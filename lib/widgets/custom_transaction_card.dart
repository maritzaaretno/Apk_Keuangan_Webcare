import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../theme/colors.dart';
import '../theme/text_theme.dart';

class TransactionCard extends StatelessWidget {
  final int id; // ID transaksi
  final String title;
  final String date;
  final String amount;
  final Color color;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const TransactionCard({
    Key? key,
    required this.id,
    required this.title,
    required this.date,
    required this.amount,
    required this.color,
    this.onEdit,
    this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('TransactionCard ID: $id'); // Log ID di dalam TransactionCard

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
      child: Slidable(
        key: ValueKey<int>(id),
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              onPressed: (context) {
                if (onEdit != null) {
                  onEdit!(); // Panggil fungsi onEdit jika tidak null
                }
              },
              backgroundColor: secondaryColor,
              foregroundColor: Colors.white,
              icon: Icons.edit,
              label: 'Edit',
            ),
            SlidableAction(
              onPressed: (context) {
                if (onDelete != null) {
                  onDelete!(); // Panggil fungsi onDelete jika tidak null
                }
              },
              backgroundColor: red3,
              foregroundColor: Colors.white,
              icon: Icons.delete,
              label: 'Hapus',
            ),
          ],
        ),
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 1,
                blurRadius: 5,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ListTile(
            leading: Icon(Icons.compare_arrows_rounded, color: color, size: 40),
            title: Text(title, style: nameTransText),
            subtitle: Text(date),
            trailing: Text(
              amount,
              style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 14),
            ),
          ),
        ),
      ),
    );
  }
}
