import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:typed_data';
import 'package:logger/logger.dart';
import 'package:presence_air_app/services/agendamentos_service.dart';

class ImportacaoAgendamentoScreen extends StatefulWidget {
  const ImportacaoAgendamentoScreen({super.key});

  @override
  State<ImportacaoAgendamentoScreen> createState() =>
      _ImportacaoAgendamentoScreenState();
}

class _ImportacaoAgendamentoScreenState
    extends State<ImportacaoAgendamentoScreen> {
  PlatformFile? _selectedFile; // Variável para armazenar o arquivo selecionado
  bool _isUploading = false; // Flag para mostrar progresso do upload
  var logger = Logger();
  final service = AgendamentosService();

  // Método para escolher o arquivo CSV
  Future<void> pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['csv'],
      );

      if (result != null && result.files.single.bytes != null) {
        setState(() {
          _selectedFile = result.files.single;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Nenhum arquivo selecionado. Tente novamente.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Erro ao selecionar arquivo. Tente novamente.')),
      );
      logger.e(e);
    }
  }

  // Método para enviar o arquivo CSV para o servidor
  Future<void> uploadFile() async {
    if (_selectedFile == null || _selectedFile!.bytes == null) return;

    setState(() {
      _isUploading = true;
    });

    try {
      // Chamando o serviço para enviar o arquivo CSV
      bool sucesso = await service.enviarArquivoCSV(
        arquivoCSVBytes: _selectedFile!.bytes!,
        nomeArquivo: _selectedFile!.name,
      );

      // Verificando o resultado do envio
      if (sucesso) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Arquivo enviado com sucesso!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Falha ao enviar o arquivo.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro: $e')),
      );
      logger.e(e);
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Importar Agendamento CSV'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: pickFile,
              child: const Text("Escolher arquivo"),
            ),
            const SizedBox(height: 20),
            if (_selectedFile != null) ...[
              Text('Arquivo selecionado: ${_selectedFile!.name}'),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _isUploading ? null : uploadFile,
                child: _isUploading
                    ? const CircularProgressIndicator()
                    : const Text("Enviar arquivo"),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
