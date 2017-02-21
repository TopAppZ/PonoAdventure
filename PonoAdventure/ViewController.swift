//
//  ViewController.swift
//  PonoAdventure
//
//  Created by Ria and Dev on 23/09/16.
//  Copyright © 2016 Agileinf. All rights reserved.
//

import UIKit
import Kingfisher
import PKHUD
import CoreLocation
class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource , CLLocationManagerDelegate{
    var categories:[Category] = []
    var places:[Place] = []
    let locationManager = CLLocationManager()
    var location:CLLocation?
    @IBOutlet weak var categoryTable: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let w = Web()
        w.getAllCategories { (categories) in
            self.categories = categories
            self.categoryTable.reloadData()
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        HUD.show(.labeledProgress(title: "Wait", subtitle: "Fetching your current location"))
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count;
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell") as! CategoryTableViewCell!
        if (cell == nil) {
            cell = CategoryTableViewCell(style:.default, reuseIdentifier: "categoryCell")
        }
        cell?.categoryLabel.text = categories[indexPath.row].name
        let imageURL = URL(string: categories[indexPath.row].imagePath)
        cell?.categoryImage.kf.setImage(with: imageURL)
        return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let category = (self.categories[indexPath.row].name)
        let w = Web()
        let loc = String(self.location!.coordinate.longitude) + "," + String(self.location!.coordinate.latitude)
        w.getPlacesByCategory(completion: { (places) in
            self.places = places
            self.performSegue(withIdentifier: "toPlace", sender: self)
        }, category: category, loc: loc)
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "toPlace"){
            let dest = segue.destination as! ListViewController
            dest.places = self.places
        }
    }
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.startUpdatingLocation()
        }
        else if status == .authorizedAlways {
            locationManager.startUpdatingLocation()
        } else {
            locationManager.startUpdatingLocation()
        }
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            self.location = location
        }
        print(String(self.location!.coordinate.latitude) + "," + String(self.location!.coordinate.longitude))
        self.locationManager.stopUpdatingLocation()
        HUD.hide(animated: true)
        
    } 
    override func viewDidAppear(_ animated: Bool) {
        AppUtility.lockOrientation(.portrait)
    }
    override func viewDidDisappear(_ animated: Bool) {
        AppUtility.lockOrientation(.all)
    }


}

