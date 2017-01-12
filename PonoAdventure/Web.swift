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
    private let apiURL = "http://192.168.3.102:3000/api/"
    func getAllCategories(completion: @escaping ([Category]) -> Void) {
        Alamofire.request(self.apiURL + "category/").responseJSON { response in
            if let arr = response.result.value {
                completion([Category].from(jsonArray: arr as! [JSON])!)
            } else {
                print("Server offline")
            }
        }
    }
    
    func getPlacesByCategory(completion: @escaping ([Place]) -> Void, category:String, loc:String) {
        Alamofire.request(self.apiURL + "adventure/?category=" + category + "&loc="+loc).responseJSON { response in
            let arr = response.result.value as! [JSON]
            completion([Place].from(jsonArray: arr)!)
        }
    }
    func signUp(completion: @escaping (User) -> Void, userObj: User) {
        Alamofire.request(self.apiURL + "user", method: .post, parameters: userObj.toJSON()!, encoding: JSONEncoding.default).responseJSON { (response) in
            let json = response.result.value as! JSON
            completion(User(json: json)!)
        }
    }
    
}
