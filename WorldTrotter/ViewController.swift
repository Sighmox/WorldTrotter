//
//  ViewController.swift
//  Mapping101
//
//  Created by Paul Baker on 2/6/19.
//  Copyright © 2019 Paul Baker. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    @IBOutlet weak var locationText: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    
    let locationManager = CLLocationManager()
    let geoCoder = CLGeocoder()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // This requests permission to use the location of the user
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        mapView.delegate = self
        
    }
    // Adds the current location dot to the map as well as the time
    @IBAction func CurrtentLocationMarker(_ sender: Any)
    { if let location = locationManager.location {
        let annotation = MKPointAnnotation()
        annotation.coordinate = location.coordinate
        let timeStamp = dateFormatter.string(from: Date())
        annotation.title = "You were here at \(timeStamp)"
        mapView.addAnnotation(annotation)
        
        geoCoder.reverseGeocodeLocation(location, completionHandler: { (placeMarks:
            [CLPlacemark]?, error: Error?) in
            if error == nil {
                let placeMark = placeMarks![0]
                self.reverseGeocodeComplete(location: placeMark)
            }
        })
        }
    }
    
    // Custom pin color
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKPointAnnotation {
            let pinAnnotation = MKPinAnnotationView()
            pinAnnotation.pinTintColor = UIColor.orange
            pinAnnotation.annotation = annotation
            pinAnnotation.canShowCallout = true
            return pinAnnotation
        }
        return nil
    }
    
    
    
    func reverseGeocodeComplete(location: CLPlacemark) {
        let locationString = "\(location)"
        print(locationString)
        self.locationText.text = locationString
    }
    func moveToCurrentLocation() {
        if let location = locationManager.location {
            mapView.setCenter(location.coordinate , animated: true)
        }
    }
    //This function prevents pins from being placed too close to each other
    @IBAction func addCurrentLocationMarker(_ sender: Any) {
        if let location = locationManager.location {
            
            let closeAnootation = mapView.annotations
                .map({ CLLocation(latitude: $0.coordinate.latitude, longitude: $0.coordinate.longitude) })
                .filter({$0.distance(from: location) < 30 }) // Doesn't allow pins closer than 30 meters
            
            if closeAnootation.count > 1 {
                print("Another pin locaiton is too close. New pin will not be added!")
                return
            }
        }
        
    }
    
    // This adds the date and time
    let dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateStyle = .short
        df.timeStyle = .short
        return df
    }()
    
   
        // Checks if the user authorized location services and if they didn't displays a message
        func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
            if status == .authorizedWhenInUse {
                mapView.showsUserLocation = true
                moveToCurrentLocation()
            } else {
                let alert = UIAlertController(title: "Can't display location", message: "Please grant permission in settings",
                    preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK",
                                              style: .default,
                                              handler: { (action: UIAlertAction) -> Void in UIApplication.shared.open(URL(string:
                                                UIApplicationOpenSettingsURLString)!) } ))
                present(alert, animated: true, completion: nil)
                
            }
            
            
        }

}
    






        

