//
//  FoursquareData.swift
//  FindMyPups
//
//  Created by Chloe Siao on 9/25/18.
//  Copyright © 2018 Chloe Siao. All rights reserved.
//

import Foundation
import SwiftyJSON

class FoursquareData: NSObject {
    
    var placeIdentifier: String
    var placeVenue: [String : JSON]
    var placeLongitude: Double
    var placeLatitude: Double
    var placeName: String
    var placeAddress: String
    //    var placePhotoURL: String
    
    init(json: JSON) {
        guard let
            venue = json.dictionary,
            let identifier = venue["id"]!.string,
            let longitude = venue["location"]!["lng"].double,
            let latitude = venue["location"]!["lat"].double,
            let address = venue["location"]!["formattedAddress"].array,
            let name = venue["name"]!.string
            
            else {
                fatalError("There was an error retrieving the information from FourSquare.")
        }
        var addressStringConverter = ""
        
        for i in 0..<address.count {
            addressStringConverter.append(address[i].stringValue)
        }
        
        placeVenue = venue
        placeLatitude = (latitude)
        placeLongitude = (longitude)
        placeName = name
        placeAddress = addressStringConverter
        placeIdentifier = identifier
        //        placePhotoURL =
        //         Constant.Endpoints.FOURSQUARE_GET_PHOTO.replacingOccurrences(of: "%@", with: placeIdentifier)
        
    }
}
