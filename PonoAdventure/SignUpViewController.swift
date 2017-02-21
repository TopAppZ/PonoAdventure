//
//  SignUpViewController.swift
//  PonoAdventure
//
//  Created by Ria and Dev on 12/01/17.
//  Copyright © 2017 Agileinf. All rights reserved.
//

import UIKit
import SwiftValidator
import PKHUD
class SignUpViewController: UIViewController, UIScrollViewDelegate, ValidationDelegate, UITextFieldDelegate {

    @IBOutlet weak var scrollview: UIScrollView!
    @IBOutlet weak var email: CustomTextField!
    @IBOutlet weak var password: CustomTextField!
    @IBOutlet weak var fullName: CustomTextField!
    @IBOutlet weak var fullAddress: CustomTextField!
    @IBOutlet weak var contactNumber: CustomTextField!
    
    let validator = Validator()
    override func viewDidLoad() {
        super.viewDidLoad()
        validator.registerField(fullName, rules: [RequiredRule(), FullNameRule()])
        validator.registerField(email, rules: [RequiredRule(), EmailRule(message: "Invalid email")])
        validator.registerField(fullAddress, rules: [RequiredRule()])
        validator.registerField(password, rules: [RequiredRule()])
        validator.registerField(contactNumber, rules: [RequiredRule(), PhoneNumberRule()])
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillLayoutSubviews() {
        self.scrollview.contentSize = CGSize(width: self.view.frame.width, height: self.view.frame.height + 350);
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        fullName.endEditing(true)
        fullAddress.endEditing(true)
        contactNumber.endEditing(true)
        email.endEditing(true)
        password.endEditing(true)
    }
    
    func validationSuccessful() {
        let user = User(json: [
            "_id":"",
            "full_name":self.fullName.text!,
            "email":self.email.text!,
            "password":self.password.text!,
            "contact_number":self.contactNumber.text!,
            "full_address":self.fullAddress.text!,
            "state":2,
            "device_id":UserDefaults.standard.string(forKey: "deviceID") ?? ""
            ])
        HUD.show(.labeledProgress(title: "Wait", subtitle: "Signing you up!"))
        let w = Web()
        w.signUp(completion: { (ruser) in
            HUD.hide()
            UserDefaults.standard.setValue(ruser.id, forKey: "userId")
            let storyboard = UIStoryboard(name: "TabPane", bundle: nil)
            let initialViewController = storyboard.instantiateViewController(withIdentifier: "TabPane") as! UITabBarController
            self.navigationController?.pushViewController(initialViewController, animated: true)
        }, userObj: user!)
    }

    @IBAction func signUpAction(_ sender: Any) {
        validator.validate(self)
    }
    func validationFailed(_ errors:[(Validatable ,ValidationError)]) {
        for (field, error) in errors {
            if let field = field as? UITextField {
                field.layer.borderColor = UIColor.red.cgColor
                field.layer.borderWidth = 1.0
            }
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.layer.borderColor = UIColor.white.cgColor
    }
    override func viewDidAppear(_ animated: Bool) {
        AppUtility.lockOrientation(.portrait)
    }
    override func viewDidDisappear(_ animated: Bool) {
        AppUtility.lockOrientation(.all)
    }
}
