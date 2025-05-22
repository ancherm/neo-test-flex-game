import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddShopScreen extends StatefulWidget {
  /// Если передан [doc], то мы в режиме редактирования
  final DocumentSnapshot<Map<String, dynamic>>? doc;
  const AddShopScreen({Key? key, this.doc}) : super(key: key);

  @override
  _AddShopScreenState createState() => _AddShopScreenState();
}

class _AddShopScreenState extends State<AddShopScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameCtrl;
  late final TextEditingController _costCtrl;
  late final TextEditingController _typeCtrl;
  late final TextEditingController _descCtrl;
  late final TextEditingController _imageUrlCtrl;
  String? _error;

  bool get _isEditing => widget.doc != null;

  @override
  void initState() {
    super.initState();
    _nameCtrl     = TextEditingController();
    _costCtrl     = TextEditingController();
    _typeCtrl     = TextEditingController();
    _descCtrl     = TextEditingController();
    _imageUrlCtrl = TextEditingController();

    if (_isEditing) {
      final data = widget.doc!.data()!;
      _nameCtrl.text     = data['name'] as String;
      _costCtrl.text     = (data['cost'] as num).toString();
      _typeCtrl.text     = data['type'] as String;
      _descCtrl.text     = data['description'] as String;
      _imageUrlCtrl.text = data['imageUrl'] as String;
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _costCtrl.dispose();
    _typeCtrl.dispose();
    _descCtrl.dispose();
    _imageUrlCtrl.dispose();
    super.dispose();
  }

  Future<void> _saveShop() async {
    if (!_formKey.currentState!.validate()) return;

    final name     = _nameCtrl.text.trim();
    final cost     = int.tryParse(_costCtrl.text.trim());
    final type     = _typeCtrl.text.trim();
    final desc     = _descCtrl.text.trim();
    final imageUrl = _imageUrlCtrl.text.trim();

    if (cost == null) {
      setState(() => _error = 'Поле «Стоимость» должно быть числом');
      return;
    }

    final data = {
      'name': name,
      'cost': cost,
      'type': type,
      'description': desc,
      'imageUrl': imageUrl,
    };

    try {
      final coll = FirebaseFirestore.instance.collection('shops');
      if (_isEditing) {
        await coll.doc(widget.doc!.id).update(data);
      } else {
        await coll.add(data);
      }
      Navigator.pop(context);
    } catch (e) {
      setState(() => _error = 'Ошибка сохранения: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Редактировать товар' : 'Добавить товар'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Название
              TextFormField(
                controller: _nameCtrl,
                decoration: const InputDecoration(labelText: 'Название'),
                validator: (v) => v!.isEmpty ? 'Введите название' : null,
              ),

              const SizedBox(height: 16),
              // Стоимость
              TextFormField(
                controller: _costCtrl,
                decoration: const InputDecoration(labelText: 'Стоимость'),
                keyboardType: TextInputType.number,
                validator: (v) => v!.isEmpty ? 'Введите стоимость' : null,
              ),

              const SizedBox(height: 16),
              // Тип
              TextFormField(
                controller: _typeCtrl,
                decoration: const InputDecoration(labelText: 'Тип'),
                validator: (v) => v!.isEmpty ? 'Введите тип товара' : null,
              ),

              const SizedBox(height: 16),
              // Описание
              TextFormField(
                controller: _descCtrl,
                decoration: const InputDecoration(labelText: 'Описание'),
                maxLines: 3,
                validator: (v) => v!.isEmpty ? 'Введите описание' : null,
              ),

              const SizedBox(height: 16),
              // URL изображения
              TextFormField(
                controller: _imageUrlCtrl,
                decoration: const InputDecoration(labelText: 'URL изображения'),
                validator: (v) => v!.isEmpty ? 'Введите URL изображения' : null,
              ),

              if (_error != null) ...[
                const SizedBox(height: 16),
                Text(_error!, style: const TextStyle(color: Colors.red)),
              ],

              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _saveShop,
                child: Text(_isEditing ? 'Сохранить' : 'Добавить'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}