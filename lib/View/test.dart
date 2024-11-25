// import 'package:flutter/material.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:location/location.dart';
//
// class LocationService {
//   Future<Position> getCurrentLocation() async {
//     Location location = Location();
//     bool serviceEnabled = await location.serviceEnabled();
//     if (!serviceEnabled) {
//       serviceEnabled = await location.requestService();
//       if (!serviceEnabled) {
//         throw Exception('Location services are disabled');
//       }
//     }
//
//     PermissionStatus permissionGranted = await location.hasPermission();
//     if (permissionGranted == PermissionStatus.denied) {
//       permissionGranted = await location.requestPermission();
//       if (permissionGranted != PermissionStatus.granted) {
//         throw Exception('Location permission denied');
//       }
//     }
//
//     return await location.getLocation();
//   }
// }
//
// class LocationScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Location with City and Country')),
//       body: FutureBuilder<Position>(
//         future: LocationService().getCurrentLocation(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           } else if (snapshot.hasData) {
//             Position position = snapshot.data!;
//             return FutureBuilder<List<Placemark>>(
//               future: GeocodingPlatform.instance.placemarkFromCoordinates(
//                 position.latitude,
//                 position.longitude,
//               ),
//               builder: (context, geocodeSnapshot) {
//                 if (geocodeSnapshot.connectionState == ConnectionState.waiting) {
//                   return Center(child: CircularProgressIndicator());
//                 } else if (geocodeSnapshot.hasError) {
//                   return Center(child: Text('Error: ${geocodeSnapshot.error}'));
//                 } else if (geocodeSnapshot.hasData) {
//                   List<Placemark> placemarks = geocodeSnapshot.data!;
//                   if (placemarks.isNotEmpty) {
//                     Placemark placemark = placemarks.first;
//                     return Center(
//                       child: Text(
//                         'City: ${placemark.locality}, Country: ${placemark.country}\nLat: ${position.latitude}, Long: ${position.longitude}',
//                         textAlign: TextAlign.center,
//                       ),
//                     );
//                   } else {
//                     return Center(child: Text('No address found.'));
//                   }
//                 } else {
//                   return Center(child: Text('No data available.'));
//                 }
//               },
//             );
//           } else {
//             return Center(child: Text('No location data available.'));
//           }
//         },
//       ),
//     );
//   }
// }
//
// void main() => runApp(MaterialApp(home: LocationScreen()));
