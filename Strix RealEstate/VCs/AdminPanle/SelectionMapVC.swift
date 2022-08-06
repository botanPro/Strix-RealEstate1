//
//  SelectionMapVC.swift
//  Strix RealEstate
//
//  Created by botan pro on 5/24/22.
//

import UIKit
import MapKit
class SelectionMapVC: UIViewController ,MKMapViewDelegate ,CLLocationManagerDelegate, UIGestureRecognizerDelegate{
    
    
    @IBAction func Dismiss(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var MapView: MKMapView!
    
    
    
    var profileIn : [profile] = []
    var AnnotationArray : [Place] = []
    private var locationManager: CLLocationManager!
    private var location: MKAnnotation!
    private var currentLocation: CLLocation?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        gestureRecognizer.delegate = self
        MapView.addGestureRecognizer(gestureRecognizer)
        self.MapView.showsUserLocation = true
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        }
    }
    
    
    
    
    
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last! as CLLocation
        self.cordinate = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        defer { currentLocation = locations.last }
        
        if currentLocation == nil {
            if let userLocation = locations.last {
                let viewRegion = MKCoordinateRegion(center: userLocation.coordinate, latitudinalMeters: 8000, longitudinalMeters: 8000)
                MapView.setRegion(viewRegion, animated: false)
            }
        }
    }
    
    
    //    var SeeProfileId = ""
    //    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
    //        if view.annotation is MKUserLocation{
    //
    //        }else{
    //            if let profileID = view.annotation as? profile {
    //                print(profileID)
    //                self.SeeProfileId = profileID.profileId
    //                let storyboard = UIStoryboard(name: "Main", bundle: nil)
    //                let myVC = storyboard.instantiateViewController(withIdentifier: "GoToEstateProfileVC") as! EstateProfileVc
    //                myVC.EstateId = self.SeeProfileId
    //                myVC.modalPresentationStyle = .fullScreen
    //                self.present(myVC, animated: true, completion: nil)
    //            }
    //
    //        }
    //    }
    
    
    
    var cordinate : CLLocationCoordinate2D!
    var latitude : CLLocationDegrees!
    var longtitude : CLLocationDegrees!
    var IsTaped : Bool = false
    var annotation : MKPointAnnotation!
    
    
    @objc func handleTap(_ gestureReconizer: UILongPressGestureRecognizer) {
        if let anno = annotation{
            self.MapView.removeAnnotation(anno)
        }
        let location = gestureReconizer.location(in: MapView)
        let coordinate = MapView.convert(location,toCoordinateFrom: MapView)
        
        annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        MapView.addAnnotation(annotation)
        
        self.latitude = annotation.coordinate.latitude
        self.longtitude = annotation.coordinate.longitude
        print(latitude)
        print(longtitude)
        self.IsTaped = true
    }
    
    
    
    @IBAction func Save(_ sender: Any) {
        if IsTaped == true {
            if let lat = self.latitude, let lon = self.longtitude{
                let Data:[String: CLLocationDegrees] = ["latitude": lat , "longtitude" : lon]
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "CordinateComing"), object: nil , userInfo: Data)
                self.dismiss(animated: true, completion: nil)
            }
        }else{
            let Data:[String: CLLocationDegrees] = ["latitude": self.cordinate.latitude , "longtitude" : self.cordinate.longitude]
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "CordinateComing"), object: nil , userInfo: Data)
            self.dismiss(animated: true, completion: nil)
        }
    }
}


