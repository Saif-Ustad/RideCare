import 'package:flutter/material.dart';

class AddMoneyWalletPage extends StatefulWidget {
  const AddMoneyWalletPage({super.key});

  @override
  State<AddMoneyWalletPage> createState() => _AddMoneyWalletPageState();
}

class _AddMoneyWalletPageState extends State<AddMoneyWalletPage> {
  final TextEditingController _amountController = TextEditingController();

  final List<String> _presetAmounts = [
    "100",
    "200",
    "500",
    "1000",
    "2000",
    "3000",
    "4000",
    "5000",
  ];

  void _appendAmount(String amount) {
    final current = double.tryParse(_amountController.text) ?? 0;
    final newAmount = current + double.parse(amount);
    setState(() {
      _amountController.text = newAmount.toStringAsFixed(2);
    });
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Add Money",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildWalletCard(),
            const SizedBox(height: 20),
            _buildAmountButtons(),
            const SizedBox(height: 16),
            _buildTextField(),
            const SizedBox(height: 20),
            _buildAddMoneyButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildWalletCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFEDEAFF),
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Wallet Balance",
                style: TextStyle(color: Colors.black54, fontSize: 14),
              ),
              SizedBox(height: 8),
              Text(
                "\$ 12000.00",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          Icon(Icons.account_balance_wallet_outlined, color: Colors.deepPurple),
        ],
      ),
    );
  }

  Widget _buildAmountButtons() {
    return GridView.count(
      crossAxisCount: 4,
      shrinkWrap: true,
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      physics: const NeverScrollableScrollPhysics(),
      children:
          _presetAmounts.map((amount) {
            return GestureDetector(
              onTap: () => _appendAmount(amount),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: const Color(0xFFF3F3F3),
                ),
                alignment: Alignment.center,
                child: Text(
                  "+\$$amount",
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            );
          }).toList(),
    );
  }

  Widget _buildTextField() {
    return TextField(
      controller: _amountController,
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(
        prefixText: "\$ ",
        hintText: "Enter Amount",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        filled: true,
        fillColor: const Color(0xFFF5F5F5),
      ),
    );
  }

  Widget _buildAddMoneyButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: () {
          // Add money logic
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Added \$${_amountController.text} to wallet!"),
              duration: const Duration(seconds: 2),
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.deepPurple,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: const Text(
          "Add Money",
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
    );
  }
}
