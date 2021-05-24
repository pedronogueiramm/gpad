import 'package:flutter/material.dart';
import 'package:share/share.dart';

void main() => runApp(GpadApp());

class GpadApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: ListaNotas(),
      ),
    );
  }
}


// tela de criação de nota
class CriarNota extends StatelessWidget {
  final TextEditingController _controladorTitulo = TextEditingController();
  final TextEditingController _controladorNota = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Adicionar Nota'),
        ),
        body: Column(
          children: <Widget>[
            Campo('Título', 'inserir título', _controladorTitulo),
            Campo('Nota', 'inserir nota', _controladorNota),
            ElevatedButton(
              child: Text('Adcionar'),
              onPressed: () {
                final String titulo = _controladorTitulo.text;
                final String nota = _controladorNota.text;
                // verificação dos campos de titulo e nota para envio das informações para a tela inicial
                if (titulo != "" && nota != "") {
                  final conteudoCriado = Conteudo(titulo, nota);
                  // rota para tela inicial
                  Navigator.pop(context, conteudoCriado);
                }
              },
            )
          ],
        ));
  }
}

// tela inicial
class ListaNotas extends StatefulWidget {
  final List<Conteudo> _conteudos = [];

  @override
  State<StatefulWidget> createState() {
    return ListaNotasState();
  }
}

// state da tela inicial
class ListaNotasState extends State<ListaNotas> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('G-PAD'),
      ),
      body: ListView.builder(
        itemCount: widget._conteudos.length,
        itemBuilder: (context, index) {
          final conteudo = widget._conteudos[index];
          return Nota(conteudo);
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          final Future<Conteudo> future =
              Navigator.push(context, MaterialPageRoute(builder: (context) {
            return CriarNota();
          }));
          future.then((conteudoRecebido) {
            Future.delayed(Duration(seconds: 1), () {
              if (conteudoRecebido != null) {
                setState(() {
                  widget._conteudos.add(conteudoRecebido);
                });
              }
            });
          });
        },
      ),
    );
  }
}

// modelo das notas
class Nota extends StatelessWidget {
  final Conteudo _conteudo;

  Nota(this._conteudo);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(Icons.notes),
        title: Text(_conteudo.titulo.toString(), style: TextStyle(fontSize: 20),),
        subtitle: Text(_conteudo.nota.toString(), style: TextStyle(fontSize: 20)),
        onTap: () => share(context, _conteudo),
      ),
    );
  }
}


// modelo dos conteudos das notas
class Conteudo {
  final String titulo;
  final String nota;

  Conteudo(this.titulo, this.nota);

  @override
  String toString() {
    return 'Conteudo{titulo: $titulo, nota: $nota}';
  }
}

// modelo do campo de adição de uma nova nota
class Campo extends StatelessWidget {
  final TextEditingController _controlador;
  final String _rotulo;
  final String _dica;

  Campo(this._rotulo, this._dica, this._controlador);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        controller: _controlador,
        style: TextStyle(fontSize: 24),
        decoration: InputDecoration(labelText: _rotulo, hintText: _dica),
      ),
    );
  }
}


// plugin para compartilhar as notas
void share(BuildContext context, Conteudo conteudo) {
  final RenderBox box = context.findRenderObject();

  Share.share("${conteudo.titulo} - ${conteudo.nota}",
      subject: conteudo.nota,
      sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
}
