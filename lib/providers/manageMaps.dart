import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoder/geocoder.dart' as geoCo;
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GenerateMaps extends ChangeNotifier {
  String finalAddress = 'Searching Address...';
  String get getFinalAddress => finalAddress;
  Position position;
  geoCo.Coordinates coordinates;
  Position get getPosition => position;
  GoogleMapController googleMapController;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  String countryName, mainAddress; //'Mock Address';
  String get getCountryName => countryName;
  String get getMainAddress => mainAddress;
  Future getCurrentLocation() async {
    var PositionData = await GeolocatorPlatform.instance.getCurrentPosition();
    final cords =
        geoCo.Coordinates(PositionData.latitude, PositionData.longitude);
    coordinates = cords;
    var address =
        await geoCo.Geocoder.local.findAddressesFromCoordinates(cords);
    String mainAddress = address.first.addressLine;
    print(mainAddress);
    finalAddress = mainAddress;
    notifyListeners();
  }

  getMarker(double lat, double lng) {
    MarkerId markerId = MarkerId(lat.toString() + lng.toString());
    Marker marker = Marker(
        markerId: markerId,
        icon: BitmapDescriptor.defaultMarker,
        position: LatLng(lat, lng),
        infoWindow: InfoWindow(title: getMainAddress, snippet: getCountryName));
    markers[markerId] = marker;
  }

  Widget fetchMaps() {
    return GoogleMap(
        myLocationEnabled: true,
        mapToolbarEnabled: true,
        myLocationButtonEnabled: true,
        // minMaxZoomPreference: MinMaxZoomPreference(1.5, 20.8),
        mapType: MapType.normal,
        onTap: (loc) async {
          final cords = geoCo.Coordinates(loc.latitude, loc.longitude);
          var address =
              await geoCo.Geocoder.local.findAddressesFromCoordinates(cords);
          countryName = address.first.countryName;
          mainAddress = address.first.addressLine;
          notifyListeners();
          getMarker(loc.latitude, loc.longitude);

          print(loc);
          print(countryName);
          print(mainAddress);
        },
        markers: Set<Marker>.of(markers.values),
        onMapCreated: (GoogleMapController mapController) {
          googleMapController = mapController;
          notifyListeners();
        },
        initialCameraPosition: CameraPosition(
            target: LatLng(coordinates.latitude, coordinates.longitude),
            zoom: 16));
  }
}
