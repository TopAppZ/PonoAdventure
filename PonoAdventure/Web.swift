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
    //52.39.242.221
    private let apiURL = "http://52.39.242.221:3000/api/"
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
            print(response)
            let json = response.result.value as! JSON
            completion(User(json: json)!)
        }
    }
    func login(completion: @escaping (User?) -> Void, params: [String : String]) {
        Alamofire.request(self.apiURL + "user/login", method: .post, parameters: params, encoding: JSONEncoding.default).responseJSON { (response) in
            if response.result.isSuccess {
                let json = response.result.value as! JSON
                completion(User(json: json)!)
            } else if response.result.isFailure {
                completion(nil)
            }
        }
        
    }
    func notification(completion: @escaping (Any?) -> Void, params: [String : Any]) {
        Alamofire.request(self.apiURL + "notification", method: .post, parameters: params, encoding: JSONEncoding.default).responseJSON { (response) in
            completion(response.result.value as! JSON)
        }
    }
    func book(userID: String, placeId: String, completion: @escaping (Any?) -> Void, params: [String : Any]) {
        let url = self.apiURL + "user/" + userID + "/book/" + placeId
        Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default).responseJSON { (response) in
            completion(response.result.value as! JSON)
        }
    }
}
