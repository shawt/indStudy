//
//  LocationDataStore.swift
//  FindMyPups
//
//  Created by Chloe Siao on 9/25/18.
//  Copyright © 2018 Chloe Siao. All rights reserved.
//

import Foundation
import CoreLocation

class LocationDataStore {
    
    var foursquareData : Set<FoursquareData> = []
    
    func fetchLocationsFromFoursquareWithCompletion(_ nearString : String, completion: @escaping (Bool) -> ()) {
        let parameter = ["client_id": Constant.Endpoints.clientID,
                         "client_secret": Constant.Endpoints.clientPassword,
                         "v": "20170808",
                         "near" : nearString,
                         //                         "ll": "\(ll.longitude),\(ll.latitude)",
            //Change this later to the search bar
            "query": "animal, park"]
        
        //find datatype of error 
        FoursquareAPIClient.getQueryForSearchLandmarks(parameter) {itemsJSON, err in

            guard let itemsArray = json.0?.dictionary!["venues"]?.array else {
                print("error: no data recieved from API Client")
                completion(false)
                return
            }
            
            for venue in itemsArray {
                self.foursquareData.insert(FoursquareData(json: venue))
            }
            completion(true)
        }
    }
}
