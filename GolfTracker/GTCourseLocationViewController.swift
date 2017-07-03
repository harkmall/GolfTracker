//
//  GTCourseLocationViewController.swift
//  GolfTracker
//
//  Created by Mark Hall on 2017-07-02.
//  Copyright © 2017 markhall. All rights reserved.
//

import UIKit
import MapKit

class GTCourseLocationViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var courseNameField: UITextField!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    
    let locationManager = CLLocationManager()
    let course = GTCourse()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)

        let mapTap = UITapGestureRecognizer(target: self, action: #selector(tappedMap(recogniser:)))
        mapView.addGestureRecognizer(mapTap)
        
    }
 
    @IBAction func useCurrentLocationButtonPressed(_ sender: Any) {
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }

    @IBAction func nextButtonPressed(_ sender: Any) {
        if let name = courseNameField.text{
            course.name = name
            course.location = mapView.annotations.first?.coordinate
            performSegue(withIdentifier: "GTCourseDetailsSegue", sender: self)
        }
    }
    
    func tappedMap(recogniser: UITapGestureRecognizer) {
        let point = recogniser.location(in: mapView)
        let coordinate = mapView.convert(point, toCoordinateFrom: mapView)
        addAnnotationAtCoordinate(coordinate)
    }
    
    //MARK: CLLocationManagerDelegate
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        addAnnotationAtCoordinate(locValue)
        locationManager.stopUpdatingLocation()
    }
    
    func addAnnotationAtCoordinate(_ coordinate: CLLocationCoordinate2D) {
        mapView.removeAnnotations(mapView.annotations)
        
        let coursePin = MKPointAnnotation()
        if let name = courseNameField.text {
            coursePin.title = name
        }
        coursePin.coordinate = coordinate
        
        mapView.addAnnotation(coursePin)
        mapView.showAnnotations([coursePin], animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let detailsVC = segue.destination as? GTAddCourseViewController {
            detailsVC.course = course
        }
    }
    @IBAction func cancelPressed(_ sender: Any) {
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
}
