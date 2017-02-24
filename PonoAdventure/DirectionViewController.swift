//
//  DirectionViewController.swift
//  PonoAdventure
//
//  Created by Ria and Dev on 24/02/17.
//  Copyright © 2017 Agileinf. All rights reserved.
//

import UIKit
import GoogleMaps
import Alamofire
import Gloss
class DirectionViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var gmapView: GMSMapView!
    let locationManager = CLLocationManager()
    var location:CLLocation?
    var place:Place?
    var placeLocation:Array<Any>?
    override func viewDidLoad() {
        super.viewDidLoad()
        print(self.place?.location ?? "")
        self.placeLocation = self.place?.location["coordinates"] as! Array
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        // 3
        if status == .authorizedWhenInUse {
            
            // 4
            locationManager.startUpdatingLocation()
            
            //5
            gmapView.isMyLocationEnabled = true
            gmapView.settings.myLocationButton = true
        }
    }
    
    // 6
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            
            // 7
            self.location = location
            gmapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 14, bearing: 0, viewingAngle: 0)
            
            // 8
            locationManager.stopUpdatingLocation()
            
            addOverlayToMapView()
        }
        
    }
    func addOverlayToMapView(){
        
        let directionURL = "http://52.39.242.221:3000/api/adventure/direction"
        Alamofire.request(directionURL, method: .post, parameters: ["source":[location?.coordinate.latitude,location?.coordinate.longitude], "dest":[placeLocation![1],placeLocation![0]]], encoding: JSONEncoding.default).responseJSON { (response) in
            print(response)
            if let res = response.result.value  {
                let json = res as! JSON
                let points = json["points"]
                self.addPolyLineWithEncodedStringInMap(points as! String)
            } else {
                print("server error")
            }
        }
        
    }
    
    func addPolyLineWithEncodedStringInMap(_ encodedString: String) {
        
        let path = GMSMutablePath(fromEncodedPath: encodedString)
        let polyLine = GMSPolyline(path: path)
        polyLine.strokeWidth = 6
        polyLine.strokeColor = UIColor.red
        polyLine.map = gmapView
        
    }
    

}
