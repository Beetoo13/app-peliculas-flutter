import 'package:flutter/material.dart';

import 'package:peliculas/src/models/pelicula_model.dart';
import 'package:peliculas/src/providers/peliculas_provider.dart';

class DataSearch extends SearchDelegate {
  String seleccion = '';
  final peliculasProvider = new PeliculasProvider();

  // Jalas el color del theme de la aplicación para que lo use
  // la clase searchDelegate y el search se cambie de color.

  @override
  ThemeData appBarTheme(BuildContext context) {
    return Theme.of(context);
  }

  final peliculas = [
    'Emoji',
    'Emoji2',
    'Emoji3',
    'Emoji4',
    'Emoji5',
    'Bee movie',
    'Shazam!',
    'El espanta tiburones',
    'Aquaman',
    'Wonder Woman',
    'Spiderman',
    'Capitan America',
  ];
  final peliculasRecientes = ['Spiderman', 'Capitan America'];

  @override
  List<Widget> buildActions(BuildContext context) {
    //Las acciones de nuestro AppBar.
    return [
      IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            //El query almacena lo que tiene el search.
            query = '';
          })
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // Icono a la izquierda del appbar.
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // Crea los resultados que vamos a mostrar.
    return Center(
      child: Container(
        height: 100.0,
        width: 100.0,
        color: Colors.blueAccent,
        child: Text(seleccion),
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    //Son las sugerencias que aparecen cuando la persona escribe.

    if (query.isEmpty) {
      return Container();
    }

    return FutureBuilder(
      future: peliculasProvider.buscarPelicula(query),
      builder: (BuildContext context, AsyncSnapshot<List<Pelicula>> snapshot) {
        if (snapshot.hasData) {
          final peliculas = snapshot.data;

          return ListView(
            // Nota, cuando iteras sobre una lista, no son necesarios los corchetes en el "children"
            // ya que lo defines como .toList() al final de la función map().
            children: peliculas.map((pelicula) {
              return ListTile(
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(5.0),
                  child: FadeInImage(
                    image: NetworkImage(
                      pelicula.getPosterImg(),
                    ),
                    placeholder: AssetImage('assets/img/no-image.jpg'),
                    fit: BoxFit.contain,
                  ),
                ),
                title: Text(pelicula.title),
                subtitle: Text(pelicula.originalTitle),
                onTap: () {
                  close(context, null);
                  pelicula.uniqueId = '';
                  Navigator.pushNamed(context, 'detalle', arguments: pelicula);
                },
              );
            }).toList(),
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
