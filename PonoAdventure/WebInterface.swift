//
//  WebInterface.swift
//  PonoAdventure
//
//  Created by Ria and Dev on 19/11/16.
//  Copyright © 2016 Agileinf. All rights reserved.
//
import Alamofire
import Gloss
import Foundation
protocol WebInterface {
    func getAllCategories(completion: @escaping (_:[Category]) -> Void)
    func getPlacesByCategory(completion:@escaping(_:[Place]) -> Void, category:String, loc:String)
    func signUp(completion:@escaping(_:User) -> Void, userObj:User)
    func login(completion:@escaping(_:User?) -> Void, params:[String:String])
    func notification(completion:@escaping(_:Any?) -> Void, params:[String:Any])
    func book(userID:String, placeId:String, completion:@escaping(_:Any?) -> Void, params:[String:Any])
}
