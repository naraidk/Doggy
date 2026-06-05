# config/initializers/geocoder.rb
Geocoder.configure(
  timeout: 5,
  lookup: :nominatim,
  units: :km,
  http_headers: { "User-Agent" => "DoggyProjet/1.0 (contact@doggyprojet.fr)" }
)
