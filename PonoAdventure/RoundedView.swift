//
//  RoundedView.swift
//  PonoAdventure
//
//  Created by Ria and Dev on 21/10/16.
//  Copyright © 2016 Agileinf. All rights reserved.
//

import UIKit
@IBDesignable
class RoundedView: UIView {
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }

}
