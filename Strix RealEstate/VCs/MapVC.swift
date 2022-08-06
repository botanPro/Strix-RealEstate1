//
//  MapVC.swift
//  Strix RealEstate
//
//  Created by botan pro on 4/16/22.
//

import UIKit
import MapKit
import SDWebImage
import EFInternetIndicator

class MapVC: UIViewController , MKMapViewDelegate, CLLocationManagerDelegate  , InternetStatusIndicable{
    var internetConnectionIndicator:InternetViewIndicator?

    @IBOutlet weak var MapView: MKMapView!
    var Locations : [Place] = []
    private var locationManager: CLLocationManager!
    private var location: MKAnnotation!
    private var currentLocation: CLLocation?
    var lat = ""
    var long = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        GetEstates()
        
        XLocations.Shared.GetUserLocation()
        XLocations.Shared.GotLocation = {
           self.lat =  String(XLocations.Shared.latitude)
           self.long =  String(XLocations.Shared.longtude)
       }
        self.MapView.showsUserLocation = true


        DispatchQueue.main.async {
            XLocations.Shared.LocationManager.startUpdatingHeading()
        }
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        }
        self.MapView.delegate = self
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.startMonitoringInternet()
    }
    
    
    
    var AllEstate : [EstateObjects] = []
    func GetEstates(){
        EstateApi.GetAllEstate { Estates in
            self.AllEstate = Estates
            for estet in Estates{
                self.Locations.append(Place(coordinate: CLLocationCoordinate2D(latitude: (estet.latitude as NSString).doubleValue, longitude: (estet.longitude as NSString).doubleValue), profileId: estet.id, title: estet.project_title, subtitle: estet.zone_name, image: estet.image))
            }
            self.MapView.addAnnotations(self.Locations)
        }
    }
    
    var selectedAnnotation: Place?
    var selectedEstate: EstateObjects?
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        self.selectedAnnotation = view.annotation as? Place
        for estate in AllEstate {
            if selectedAnnotation?.profileId == estate.id{
                print(estate.image)
                self.selectedEstate = estate
            }
        }
    }
       
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
      defer { currentLocation = locations.last }

      if currentLocation == nil {
          if let userLocation = locations.last {
              let viewRegion = MKCoordinateRegion(center: userLocation.coordinate, latitudinalMeters: 8000, longitudinalMeters:8000)
              MapView.setRegion(viewRegion, animated: false)
          }
      }
  }
    
    
    var Count = 0
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is Place else {return nil }

           let identifier = "Capital"
           var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)

           if annotationView == nil {
               annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
               annotationView?.canShowCallout = true
               annotationView?.image = UIImage(named: "pin")
               let btn = UIButton(type: .detailDisclosure)
               btn.setImage(UIImage(named: "vuesax-linear-arrow-right"))
               btn.addTarget(self, action: #selector(callSegueFromCell(_:)), for: .touchUpInside)
               annotationView?.rightCalloutAccessoryView = btn
           } else {
               annotationView?.annotation = annotation
           }
           return annotationView
    }
    
    
    @objc  func callSegueFromCell(_ sender:UIButton) {
        self.performSegue(withIdentifier: "Next", sender: self.selectedEstate)
    }
    


override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     if let estate = sender as? EstateObjects{
        if let next = segue.destination as? EstateProfileVC{
            next.EstateProfileInfo = estate
        }
    }
}


}



class profile : MKPointAnnotation {
    var profileId = ""
}


class Place :  NSObject , MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var profileId = ""
    var title :String?
    var subtitle: String?
    var image = ""
    
    init(coordinate : CLLocationCoordinate2D , profileId : String,title : String? , subtitle :String? ,image : String) {
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
        self.profileId = profileId
        self.image = image
    }
    
}
