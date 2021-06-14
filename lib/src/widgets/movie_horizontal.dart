import 'package:flutter/material.dart';

import 'package:peliculas/src/models/pelicula_model.dart';

class MovieHorizontal extends StatelessWidget {
  final List<Pelicula> peliculas;
  final Function siguientePagina;

  MovieHorizontal({@required this.peliculas, @required this.siguientePagina});

  final _pageController =
      new PageController(initialPage: 1, viewportFraction: 0.22);

  @override
  Widget build(BuildContext context) {
    //Obtener el 20% de la pantalla.
    final _screenSize = MediaQuery.of(context).size;

    _pageController.addListener(() {
      if (_pageController.position.pixels >=
          _pageController.position.maxScrollExtent - 200) {
        siguientePagina();
      }
    });

    return Container(
      height: _screenSize.height * 0.2,
      child: PageView.builder(
        pageSnapping: false,
        controller: _pageController,
        itemCount: peliculas.length,
        itemBuilder: (context, index) {
          return _tarjeta(context, peliculas[index]);
        },
      ),
    );
  }

  Widget _tarjeta(BuildContext context, Pelicula pelicula) {
    //Generamos diferente id para el hero animation y que no de el error.
    pelicula.uniqueId = '${pelicula.id}-poster';

    final tarjeta = Container(
      margin: EdgeInsets.only(right: 10.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Hero(
              tag: pelicula.uniqueId,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15.0),
                child: FadeInImage(
                  image: NetworkImage(
                    pelicula.getPosterImg(),
                  ),
                  placeholder: AssetImage('assets/img/no-image.jpg'),
                  fit: BoxFit.cover,
                  height: 120.0,
                ),
              ),
            ),
            SizedBox(
              height: 5.0,
            ),
            Text(
              pelicula.title,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.caption,
            ),
          ],
        ),
      ),
    );

    return GestureDetector(
      child: tarjeta,
      onTap: () {
        print('Nombre de la pelicula: ${pelicula.title}');
        Navigator.pushNamed(context, 'detalle', arguments: pelicula);
      },
    );
  }
}
