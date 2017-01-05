//
//  Category.swift
//  PonoAdventure
//
//  Created by Ria and Dev on 19/11/16.
//  Copyright © 2016 Agileinf. All rights reserved.
//
import Foundation
import Gloss
class Category:Decodable {
    var id:String
    var name:String
    var imagePath:String
    required init?(json: JSON) {
        self.id = ("_id" <~~ json)!
        self.name = ("name" <~~ json)!
        self.imagePath = ("image" <~~ json)!
    }
    func toJSON() -> JSON? {
        return jsonify([
            "_id" ~~> self.id,
            "name" ~~> self.name,
            "imagePath" ~~> self.imagePath
        ])
    }
}
