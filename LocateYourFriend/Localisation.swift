//
//  Localisation.swift
//  LocateYourFriend
//
//  Created by Brandon Caurel on 27/05/2016.
//  Copyright © 2016 KhaoulaZitoun. All rights reserved.
//

import Foundation
import CoreLocation

class Localisation{
    let latitudeLoc : Float
    let longitudeLoc : Float
    let longitudeLatitude :[String]
    
    init(localisation : CLLocationCoordinate2D){
        latitudeLoc = Float(localisation.latitude)
        longitudeLoc = Float(localisation.longitude)
        
        longitudeLatitude = [String(localisation.longitude), String(localisation.latitude)]
        
    }
}
