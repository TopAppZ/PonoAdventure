//
//  Web.swift
//  PonoAdventure
//
//  Created by Ria and Dev on 19/11/16.
//  Copyright © 2016 Agileinf. All rights reserved.
//

import Foundation
import Alamofire
import Gloss
class Web:WebInterface {
    private let apiURL = "http://52.39.242.221:3000/api/"
    func getAllCategories(completion: @escaping ([Category]) -> Void) {
        Alamofire.request(self.apiURL + "category/").responseJSON { response in
            let arr = response.result.value as! [JSON]
            completion([Category].from(jsonArray: arr)!)
        }
    }
    
    func getPlacesByCategory(completion: @escaping ([Place]) -> Void, category:String, loc:String) {
        Alamofire.request(self.apiURL + "adventure/?category=" + category + "&loc="+loc).responseJSON { response in
            let arr = response.result.value as! [JSON]
            completion([Place].from(jsonArray: arr)!)
        }
    }
    
}
