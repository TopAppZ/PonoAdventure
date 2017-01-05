//
//  CustomAnnotation.swift
//  PonoAdventure
//
//  Created by Ria and Dev on 06/01/17.
//  Copyright © 2017 Agileinf. All rights reserved.
//

import UIKit
import MapKit
class CustomAnnotation: MKPointAnnotation {
    var place:Place?
    override init() {
        super.init()
    }
}
