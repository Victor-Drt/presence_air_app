import 'package:flutter/material.dart';
import 'package:presence_air_app/models/agendamento.dart';
import 'package:presence_air_app/services/agendamentos_service.dart';

class AgendamentoCadastrarScreen extends StatefulWidget {
  const AgendamentoCadastrarScreen({super.key});

  @override
  State<AgendamentoCadastrarScreen> createState() =>
      _AgendamentoCadastrarScreenState();
}

class _AgendamentoCadastrarScreenState
    extends State<AgendamentoCadastrarScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controladores para os campos de texto
  final TextEditingController _atividadeController = TextEditingController();
  final TextEditingController _areaController = TextEditingController();
  final TextEditingController _salaController = TextEditingController();
  final TextEditingController _inicioController = TextEditingController();
  final TextEditingController _fimController = TextEditingController();
  final TextEditingController _descricaoController = TextEditingController();
  final TextEditingController _tipoController = TextEditingController();
  final TextEditingController _reservadoPorController = TextEditingController();
  final TextEditingController _duracaoController = TextEditingController();

  bool _statusArCondicionado = false;

  final service = AgendamentosService();

  @override
  void dispose() {
    // Limpa os controladores quando o widget for destruído
    _atividadeController.dispose();
    _areaController.dispose();
    _salaController.dispose();
    _inicioController.dispose();
    _fimController.dispose();
    _descricaoController.dispose();
    _tipoController.dispose();
    _reservadoPorController.dispose();
    _duracaoController.dispose();
    super.dispose();
  }

  // Função para cadastrar o agendamento
  Future<void> _cadastrarAgendamento() async {
    if (_formKey.currentState!.validate()) {
      Agendamento novoAgendamento = Agendamento(
          usuarioAtividade: _atividadeController.text,
          area: _areaController.text,
          sala: _salaController.text,
          inicio: _inicioController.text,
          fim: _fimController.text,
          duracao: double.parse(_duracaoController.text),
          descricao: _descricaoController.text,
          tipo: _tipoController.text,
          reservadoPor: _reservadoPorController.text,
          statusArcondicionado: _statusArCondicionado);

      try {
        final response = await service.cadastrarAgendamento(novoAgendamento);

        if (response) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Agendamento cadastrado com sucesso!')),
          );
          Navigator.pop(context);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Não foi possivel salvar Agendamento!')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Não foi possivel salvar Agendamento!')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Cadastrar Agendamento',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromRGBO(114, 187, 57, 1),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Campo de Atividade
              TextFormField(
                controller: _atividadeController,
                decoration: const InputDecoration(
                  labelText: 'Atividade',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira a atividade';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),

              // Campo de Área
              TextFormField(
                controller: _areaController,
                decoration: const InputDecoration(
                  labelText: 'Área',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira a área';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),

              // Campo de Sala
              TextFormField(
                controller: _salaController,
                decoration: const InputDecoration(
                  labelText: 'Sala',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira a sala';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),

              // Campo de Data Início
              TextFormField(
                controller: _inicioController,
                decoration: const InputDecoration(
                  labelText: 'Data de Início',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira a data de início';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),

              // Campo de Data Fim
              TextFormField(
                controller: _fimController,
                decoration: const InputDecoration(
                  labelText: 'Data de Fim',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira a data de fim';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),

              // Campo de Duração
              TextFormField(
                controller: _duracaoController,
                decoration: const InputDecoration(
                  labelText: 'Duração (horas)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),

              // Campo de Descrição
              TextFormField(
                controller: _descricaoController,
                decoration: const InputDecoration(
                  labelText: 'Descrição',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 12),

              // Campo de Tipo
              TextFormField(
                controller: _tipoController,
                decoration: const InputDecoration(
                  labelText: 'Tipo',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o tipo do agendamento';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),

              // Campo de Reservado Por
              TextFormField(
                controller: _reservadoPorController,
                decoration: const InputDecoration(
                  labelText: 'Reservado Por',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira quem reservou';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),

              // Switch para Status do Ar Condicionado
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Ar Condicionado Ligado',
                    style: TextStyle(fontSize: 16),
                  ),
                  Switch(
                    value: _statusArCondicionado,
                    onChanged: (value) {
                      setState(() {
                        _statusArCondicionado = value;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Botão de Cadastrar
              ElevatedButton(
                onPressed: _cadastrarAgendamento,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Cadastrar',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}