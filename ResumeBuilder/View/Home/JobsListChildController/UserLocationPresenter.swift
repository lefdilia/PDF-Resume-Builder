//
//  UserLocationPresenter.swift
//  ResumeBuilder
//
//  Created by Lefdili Alaoui Ayoub on 13/11/2021.
//

import UIKit
import CoreLocation

protocol UserLocationPresenterDelegate: AnyObject {
    func presentLocation(location: Location?,_ error: Error?)
}

class UserLocationPresenter: NSObject, CLLocationManagerDelegate {
    
    weak var delegate: UserLocationPresenterDelegate?
    let locationManager = CLLocationManager()
    
    func requetUserLocation(){
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager( _ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        switch status {
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        case .restricted, .denied:
            break
        case .authorizedAlways, .authorizedWhenInUse:
            manager.requestLocation()
        default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let location = locations.first {
            
            let latitude = location.coordinate.latitude
            let longitude = location.coordinate.longitude
            
            let _location = CLLocation(latitude: latitude, longitude: longitude)
            
            _location.fetchCityAndCountry { [weak self] city, country, error in
                guard let city = city, let country = country, error == nil else { return }
                self?.locationManager.stopUpdatingLocation()
                self?.delegate?.presentLocation(location: Location(city: city, country: country), nil)
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        self.delegate?.presentLocation(location: nil, error)
    }

}
