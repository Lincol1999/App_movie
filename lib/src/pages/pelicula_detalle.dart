import 'package:app_peliculas/src/models/actores_model.dart';
import 'package:app_peliculas/src/models/pelicula_model.dart';
import 'package:app_peliculas/src/providers/peliculas_provider.dart';
import 'package:flutter/material.dart';

class PeliculaDetalle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Pelicula pelicula = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      backgroundColor: Color(0xff1C1C1C),
      body: CustomScrollView(
        slivers: [
          _crearAppBar(pelicula),
          SliverList(
            delegate: SliverChildListDelegate([
              SizedBox(
                height: 5.0,
              ),
              _posterTitulo(pelicula),
              _descripcion(pelicula),
              SizedBox(
                height: 5.0,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Text(
                  'Actores',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              _crearCasting(pelicula),
            ]),
          )
        ],
      ),
    );
  }
}

Widget _crearAppBar(Pelicula pelicula) {
  return SliverAppBar(
    elevation: 2.0,
    backgroundColor: Color(0xff000000),
    expandedHeight: 200.0,
    floating: false,
    pinned: true, //Se mantenga visible cuando se haga el scroll
    flexibleSpace: FlexibleSpaceBar(
      centerTitle: false,
      title: Text(
        pelicula.title,
        style: TextStyle(color: Colors.white, fontSize: 16),
      ),
      background: FadeInImage(
        image: NetworkImage(pelicula.getBackgroundImg()),
        placeholder: AssetImage('assets/img/loading.gif'),
        fadeInDuration: Duration(milliseconds: 1),
        fit: BoxFit.cover,
      ),
    ),
  );
}

Widget _posterTitulo(Pelicula pelicula) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
    child: Row(
      children: [
        Hero(
          tag: pelicula.uniqueId,
          child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            child: Image(
              fit: BoxFit.cover,
              image: NetworkImage(pelicula.getPosterImg()),
              height: 150,
            ),
          ),
        ),
        SizedBox(
          width: 20,
        ),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                pelicula.title,
                style: TextStyle(color: Colors.white, fontSize: 18),
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(
                height: 8.0,
              ),
              Text(pelicula.originalTitle,
                  style: TextStyle(color: Colors.white60, fontSize: 15)),
              SizedBox(
                height: 8.0,
              ),
              Row(
                children: [
                  Icon(Icons.star_border, color: Colors.white60),
                  SizedBox(
                    width: 5.0,
                  ),
                  Text(
                    pelicula.popularity.toString(),
                    style: TextStyle(color: Colors.white60),
                  )
                ],
              ),
            ],
          ),
        )
      ],
    ),
  );
}

Widget _descripcion(Pelicula pelicula) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
    child: Text(
      pelicula.overview,
      textAlign: TextAlign.justify,
      style: TextStyle(color: Colors.white),
    ),
  );
}

Widget _crearCasting(Pelicula pelicula) {
  final peliProvder = new PeliculasProvider();
  return FutureBuilder(
    future: peliProvder.getCast(pelicula.id.toString()),
    builder: (context, AsyncSnapshot<List> snapshot) {
      if (snapshot.hasData) {
        return _crearActiresPageView(snapshot.data);
      } else {
        return Center(
          child: CircularProgressIndicator(),
        );
      }
    },
  );
}

Widget _crearActiresPageView(List<Actor> actores) {
  return SizedBox(
    height: 200,
    child: PageView.builder(
      controller: PageController(initialPage: 1, viewportFraction: 0.3),
      itemCount: actores.length,
      itemBuilder: (context, i) {
        return _actorTarjeta(actores[i]);
      },
    ),
  );
}

Widget _actorTarjeta(Actor actor) {
  return Container(
    child: Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: FadeInImage(
            image: NetworkImage(actor.getActorImg()),
            placeholder: AssetImage('assets/img/no-image.jpg'),
            height: 150,
            fit: BoxFit.cover,
          ),
        ),
        Text(
          actor.name,
          style: TextStyle(color: Colors.white),
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
        ),
      ],
    ),
  );
}
