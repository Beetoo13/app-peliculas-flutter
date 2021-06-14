import 'package:flutter/material.dart';

import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:peliculas/src/models/pelicula_model.dart';

class CardSwiper extends StatelessWidget {
  final List<Pelicula> peliculas;

  // El required obliga que lo manden o no funciona
  CardSwiper({@required this.peliculas});

  @override
  Widget build(BuildContext context) {
    final _screenSize = MediaQuery.of(context).size;

    return Container(
      child: new Swiper(
        layout: SwiperLayout.STACK,
        itemWidth: _screenSize.width * 0.7,
        itemHeight: _screenSize.height * 0.5,
        itemBuilder: (BuildContext context, int index) {
          //Generar un id diferente porque si no, el hero animation
          //detecta el mismo id en ambas tarjetas.
          peliculas[index].uniqueId = '${peliculas[index].id}-tarjeta';

          return Hero(
            tag: peliculas[index].uniqueId,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, 'detalle',
                      arguments: peliculas[index]);
                },
                child: FadeInImage(
                  placeholder: AssetImage('assets/img/no-image.jpg'),
                  image: NetworkImage(
                    peliculas[index].getPosterImg(),
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          );
        },
        itemCount: peliculas.length,
      ),
    );
  }
}
