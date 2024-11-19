class Agendamento {
  int? id;
  String? usuarioAtividade;
  String? area;
  String? sala;
  String? inicio;
  String? fim;
  double? duracao;
  String? descricao;
  String? tipo;
  String? reservadoPor;
  String? ultimaAtualizacao;
  bool? statusArcondicionado;

  Agendamento(
      {this.id,
      this.usuarioAtividade,
      this.area,
      this.sala,
      this.inicio,
      this.fim,
      this.duracao,
      this.descricao,
      this.tipo,
      this.reservadoPor,
      this.ultimaAtualizacao,
      this.statusArcondicionado});

  Agendamento.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    usuarioAtividade = json['usuarioAtividade'];
    area = json['area'];
    sala = json['sala'];
    inicio = json['inicio'];
    fim = json['fim'];
    duracao = _toDouble(json['duracao']);
    descricao = json['descricao'];
    tipo = json['tipo'];
    reservadoPor = json['reservadoPor'];
    ultimaAtualizacao = json['ultimaAtualizacao'];
    statusArcondicionado = json['statusArcondicionado'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['usuarioAtividade'] = this.usuarioAtividade;
    data['area'] = this.area;
    data['sala'] = this.sala;
    data['inicio'] = this.inicio;
    data['fim'] = this.fim;
    data['duracao'] = this.duracao;
    data['descricao'] = this.descricao;
    data['tipo'] = this.tipo;
    data['reservadoPor'] = this.reservadoPor;
    data['ultimaAtualizacao'] = this.ultimaAtualizacao;
    data['statusArcondicionado'] = this.statusArcondicionado;
    return data;
  }

  double? _toDouble(dynamic value) {
    if (value == null) {
      return 0.0; // Retorna null se o valor for null
    } else if (value is double) {
      return value; // Já é um double
    } else if (value is int) {
      return value.toDouble(); // Converte de int para double
    } else if (value is String) {
      return double.tryParse(value) ??
          0.0; // Converte de String para double, se possível
    }
    return 0.0; // Retorna null se não puder converter
  }
}
