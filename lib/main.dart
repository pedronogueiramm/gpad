import 'package:flutter/material.dart';

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
                if (titulo != null && nota != null) {
                  final conteudoCriado = Conteudo(titulo, nota);
                  Navigator.pop(context, conteudoCriado);
                }
              },
            )
          ],
        ));
  }
}

class ListaNotas extends StatefulWidget {
  final List<Conteudo> _conteudos = List();

  @override
  State<StatefulWidget> createState() {
    return ListaNotasState();
  }
}

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
              if(conteudoRecebido != null){
                setState((){
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

class Nota extends StatelessWidget {
  final Conteudo _conteudo;

  Nota(this._conteudo);

  @override
  Widget build(BuildContext context) {
    return Card(
        child: ListTile(
      leading: Icon(Icons.notes),
      title: Text(_conteudo.titulo.toString()),
      subtitle: Text(_conteudo.nota.toString()),
    ));
  }
}

class Conteudo {
  final String titulo;
  final String nota;

  Conteudo(this.titulo, this.nota);

  @override
  String toString() {
    return 'Conteudo{titulo: $titulo, nota: $nota}';
  }
}

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
