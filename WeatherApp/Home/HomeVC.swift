//
//  HomeVC.swift
//  WeatherApp
//
//  Created by Gurleen Osahan on 06/09/20.
//  Copyright © 2020 Gurleen Osahan. All rights reserved.
//

import UIKit
import CoreLocation
import  GoogleMaps

class HomeVC: UIViewController {
  
    //MARK:- Variable
    
     var locationManager: CLLocationManager?
     var weatherCoords: CLLocationCoordinate2D?
 
    //MARK:- Outlets
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var lblCoordinates: UILabel!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var imgArrow: UIImageView!
    
    //MARK:- View Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mapView.delegate = self
        self.checkUsersLocationServicesAuthorization()
    }
    
    //MARK:- Check Location
    func checkUsersLocationServicesAuthorization(){
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
            //self.locationManager?.delegate = self
            self.locationManager = CLLocationManager()
            locationManager?.requestWhenInUseAuthorization()
            self.locationManager?.requestAlwaysAuthorization()
            break
            
        case .restricted, .denied:
            // Disable location features
            let alert = UIAlertController(title:"Weather App", message:"Locations Services Disabled", preferredStyle: UIAlertController.Style.alert)
            
            alert.addAction(UIAlertAction(title: "Steps to Enable", style: UIAlertAction.Style.default, handler: { action in
             guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else{
                    return
                }
                if UIApplication.shared.canOpenURL(settingsUrl) {
                    if #available(iOS 10.0, *) {
                        UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                        })
                    } else {
                        
                        UIApplication.shared.openURL(settingsUrl)
                    }
                }
            }))
            alert.addAction(UIAlertAction(title:"Cancel", style: UIAlertAction.Style.default, handler: { action in
                self.checkUsersLocationServicesAuthorization()
                
            }))
            self.present(alert, animated: true, completion: nil)
            
            break
            
        case .authorizedWhenInUse:
            setLocationManager()
            setCurrentLocationOnMap()
            break
            
        case .authorizedAlways:
            setLocationManager()
            setCurrentLocationOnMap()
            break
            
            
        @unknown default:
            break
        }
        
    }
    func setLocationManager(){
        self.locationManager = CLLocationManager()
        mapView.settings.myLocationButton = false
        mapView.isMyLocationEnabled = true
        locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        locationManager?.requestAlwaysAuthorization()
        locationManager?.startUpdatingLocation()
        locationManager?.delegate = self
   }
    func setCurrentLocationOnMap(){
        if CLLocationManager.locationServicesEnabled(){
            locationManager?.startUpdatingLocation()
            guard let latitude = locationManager?.location?.coordinate.latitude,let longitude = locationManager?.location?.coordinate.longitude else {
                return }
            
            let coordinate : CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            self.weatherCoords = coordinate
            let marker = GMSMarker()
            marker.position = coordinate
            marker.title = "(\(coordinate.latitude), \(coordinate.longitude))"
            marker.map = mapView
             self.lblCoordinates.text = "(\(coordinate.latitude), \(coordinate.longitude))"
            let camera = GMSCameraPosition.camera(withLatitude: latitude ,longitude: longitude , zoom: 12.0)
            self.mapView.animate(to: camera)
        }
        
    }

    @IBAction func upArrowTapped(_ sender:UIButton) {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "WeatherVC") as! WeatherVC
        vc.weatherCoordinates = self.weatherCoords
        self.navigationController?.pushViewController(vc, animated: true)
      
    }
   
}

//MARK:- CLLocationManagerDelegate
extension HomeVC: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        guard status == .authorizedWhenInUse else {
            return
        }
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        //print(mapView)
        guard let location = locations.first else {
            return
        }
      
    }
}
//MARK:- CLLocationManagerDelegate

extension HomeVC: GMSMapViewDelegate {
    
func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
    mapView.clear()
    let position = CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude)
   self.weatherCoords = position
    let marker = GMSMarker(position: position)
    marker.title = "(\(coordinate.latitude), \(coordinate.longitude))"
    self.lblCoordinates.text = "(\(coordinate.latitude), \(coordinate.longitude))"
    marker.map = mapView

 }
}
