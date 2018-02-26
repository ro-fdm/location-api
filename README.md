# README

## Aplicación
Levanto una API rails 5 con un modelo Location con los campos espeficados (Name, Phone, Address, Postcode, City, Country, Latitude and Longitude)

Hago necesarios el name (para tener un identificador rapido y facil de comunicar), address, postcode, city y country, pq con ellos construiria la dirección para realizar el proceso de geocodign con la api de google maps

Tras buscar decido usar para latitude y longitude:
```decimal, precision: 10, scale: 6```
ya que https://developers.google.com/maps/documentation/javascript/mysql-to-maps#createtable
>"To keep the storage space for your table at a minimum, you can specify the lat and lng attributes to be floats of size (10,6). This allows the fields to store 6 digits after the decimal, plus up to 4 digits before the decimal."

En el controlador ahora mismo se esta recomendando usar test de request en lugar de controlador:
http://rspec.info/blog/2016/07/rspec-3-5-has-been-released/
>"For new Rails apps: we don't recommend adding the rails-controller-testing gem to your application. The official recommendation of the Rails team and the RSpec core team is to write request specs instead."

Añado un servicio: GeocodingService.
Hago primero un test sencillo qeu comprueba que añado la longitud y la latitud.
Añado la lógica en el servicio para llamar a la api de google maps.
Compruebo el test y recuerdo que tengo que 
 stubear la request de la llamada en el test (se trata de testear mi servicio no la api de google :))

 Decido añadir en el modelo la formatted address de la longitud y latitud de la llamada, para poder comprobar facilmente si estoy guardando lo qeu quiero y facilitar no repetir futuras llamadas.
 Tambien veo que lleva 7 decimales y no seis como esperaba, asi que corrijo la migracion, y rollbackeo y remigro.

Creo algunas direcciones con ñ, me da error la url, asi que la parseo con URI.escape.

Elimino el postcode como campo obligatorio ( soy la priemra que no se lo suele saber cuadno escribo direcciones en google maps)

Decido usar el  secrets de rails 5 para manejar la API_KEY que estoy usando para llamar a la api de google maps. 
https://www.engineyard.com/blog/encrypted-rails-secrets-on-rails-5.1
Como esto es un ejercicio si commiteo el secrets.yml

Añado en el servicio el control de errores, a partir de la info que nos da la api de google.
Para guardar que ha pasado añado un campo error en location.

En el servicio que llama a google se puede filtrar el resultado por:
- location_type priorizando ROOFTOP
- types priorizando street_address sobre menos concretos.
Por ahora cogemos el primero.

 TODO:
 - llamar a un delayed job para geocoding en el controlador
 - añadir geocodificacion inversa y ver que nos devuelve ( puede ser intereseante)
 - añadir comprobar si la direccion existe para no repetir llamadas
 - añadir delete y update en el controlador
