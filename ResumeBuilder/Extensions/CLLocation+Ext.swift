//
//  CLLocation+Ext.swift
//  ResumeBuilder
//
//  Created by Lefdili Alaoui Ayoub on 13/11/2021.
//

import CoreLocation


extension CLLocation {
    
    func fetchCityAndCountry(completion: @escaping (_ city: String?, _ country:  String?, _ error: Error?) -> ()) {
        CLGeocoder().reverseGeocodeLocation(self) { completion($0?.first?.locality, $0?.first?.country, $1) }
    }
    
}
