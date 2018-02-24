# README

Levanto una aplicacion api rails 5 con un modelo Location con los campos espeficados (Name, Phone, Address, Postcode, City, Country, Latitude and Longitude)
Hago necesarios el name (para tener un identificador rapido y facil de comunicar), address, postcode, city y country, pq con ellos construiria la dirección para realizar el proceso de geocodign con la api de google maps
Tras buscar decido usar para latitude y longitude:
```decimal, precision: 10, scale: 6```
ya que https://developers.google.com/maps/documentation/javascript/mysql-to-maps#createtable
"To keep the storage space for your table at a minimum, you can specify the lat and lng attributes to be floats of size (10,6). This allows the fields to store 6 digits after the decimal, plus up to 4 digits before the decimal."
En el controlador ahora mismo se esta recomendando usar test de request en lugar de controlador:
http://rspec.info/blog/2016/07/rspec-3-5-has-been-released/
"For new Rails apps: we don't recommend adding the rails-controller-testing gem to your application. The official recommendation of the Rails team and the RSpec core team is to write request specs instead. Request specs allow you to focus on a single controller action, but unlike controller tests involve the router, the middleware stack, and both rack requests and responses. This adds realism to the test that you are writing, and helps avoid many of the issues that are common in controller specs. In Rails 5, request specs are significantly faster than either request or controller specs were in rails 4, thanks to the work by Eileen Uchitelle1 of the Rails Committer Team."