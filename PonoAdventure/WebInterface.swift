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
}
