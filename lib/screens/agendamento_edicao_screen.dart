import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:presence_air_app/models/agendamento.dart';
import 'package:presence_air_app/services/agendamentos_service.dart';

class AgendamentoEdicaoScreen extends StatefulWidget {
  final Agendamento agendamento;

  const AgendamentoEdicaoScreen({super.key, required this.agendamento});

  @override
  State<AgendamentoEdicaoScreen> createState() =>
      _AgendamentoEdicaoScreenState();
}

class _AgendamentoEdicaoScreenState extends State<AgendamentoEdicaoScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _atividadeController;
  late TextEditingController _areaController;
  late TextEditingController _salaController;
  late TextEditingController _inicioController;
  late TextEditingController _fimController;
  late TextEditingController _duracaoController;
  late TextEditingController _descricaoController;
  late TextEditingController _tipoController;
  late TextEditingController _reservadoPorController;
  bool _statusArCondicionado = false;

  final AgendamentosService service = AgendamentosService();
  var logger = Logger();

  @override
  void initState() {
    super.initState();
    // Inicializando os controladores com os valores do agendamento
    _atividadeController =
        TextEditingController(text: widget.agendamento.usuarioAtividade);
    _areaController = TextEditingController(text: widget.agendamento.area);
    _salaController = TextEditingController(text: widget.agendamento.sala);
    _inicioController = TextEditingController(text: widget.agendamento.inicio);
    _fimController = TextEditingController(text: widget.agendamento.fim);
    _duracaoController = TextEditingController(
        text: widget.agendamento.duracao?.toString() ?? '');
    _descricaoController =
        TextEditingController(text: widget.agendamento.descricao);
    _tipoController = TextEditingController(text: widget.agendamento.tipo);
    _reservadoPorController =
        TextEditingController(text: widget.agendamento.reservadoPor);
    _statusArCondicionado = widget.agendamento.statusArcondicionado ?? false;
  }

  @override
  void dispose() {
    // Limpando os controladores
    _atividadeController.dispose();
    _areaController.dispose();
    _salaController.dispose();
    _inicioController.dispose();
    _fimController.dispose();
    _duracaoController.dispose();
    _descricaoController.dispose();
    _tipoController.dispose();
    _reservadoPorController.dispose();
    super.dispose();
  }

  void _salvarEdicao() async {
    if (_formKey.currentState!.validate()) {
      widget.agendamento.usuarioAtividade = _atividadeController.text;
      widget.agendamento.area = _areaController.text;
      widget.agendamento.sala = _salaController.text;
      widget.agendamento.inicio = _inicioController.text;
      widget.agendamento.fim = _fimController.text;
      widget.agendamento.duracao = double.tryParse(_duracaoController.text);
      widget.agendamento.descricao = _descricaoController.text;
      widget.agendamento.tipo = _tipoController.text;
      widget.agendamento.reservadoPor = _reservadoPorController.text;
      widget.agendamento.statusArcondicionado = _statusArCondicionado;

      try {
        bool response = await service.editarAgendamento(
            widget.agendamento.id!, widget.agendamento);

        if (response) {
          Navigator.pop(
            context,
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Não foi possivel salvar Agendamento!')),
          );
        }
      } catch (e) {
        logger.e(e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Agendamento',
            style: TextStyle(color: Colors.white)),
        backgroundColor: const Color.fromRGBO(114, 187, 57, 1),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _atividadeController,
                decoration: const InputDecoration(labelText: 'Atividade'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Campo obrigatório' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _areaController,
                decoration: const InputDecoration(labelText: 'Área'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Campo obrigatório' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _salaController,
                decoration: const InputDecoration(labelText: 'Sala'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Campo obrigatório' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _inicioController,
                decoration: const InputDecoration(labelText: 'Início'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Campo obrigatório' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _fimController,
                decoration: const InputDecoration(labelText: 'Fim'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Campo obrigatório' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _duracaoController,
                decoration: const InputDecoration(labelText: 'Duração (horas)'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty)
                    return 'Campo obrigatório';
                  if (double.tryParse(value) == null)
                    return 'Digite um número válido';
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _descricaoController,
                decoration: const InputDecoration(labelText: 'Descrição'),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _tipoController,
                decoration: const InputDecoration(labelText: 'Tipo'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Campo obrigatório' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _reservadoPorController,
                decoration: const InputDecoration(labelText: 'Reservado por'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Campo obrigatório' : null,
              ),
              const SizedBox(height: 12),
              SwitchListTile(
                title: const Text('Status Ar Condicionado'),
                value: _statusArCondicionado,
                onChanged: (bool value) {
                  setState(() {
                    _statusArCondicionado = value;
                  });
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _salvarEdicao,
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Salvar', style: TextStyle(fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
