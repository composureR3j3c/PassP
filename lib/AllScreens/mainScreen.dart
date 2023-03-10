import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter/material.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:provider/provider.dart';
import 'package:ridee/AllScreens/searchScreen.dart';
import 'package:ridee/Globals/Global.dart';
import 'package:ridee/Helpers/assistantMethods.dart';
import 'package:ridee/Helpers/geofireAssistant.dart';
import 'package:ridee/Models/directDetails.dart';
import 'package:ridee/Models/nearbyAvailableDrivers.dart';
import 'package:ridee/Provider/appdata.dart';
import 'package:ridee/Widgets/Divider.dart';
import 'package:ridee/Widgets/Drawer.dart';
import 'package:ridee/Widgets/DropDown.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';

import '../Helpers/OnPremMethods.dart';

import '../Widgets/Colorize.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with TickerProviderStateMixin {
  Completer<GoogleMapController> _controller = Completer();
  late GoogleMapController newGoogleMapController;
  static final CameraPosition _kinit = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(9.005401, 38.763611),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

  late Position currentPosition;
  var geoLocator = Geolocator();
  late LocationPermission permission;
  double bottomPadding = 0;
  double assignedDriverInfoContainerHeight = 0;
  double rideDetailContainerHeight = 0;
  double requestHeight = 0;
  double searchContainerHeight = 100;

  String driverRideStatus = "Driver is Coming";
  String userRideRequestStatus = "";

  var econ, minBus, minVan;

  bool searchScreen = true;
  late DirectDetails tripDirectDetails = DirectDetails();
  bool nearbyAvailableDriversKeyLoaded = false;

  Set<Marker> markerSet = {};
  Set<Circle> circlesSet = {};
  List<LatLng> pLineCoOrdinatesList = [];
  Set<Polyline> polyLineSet = {};
  BitmapDescriptor? nearByIcon;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    BitmapDescriptor.fromAssetImage(
            ImageConfiguration(size: Size(2, 2)), 'images/CarTop.png')
        .then((onValue) {
      nearByIcon = onValue;
    });
    // locatePosition();
    AssistantMethods.readCurrentOnlineUserInfo();
  }

  void cancelRideRequest() {
    // TODO: call cancel
    // referenceRideRequest!.remove();
    displaySearch();
  }

  void saveRideRequest() async {
    orderTime = DateTime.now();
    var pickup =
        Provider.of<AppData>(context, listen: false).userPickUpLocation;
    var dropOff = Provider.of<AppData>(context, listen: false).dropOffLocation;

    Map pickUpLocMap = {
      "name": pickup?.placeName,
      "y": pickup?.latitude.toString(),
      "x": pickup?.longitude.toString(),
    };
    Map dropOffLocMap = {
      "name": dropOff?.placeName,
      "y": dropOff?.latitude.toString(),
      "x": dropOff?.longitude.toString(),
    };

    Map rideInfoMap = {
      "passenger": {
        "id": userModelCurrentInfo?.phone,
        "location": {"from": pickUpLocMap, "to": dropOffLocMap}
      },
      "distance": tripDirectDetails.distance.toString(),
      "carType": "econ",
      "time": tripDirectDetails.time,
      "paymentMethod": finalDropdownValue
    };

    var response = await OnPremMethods.requestRide(rideInfoMap);

    if (response != 404) {
      if (response["status"] == "No Driver Found") {
        Fluttertoast.showToast(msg: "No Driver Found.");
        print("No Driver Found.");
        displaySearch();
      } else {
        currTripId = response["tripId"];
        driverCarDetails = response["driver"]["carDetails"]["carBrand"];
        driverPhone = response["driver"]["phone"];
        driverName = response["driver"]["name"];
        int driverDistance = (response["driver"]["driverDistance"]).truncate();
        userRideRequestStatus = "accepted";
        setState(() {
          showUIForAssignedDriverInfo();
          driverRideStatus =
              "Driver is Coming... " + driverDistance.toString() + "away";
        });

        while (userRideRequestStatus == "accepted" ||
            userRideRequestStatus == "statrted" ||
            userRideRequestStatus == "driver arrived") {
          var response = await OnPremMethods.getTripDetail(currTripId!);
          setState(() {
            userRideRequestStatus = driverRideStatus = response["tripStatus"];
          });
          var duration = const Duration(seconds: 5);
          print('Start sleeping');

          //started, arrived, ended, cancelled

          sleep(duration);
          print('5 seconds has passed');
          if (userRideRequestStatus == "statrted" &&
              (DateTime.now().minute.toDouble() -
                          orderTime!.minute.toDouble()) %
                      15 ==
                  0) {
            locatePosition();

            var res = await OnPremMethods.updateLocation(
                currTripId!,
                currentPosition.latitude.toString(),
                currentPosition.latitude.toString());
          }
        }
      }
    } else {
      Fluttertoast.showToast(msg: "No Driver Found.");
      print("No Driver Found false.");
      displaySearch();
    }
  }

  showUIForAssignedDriverInfo() {
    setState(() {
      rideDetailContainerHeight = 0;
      searchContainerHeight = 0;
      requestHeight = 0;
      assignedDriverInfoContainerHeight = 300;
    });
  }

  void displayRideDetail() async {
    // await getDirections();
    var res = await AssistantMethods.calcualateFares(tripDirectDetails);

    econ = res["econ"].toString();
    minVan = res["minVan"].toString();
    minBus = res["minBus"].toString();
    setState(() {
      requestHeight = 0;
      searchContainerHeight = 0;
      rideDetailContainerHeight = 450;
      assignedDriverInfoContainerHeight = 0;
    });
  }

  void displaySearch() async {
    // await getDirections();
    setState(() {
      requestHeight = 0;
      searchContainerHeight = 100;
      rideDetailContainerHeight = 0;
      assignedDriverInfoContainerHeight = 0;
    });
  }

  void displayRequest() async {
    // await getDirections();
    setState(() {
      requestHeight = 320;
      searchContainerHeight = 0;
      rideDetailContainerHeight = 0;
      assignedDriverInfoContainerHeight = 0;
    });

    saveRideRequest();
  }

  void callNumber() async {
    var number = driverPhone; //set the number here
    await FlutterPhoneDirectCaller.callNumber(number);
  }

  void locatePosition() async {
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return;
      } else if (permission == LocationPermission.deniedForever) {
        return;
      }
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    currentPosition = position;

    LatLng latLngPosition = LatLng(position.latitude, position.longitude);

    CameraPosition cameraPosition = new CameraPosition(
      target: latLngPosition,
      zoom: 14.4746,
    );
    newGoogleMapController
        .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

    final address =
        await AssistantMethods.searchAddressForGeographicCoOrdinates(
            position, context);
    print("address##############");
    print(address);
    setState(() {
      bottomPadding = 300.0;
    });
    initGeofireListener();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.red[800],
        toolbarOpacity: 0.5,
        bottomOpacity: 0.5,
        title: Text(
          "One Taxi",
          textAlign: TextAlign.center,
          style: GoogleFonts.pacifico(
              textStyle: TextStyle(
            color: Colors.red,
            fontSize: 30,
            fontWeight: FontWeight.w900,
          )),
        ),
      ),
      drawer: DrawerWidget(
          name: userModelCurrentInfo?.name, phone: userModelCurrentInfo?.phone),
      body: Stack(
        children: [
          GoogleMap(
            padding: EdgeInsets.only(bottom: bottomPadding),
            initialCameraPosition: _kinit,
            mapType: MapType.normal,
            myLocationButtonEnabled: true,
            myLocationEnabled: true,
            zoomControlsEnabled: true,
            zoomGesturesEnabled: true,
            polylines: polyLineSet,
            circles: circlesSet,
            markers: markerSet,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
              newGoogleMapController = controller;

              locatePosition();
            },
            onCameraMove: (position) {
              // locatePosition();
            },
          ),
          Positioned(
              left: 0.0,
              right: 0.0,
              bottom: 0.0,
              child: AnimatedSize(
                curve: Curves.bounceIn,
                duration: new Duration(milliseconds: 160),
                child: Container(
                  width: double.infinity,
                  height: searchContainerHeight,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 23.0, vertical: 17.5),
                    child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            GestureDetector(
                              onTap: () async {
                                var res = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => SearchScreen()));
                                if (res == "obtainDirection") {
                                  await getPlaceDirections();
                                  await drawPolyLineFromOriginToDestination();
                                  displayRideDetail();
                                }
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.black54,
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(15),
                                      bottomLeft: Radius.circular(15),
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black45,
                                        blurRadius: 6.0,
                                        spreadRadius: 0.4,
                                        offset: Offset(1, 1),
                                      )
                                    ]),
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Row(children: [
                                    SizedBox(
                                      width: 10.0,
                                    ),
                                    Icon(Icons.search,
                                        color: Colors.white, size: 35),
                                    SizedBox(
                                      width: 10.0,
                                    ),
                                    Align(
                                      alignment: Alignment.center,
                                      child: Text(
                                        "Where to?",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 21.0,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10.0,
                                    ),
                                    Icon(Icons.car_rental,
                                        color: Colors.white, size: 35),
                                    SizedBox(
                                      width: 10.0,
                                    ),
                                  ]),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () async {
                                DateTime? selectedDate = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime.now(),
                                  lastDate: DateTime(DateTime.now().year + 1),
                                );
                                preorderTime = selectedDate;
                                var res = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => SearchScreen()));
                                if (res == "obtainDirection") {
                                  await getPlaceDirections();
                                  await drawPolyLineFromOriginToDestination();
                                  displayRideDetail();
                                }
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.black54,
                                    borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(15),
                                      bottomRight: Radius.circular(15),
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black54,
                                        blurRadius: 6.0,
                                        spreadRadius: 0.4,
                                        offset: Offset(1, 1),
                                      )
                                    ]),
                                child: Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Row(children: [
                                    SizedBox(
                                      width: 10.0,
                                    ),
                                    Icon(Icons.timer,
                                        color: Colors.white, size: 35),
                                  ]),
                                ),
                              ),
                            ),
                          ],
                        )),
                  ),
                ),
              )),
          Positioned(
              left: 0.0,
              right: 0.0,
              bottom: 0.0,
              child: AnimatedSize(
                curve: Curves.bounceIn,
                duration: const Duration(milliseconds: 10),
                child: Container(
                  height: rideDetailContainerHeight,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(18.0),
                          topRight: Radius.circular(18.0)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black,
                          blurRadius: 16.0,
                          spreadRadius: 0.8,
                          offset: Offset(1, 1),
                        )
                      ]),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 9.5),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  carTypeFinal = econ;
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.red[100],
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.white12,
                                          blurRadius: 1,
                                          spreadRadius: 0.8,
                                          offset: Offset(0.2, 0.2),
                                        )
                                      ]),
                                  width: double.infinity,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 15.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Image.asset(
                                          "images/taxi.png",
                                          height: 70.0,
                                          width: 80.0,
                                        ),
                                        CircleAvatar(
                                          backgroundColor: Colors.white10,
                                          foregroundColor: Colors.black,
                                          radius: 25,
                                          child: Text(
                                            "Any Car",
                                            style: TextStyle(
                                                fontSize: 12.2,
                                                fontWeight: FontWeight.normal),
                                          ),
                                        ),
                                        CircleAvatar(
                                          backgroundColor: Colors.white10,
                                          foregroundColor: Colors.black,
                                          radius: 30,
                                          child: Text(
                                            (tripDirectDetails.distance != null)
                                                ? "${(tripDirectDetails.distance! / 1000).truncate().toString()} Km"
                                                : "5 km",
                                            style: TextStyle(
                                                fontSize: 15.2,
                                                fontWeight: FontWeight.normal),
                                          ),
                                        ),
                                        CircleAvatar(
                                          backgroundColor: Colors.white10,
                                          foregroundColor: Colors.black,
                                          radius: 35,
                                          child: Text(
                                            tripDirectDetails.distance != null
                                                ? "ETB ${econ}"
                                                : "ETB 100",
                                            style: TextStyle(
                                                fontSize: 15.2,
                                                fontWeight: FontWeight.normal),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  carTypeFinal = minVan;
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.white10,
                                          blurRadius: 1,
                                          spreadRadius: 0.8,
                                          offset: Offset(0.2, 0.2),
                                        )
                                      ]),
                                  // color: Colors.amber,
                                  width: double.infinity,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 15.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Image.asset(
                                          "images/automoblie.png",
                                          height: 70.0,
                                          width: 80.0,
                                        ),
                                        CircleAvatar(
                                          backgroundColor: Colors.white10,
                                          foregroundColor: Colors.black,
                                          radius: 25,
                                          child: Text(
                                            "Minivan",
                                            style: TextStyle(
                                                fontSize: 12.2,
                                                fontWeight: FontWeight.normal),
                                          ),
                                        ),
                                        CircleAvatar(
                                          backgroundColor: Colors.white10,
                                          foregroundColor: Colors.black,
                                          radius: 30,
                                          child: Text(
                                            (tripDirectDetails.distance != null)
                                                ? "${(tripDirectDetails.distance! / 1000).truncate().toString()} Km"
                                                : "5 km",
                                            style: TextStyle(
                                                fontSize: 15.2,
                                                fontWeight: FontWeight.normal),
                                          ),
                                        ),
                                        CircleAvatar(
                                          backgroundColor: Colors.white10,
                                          foregroundColor: Colors.black,
                                          radius: 35,
                                          child: Text(
                                            tripDirectDetails.distance != null
                                                ? "ETB ${minBus}"
                                                : "ETB 100",
                                            style: TextStyle(
                                                fontSize: 15.2,
                                                fontWeight: FontWeight.normal),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.white12,
                                          blurRadius: 1,
                                          spreadRadius: 0.8,
                                          offset: Offset(0.2, 0.2),
                                        )
                                      ]),
                                  width: double.infinity,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 15.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Image.asset(
                                          "images/minibus.png",
                                          height: 70.0,
                                          width: 80.0,
                                        ),
                                        CircleAvatar(
                                          backgroundColor: Colors.white10,
                                          foregroundColor: Colors.black,
                                          radius: 25,
                                          child: Text(
                                            "Minibus",
                                            style: TextStyle(
                                                fontSize: 12.2,
                                                fontWeight: FontWeight.normal),
                                          ),
                                        ),
                                        CircleAvatar(
                                          backgroundColor: Colors.white10,
                                          foregroundColor: Colors.black,
                                          radius: 30,
                                          child: Text(
                                            (tripDirectDetails.distance != null)
                                                ? "${(tripDirectDetails.distance! / 1000).truncate().toString()} Km"
                                                : "5 km",
                                            style: TextStyle(
                                                fontSize: 15.2,
                                                fontWeight: FontWeight.normal),
                                          ),
                                        ),
                                        CircleAvatar(
                                          backgroundColor: Colors.white10,
                                          foregroundColor: Colors.black,
                                          radius: 35,
                                          child: Text(
                                            tripDirectDetails.distance != null
                                                ? "ETB ${minBus}"
                                                : "ETB 100",
                                            style: TextStyle(
                                                fontSize: 15.2,
                                                fontWeight: FontWeight.normal),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 5.0,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.0),
                          child: Row(
                            children: [
                              Icon(
                                FontAwesomeIcons.moneyBill1,
                                color: Colors.black54,
                              ),
                              SizedBox(
                                width: 16.0,
                              ),
                              // Text("Cash"),
                              DropdownButtonCash(),
                              SizedBox(
                                height: 6.0,
                              ),
                              // Icon(
                              //   Icons.keyboard_arrow_down,
                              //   color: Colors.black54,
                              //   size: 16.0,
                              // )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 0.0),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.black87,
                                ),
                                onPressed: () {
                                  setState(() {
                                    displayRequest();
                                  });
                                },
                                child: Padding(
                                  padding: EdgeInsets.all(17.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Request ",
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                      Icon(FontAwesomeIcons.taxi,
                                          color: Colors.white, size: 26.0),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 10.0,
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 0.0),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.red[800],
                                  // backgroundColor: Colors.cyan
                                ),
                                onPressed: () {
                                  setState(() {
                                    cancelRideRequest();
                                  });
                                },
                                child: Padding(
                                  padding: EdgeInsets.all(17.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Icon(FontAwesomeIcons.undo,
                                          color: Colors.white, size: 26.0),
                                    ],
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              )),
          Positioned(
            left: 0.0,
            right: 0.0,
            bottom: 0.0,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16.0),
                    topRight: Radius.circular(16.0)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black45,
                    blurRadius: 16.0,
                    spreadRadius: 0.4,
                    offset: Offset(1, 1),
                  )
                ],
              ),
              height: requestHeight,
              child: Column(
                children: [
                  SizedBox(
                    height: 15,
                  ),
                  Colorize(),
                  SizedBox(
                    height: 22,
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        displaySearch();
                      });
                    },
                    child: CircleAvatar(
                        radius: 25.0,
                        backgroundColor: Colors.red[300],
                        child: Icon(
                          Icons.close,
                          size: 26.0,
                          color: Colors.white,
                        )),
                  ),
                  SizedBox(height: 10.0),
                  Text(
                    "Cancel Ride",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12.0),
                  )
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: assignedDriverInfoContainerHeight,
              decoration: const BoxDecoration(
                color: Colors.black87,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20),
                  topLeft: Radius.circular(20),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //status of ride
                    Center(
                      child: Text(
                        driverRideStatus,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.normal,
                          color: Colors.white54,
                        ),
                      ),
                    ),

                    const SizedBox(
                      height: 20.0,
                    ),

                    const Divider(
                      height: 2,
                      thickness: 2,
                      color: Colors.white54,
                    ),

                    const SizedBox(
                      height: 20.0,
                    ),

                    //driver vehicle details
                    Text(
                      driverCarDetails,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white54,
                      ),
                    ),

                    const SizedBox(
                      height: 2.0,
                    ),

                    //driver name
                    Text(
                      driverName,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.normal,
                        color: Colors.white54,
                      ),
                    ),

                    const SizedBox(
                      height: 20.0,
                    ),

                    const Divider(
                      height: 2,
                      thickness: 2,
                      color: Colors.white54,
                    ),

                    const SizedBox(
                      height: 20.0,
                    ),

                    //call driver button
                    Center(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          callNumber();
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.green,
                        ),
                        icon: const Icon(
                          Icons.phone_android,
                          color: Colors.black54,
                          size: 22,
                        ),
                        label: const Text(
                          "Call Driver",
                          style: TextStyle(
                            color: Colors.black54,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 5.0,
                    ),

                    Center(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          displaySearch();
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.red,
                        ),
                        icon: const Icon(
                          Icons.stop_circle_outlined,
                          color: Colors.black54,
                          size: 22,
                        ),
                        label: const Text(
                          "Cancel",
                          style: TextStyle(
                            color: Colors.black54,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> getPlaceDirections() async {
    var initialPosition =
        Provider.of<AppData>(context, listen: false).userPickUpLocation;
    var finalPosition =
        Provider.of<AppData>(context, listen: false).dropOffLocation;

    print("####locations####");
    print(initialPosition);
    var pickupLatlng =
        LatLng(initialPosition!.latitude!, initialPosition.longitude!);
    var dropOffLatlng =
        LatLng(finalPosition!.latitude!, finalPosition.longitude!);

    Fluttertoast.showToast(msg: "Please Wait...");
    // showDialog(context: context, builder: (BuildContext context)=>ProgressDialog(type:ProgressDialogType.Normal).style(message: "Please Wait...")  }

    var details =
        await AssistantMethods.obtainDirection(pickupLatlng, dropOffLatlng);
    setState(() {
      tripDirectDetails = details!;
    });
    // Navigator.pop(context);
  }

  void initGeofireListener() async {
    //
    // Geofire.initialize("availableDrivers");
    await OnPremMethods.getAvailableDrivers(
        currentPosition.latitude, currentPosition.longitude);
    Geofire.queryAtLocation(
            currentPosition.latitude, currentPosition.longitude, 5)
        ?.listen((map) {
      print(map);
      if (map != null) {
        var callBack = map['callBack'];

        //latitude will be retrieved from map['latitude']
        //longitude will be retrieved from map['longitude']
        NearbyAvailableDrivers nearbyAvailableDrivers =
            NearbyAvailableDrivers();
        nearbyAvailableDrivers.key = map['key'];
        nearbyAvailableDrivers.latitude = map['latitude'];
        nearbyAvailableDrivers.longitude = map['longitude'];
        switch (callBack) {
          case Geofire.onKeyEntered:
            GeoFireAssistant.nearbyAvailableDriversList
                .add(nearbyAvailableDrivers);
            if (nearbyAvailableDriversKeyLoaded == true) {
              updateAvailableDriversNow();
            }
            break;

          case Geofire.onKeyExited:
            GeoFireAssistant.removeDriverFromlist(map['key']);
            updateAvailableDriversNow();
            break;

          case Geofire.onKeyMoved:
            // Update your key's location
            GeoFireAssistant.updateDriverLocation(nearbyAvailableDrivers);
            updateAvailableDriversNow();
            break;

          case Geofire.onGeoQueryReady:
            // All Intial Data is loaded
            print(map['result']);

            updateAvailableDriversNow();
            break;
        }
      }

      setState(() {});
      //
    });
  }

  void updateAvailableDriversNow() {
    if (!mounted) return;
    setState(() {
      markerSet.clear();
    });
    Set<Marker> tMarkers = Set<Marker>();
    for (NearbyAvailableDrivers driver
        in GeoFireAssistant.nearbyAvailableDriversList) {
      LatLng driverAvailableposition =
          LatLng(driver.latitude!, driver.longitude!);

      Marker marker = Marker(
          markerId: MarkerId('driver${driver.key}'),
          position: driverAvailableposition,
          icon: nearByIcon!,
          rotation: AssistantMethods.createRandomNumber(360));

      tMarkers.add(marker);
    }
    setState(() {
      markerSet = tMarkers;
    });
  }

  Future<void> drawPolyLineFromOriginToDestination() async {
    var originPosition =
        Provider.of<AppData>(context, listen: false).userPickUpLocation;
    var destinationPosition =
        Provider.of<AppData>(context, listen: false).dropOffLocation;

    var originLatLng =
        LatLng(originPosition!.latitude!, originPosition.longitude!);
    var destinationLatLng =
        LatLng(destinationPosition!.latitude!, destinationPosition.longitude!);

    // showDialog(
    //     context: context,
    //     builder: (BuildContext context) => ProgressDialog(message: "Please wait...",),
    // );
    Fluttertoast.showToast(msg: "Please Wait...");

    var directionDetailsInfo =
        await AssistantMethods.obtainDirection(originLatLng, destinationLatLng);

    // Navigator.pop(context);

    print("These are points = ");
    print(directionDetailsInfo!.e_points);

    PolylinePoints pPoints = PolylinePoints();
    List decodedPolyLinePointsResultList = (directionDetailsInfo.e_points!);

    pLineCoOrdinatesList.clear();

    // if (decodedPolyLinePointsResultList.isNotEmpty) {
    decodedPolyLinePointsResultList.forEach((pointLatLng) {
      pLineCoOrdinatesList.add(LatLng(pointLatLng[1], pointLatLng[0]));
    });
    // }
    polyLineSet.clear();

    setState(() {
      Polyline polyline = Polyline(
        color: Colors.red,
        polylineId: const PolylineId("PolylineID"),
        jointType: JointType.round,
        points: pLineCoOrdinatesList,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
        geodesic: true,
      );
      print("polylineform" + polyline.toString());
      polyLineSet.add(polyline);
    });

    LatLngBounds boundsLatLng;
    if (originLatLng.latitude > destinationLatLng.latitude &&
        originLatLng.longitude > destinationLatLng.longitude) {
      boundsLatLng =
          LatLngBounds(southwest: destinationLatLng, northeast: originLatLng);
    } else if (originLatLng.longitude > destinationLatLng.longitude) {
      boundsLatLng = LatLngBounds(
        southwest: LatLng(originLatLng.latitude, destinationLatLng.longitude),
        northeast: LatLng(destinationLatLng.latitude, originLatLng.longitude),
      );
    } else if (originLatLng.latitude > destinationLatLng.latitude) {
      boundsLatLng = LatLngBounds(
        southwest: LatLng(destinationLatLng.latitude, originLatLng.longitude),
        northeast: LatLng(originLatLng.latitude, destinationLatLng.longitude),
      );
    } else {
      boundsLatLng =
          LatLngBounds(southwest: originLatLng, northeast: destinationLatLng);
    }

    newGoogleMapController!
        .animateCamera(CameraUpdate.newLatLngBounds(boundsLatLng, 65));

    Marker originMarker = Marker(
      markerId: const MarkerId("originID"),
      infoWindow:
          InfoWindow(title: originPosition.placeName, snippet: "Origin"),
      position: originLatLng,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow),
    );

    Marker destinationMarker = Marker(
      markerId: const MarkerId("destinationID"),
      infoWindow: InfoWindow(
          title: destinationPosition.placeName, snippet: "Destination"),
      position: destinationLatLng,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
    );
    Circle originCircle = Circle(
      circleId: const CircleId("originID"),
      fillColor: Colors.green,
      radius: 16,
      strokeWidth: 3,
      strokeColor: Colors.white,
      center: originLatLng,
    );

    Circle destinationCircle = Circle(
      circleId: const CircleId("destinationID"),
      fillColor: Colors.red,
      radius: 16,
      strokeWidth: 3,
      strokeColor: Colors.white,
      center: destinationLatLng,
    );

    setState(() {
      markerSet.add(originMarker);
      markerSet.add(destinationMarker);
      circlesSet.add(originCircle);
      circlesSet.add(destinationCircle);
    });
  }
}
