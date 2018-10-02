//
//  ViewController.swift
//  FindMyPups
//
//  Created by Chloe Siao on 9/25/18.
//  Copyright © 2018 Chloe Siao. All rights reserved.
//

import UIKit
import CoreLocation
import Cluster
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var mapSB: MKMapView!
    @IBOutlet weak var userLocation: UISearchBar!
    var pointsOfInterest: [MKPointAnnotation] = []
    var foursquareDataSource: LocationDataStore?
    let locationManager : CLLocationManager = CLLocationManager()
    var location : CLLocationCoordinate2D?
    
    var nearString : String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let clusterManager = ClusterManager()
        let annotation = Annotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: 3, longitude: 2)
        
        annotation.type = .color(#colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1), radius: 5)
        clusterManager.add(annotation)
        
        func startingMapAtMyLocation(coordinate : CLLocationCoordinate2D?){
            if let coordinate = coordinate{
                mapSB.camera.centerCoordinate = coordinate
                var region = MKCoordinateRegionMake(coordinate, MKCoordinateSpan(latitudeDelta: -27.104671, longitudeDelta: -109.360481))
                region.center = coordinate
                mapSB.setRegion(region, animated: true)
            }
            mapSB.showsUserLocation = true
        }
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        
        if let location = self.locationManager.location {
            self.location = location.coordinate
        } else {
            location = CLLocationCoordinate2D(latitude: -27.104671, longitude:  -109.360481)
            let annotationEaster = Annotation()
            annotationEaster.coordinate = location!
            
            //Change later so that it can add markers to the different locations
            annotationEaster.type = .color(#colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1) , radius: 5)
            mapSB.addAnnotation(annotationEaster as MKAnnotation)
        }
        
        print(location)
        print("Just printed location :)")
        self.startingMapAtMyLocation(coordinate: location)
        addFoursquareAnnotations() { count in
            DispatchQueue.main.async {
                if self.pointsOfInterest.isEmpty {
                    print("oops")
                } else {
                    for pin in self.pointsOfInterest{
                        self.mapSB.addAnnotation(pin)
                    }
                }
            }
        }
        
    }
    
    func mapView(_ locationView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let annotation = annotation as? ClusterAnnotation {
            guard let type = annotation.type else { return nil }
            let identifier = "Lebanon, Kentucky"
            nearString = identifier
            var view = locationView.dequeueReusableAnnotationView(withIdentifier: identifier)
            if view == nil {
                view = ClusterAnnotationView(annotation: annotation, reuseIdentifier: identifier, type: type)
            } else {
                view?.annotation = annotation
            }
            return view
            
        }
        //  return nil
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        ClusterManager.reload(mapView) { finished in
            // handle completion
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error while updating location " + error.localizedDescription)
    }
    // Do any additional setup after loading the view, typically from a nib.
        
        func addFoursquareAnnotations(_ completion: @escaping (_ count: Int) -> ()) {
            pointsOfInterest.removeAll()
            foursquareDataSource = LocationDataStore()
            guard let foursquareDataSource = foursquareDataSource else {
                return
            }
            
            foursquareDataSource.fetchLocationsFromFoursquareWithCompletion(nearString) { success in
                if success {
                    for location in foursquareDataSource.foursquareData {
                        print(location)
                        let pin : MKPointAnnotation = MKPointAnnotation()
                        pin.coordinate = CLLocationCoordinate2D(latitude: location.placeLatitude, longitude: location.placeLongitude)
                        pin.title = location.placeName
                        pin.subtitle = location.placeAddress
                        self.pointsOfInterest.append(pin)}
                }
                completion(self.pointsOfInterest.count)
            }
        }
    
    override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
        
    }
        // Do any additional setup after loading the view, typically from a nib.
    }


        // Dispose of any resources that can be recreated.




