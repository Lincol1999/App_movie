import 'package:app_peliculas/src/models/pelicula_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

class CardSwiper extends StatelessWidget {
  final List<Pelicula> peliculas;

  CardSwiper({@required this.peliculas});

  @override
  Widget build(BuildContext context) {
    //MediaQuery.of(contex).size -> Obtiene info sobre el ancho/alto del dispositivo
    final _screenSize = MediaQuery.of(context).size;

    return Container(
      //padding, es el espacio, solo en la parte de arriba de 20 px
      padding: EdgeInsets.only(top: 20.0),
      child: Swiper(
        layout: SwiperLayout.STACK,
        //El 0.7 = 70% del ancho de la pantalla
        itemWidth: _screenSize.width * 0.7,
        itemHeight: _screenSize.height * 0.5,
        itemBuilder: (BuildContext context, int index) {
          peliculas[index].uniqueId = '${peliculas[index].id}-tarjeta';

          //ClipRRect sirve para realizar los border redondeados
          final hero = Hero(
            tag: peliculas[index].uniqueId,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: FadeInImage(
                image: NetworkImage(peliculas[index].getPosterImg()),
                placeholder: AssetImage('assets/img/no-image.jpg'),
                //Fit -> hace que las img se adapte a la dimension que tiene.
                fit: BoxFit.cover,
              ),
            ),
          );
          return GestureDetector(
            child: hero,
            onTap: () {
              Navigator.pushNamed(context, 'detalle',
                  arguments: peliculas[index]);
            },
          );
        },
        itemCount: peliculas.length,
        // pagination: new SwiperPagination(), //Los 3 puntitos del Swiper
        // control: new SwiperControl(), //La barra de los lados del Swiper
      ),
    );
  }
}
