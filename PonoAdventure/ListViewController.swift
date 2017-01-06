//
//  ListViewController.swift
//  PonoAdventure
//
//  Created by Ria and Dev on 21/10/16.
//  Copyright © 2016 Agileinf. All rights reserved.
//

import UIKit
import Kingfisher
import MapKit
class ListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating, UISearchBarDelegate, MKMapViewDelegate {
    var places:[Place] = []
    var filteredPlaces:[Place] = []
    let searchController = UISearchController(searchResultsController: nil)
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var toggleView: UISegmentedControl!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var mkMap: MKMapView!
    let initialLocation = CLLocation(latitude: 21.461816, longitude: -157.980067)
    let regionRadius: CLLocationDistance = 60000
    override func viewDidLoad() {
        super.viewDidLoad()
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
        centerMapOnLocation(initialLocation)
        for place in places {
            let coordinates = place.location["coordinates"] as! NSArray
            let annotation = CustomAnnotation()
            annotation.place = place
            let newCoord:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: (coordinates[1] as! CLLocationDegrees), longitude: (coordinates[0] as! CLLocationDegrees))
            annotation.coordinate = newCoord
            annotation.title = place.name
            annotation.subtitle = place.address_1 + ", " + place.address_2 + ", " + place.city
            mkMap.addAnnotation(annotation)
        }
        mkMap.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive && searchController.searchBar.text != "" {
            return filteredPlaces.count
        }
        return self.places.count;
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "placeCell") as! PlaceTableViewCell!
        if (cell == nil) {
            cell = PlaceTableViewCell(style:.default, reuseIdentifier: "placeCell")
        }
        if searchController.isActive && searchController.searchBar.text != "" {
            cell?.placeName.text = self.filteredPlaces[indexPath.row].name
            let imageURL = URL(string: filteredPlaces[indexPath.row].imagePath)
            cell?.PlaceImage.kf.setImage(with: imageURL)
            cell?.address.text = filteredPlaces[indexPath.row].address_1 + ", " + filteredPlaces[indexPath.row].address_2 + ", " + filteredPlaces[indexPath.row].state + " (" +  String(filteredPlaces[indexPath.row].distance) + " KM)"
            return cell!
        }
        cell?.placeName.text = self.places[indexPath.row].name
        let imageURL = URL(string: places[indexPath.row].imagePath)
        cell?.PlaceImage.kf.setImage(with: imageURL)
        cell?.address.text = places[indexPath.row].address_1 + ", " + places[indexPath.row].address_2 + ", " + places[indexPath.row].state + " (" +  String(places[indexPath.row].distance) + " KM)"
        return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        filteredPlaces = places.filter { place in
            return place.name.lowercased().contains(searchText.lowercased())
        }
        tableView.reloadData()
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchText: searchController.searchBar.text!)
    }
    
    @IBAction func toggleListMap(_ sender: Any) {
        switch toggleView.selectedSegmentIndex
        {
        case 0:
            scrollToPage(0)
            break
            
        case 1:
            scrollToPage(1)
            break
            
        default:
            break; 
        }
    }
    func scrollToPage(_ page: Int) {
        UIView.animate(withDuration: 0.3) {
            self.scrollView.contentOffset.x = self.scrollView.frame.width * CGFloat(page)
        }
    }
    func centerMapOnLocation(_ location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                  regionRadius * 2.0, regionRadius * 2.0)
        mkMap.setRegion(coordinateRegion, animated: true)
    }
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            //return nil so map view draws "blue dot" for standard user location
            return nil
        }
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.rightCalloutAccessoryView = UIButton(type: UIButtonType.detailDisclosure)
            pinView!.animatesDrop = true
            pinView!.pinTintColor = .red
        }
        else {
            pinView!.annotation = annotation
        }
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        let annotation = view.annotation as! CustomAnnotation
        
    }
    
}
