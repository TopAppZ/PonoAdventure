//
//  Place.swift
//  PonoAdventure
//
//  Created by Ria and Dev on 06/12/16.
//  Copyright © 2016 Agileinf. All rights reserved.
//
import Foundation
import Gloss
class Place:Decodable {
    var id:String
    var name:String
    var address_1:String
    var address_2:String
    var city:String
    var state:String
    var country:String
    var zip:String
    var category:String
    var videoURL:String
    var description:String
    var price:String
    var imagePath:String
    var location:[String:Any]
    var distance:Double
    var schedule:[String]
    
    required init?(json: JSON) {
        self.id = ("_id" <~~ json)!
        self.name = ("name" <~~ json)!
        self.address_1 = ("address_1" <~~ json)!
        self.address_2 = ("address_2" <~~ json)!
        self.city = ("city" <~~ json)!
        self.state = ("state" <~~ json)!
        self.country = ("country" <~~ json)!
        self.zip = ("address_1" <~~ json)!
        self.category = ("category" <~~ json)!
        self.videoURL = ("video_url" <~~ json)!
        self.description = ("description" <~~ json)!
        self.price = ("price" <~~ json)!
        self.imagePath = ("image" <~~ json)!
        self.location = ("location" <~~ json)!
        self.distance = ("dis" <~~ json)!
        self.schedule = ("schedule" <~~ json)!
    }
    /*func toJSON() -> JSON? {
        return jsonify([
            "_id" ~~> self.id,
            "name" ~~> self.name,
            "imagePath" ~~> self.imagePath
            ])
    }*/
}
