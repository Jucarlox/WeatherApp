class LocationModel {
  LocationModel({required this.city, required this.lat, required this.lng});
  String city;
  double lat;
  double lng;
}

final coord = [
  LocationModel(city: 'Sevilla', lat: 37.3754865, lng: -6.0250989),
  LocationModel(city: 'Málaga', lat: 36.7183391, lng: -4.5193076),
  LocationModel(city: 'Dubai', lat: 25.0763815, lng: 54.9475438),
  LocationModel(city: 'Mónaco', lat: 43.7378811, lng: 7.4083428),
  LocationModel(city: 'Murcia', lat: 37.9805949, lng: -1.1621949),
  LocationModel(city: 'Galicia', lat: 42.7964753, lng: -9.1389935),
  LocationModel(city: 'Andorra', lat: 42.5424508, lng: 1.4576068),
  LocationModel(city: 'London', lat: 51.5287352, lng: -0.3817858),
];
