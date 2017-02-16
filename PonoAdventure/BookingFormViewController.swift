//
//  BookingFormViewController.swift
//  PonoAdventure
//
//  Created by Ria and Dev on 08/01/17.
//  Copyright © 2017 Agileinf. All rights reserved.
//

import UIKit
import Gloss
import SwiftValidator
class BookingFormViewController: UIViewController, UIScrollViewDelegate, PayPalPaymentDelegate, ValidationDelegate {
    @IBOutlet weak var scrollView: UIScrollView!
    var paypalConfiguration = PayPalConfiguration()
    @IBOutlet weak var noPersons: UITextField!
    @IBOutlet weak var fullName: UITextField!
    @IBOutlet weak var fullAddress: UITextField!
    @IBOutlet weak var contactNumber: UITextField!
    @IBOutlet weak var sex: UISwitch!
    @IBOutlet weak var canSwim: UISwitch!
    @IBOutlet weak var strength: UISlider!
    @IBOutlet weak var dare: UISlider!
    @IBOutlet weak var strengthLabel: UILabel!
    @IBOutlet weak var dareLabel: UILabel!
    var payPalViewController:PayPalPaymentViewController?
    var place:Place?
    var selectedDate:String?
    var dateUTC:Date?
    let validator = Validator()
    var totalPrice:Double?
    override func viewDidLoad() {
        super.viewDidLoad()
        let fmt = DateFormatter()
        fmt.dateFormat = "dd/MM/yyyy"
        self.dateUTC = fmt.date(from: self.selectedDate!)
        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(LoginViewController.keyboardWillShow(_:)), name:NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(LoginViewController.keyboardWillHide(_:)), name:NSNotification.Name.UIKeyboardWillHide, object: nil)
        paypalConfiguration.acceptCreditCards = true
        paypalConfiguration.payPalShippingAddressOption = PayPalShippingAddressOption.none
        paypalConfiguration.languageOrLocale = "en"
        paypalConfiguration.merchantName = "Pono Adventure LLC"
        PayPalMobile.preconnect(withEnvironment: PayPalEnvironmentSandbox)
        
        validator.registerField(fullName, rules: [RequiredRule()])
        validator.registerField(fullAddress, rules: [RequiredRule(), EmailRule(message: "Invalid email")])
        validator.registerField(contactNumber, rules: [RequiredRule(), PhoneNumberRule()])
        validator.registerField(noPersons, rules: [RequiredRule()])
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillLayoutSubviews() {
        self.scrollView.contentSize = CGSize(width: self.view.frame.width, height: self.view.frame.height + 150);
    }
    func keyboardWillShow(_ sender: Notification) {
        self.scrollView.contentSize = CGSize(width: self.view.frame.width, height: self.view.frame.height + 350);
    }
    
    func keyboardWillHide(_ sender: Notification) {
        self.scrollView.contentSize = CGSize(width: self.view.frame.width, height: self.view.frame.height);
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        noPersons.endEditing(true)
        fullName.endEditing(true)
        fullAddress.endEditing(true)
        contactNumber.endEditing(true)
    }
    func payPalPaymentViewController(_ paymentViewController: PayPalPaymentViewController, didComplete completedPayment: PayPalPayment) {
        var resp:[String:Any] = completedPayment.confirmation["response"] as! [String : Any]
        
        //call web api here
        let formatter = DateFormatter()
        formatter.timeZone = NSTimeZone(forSecondsFromGMT: 0) as TimeZone!
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        let w = Web()
        w.book(userID: UserDefaults.standard.string(forKey: "userId")!, placeId: place!.id, completion: { (_response) in
            let respose = _response as! JSON
            if respose["_id"] as! String == "" || respose["_id"] == nil {
                
                self.payPalViewController?.dismiss(animated: true, completion: {
                    let alert = UIAlertController(title: "Booking failed", message: "Your bokking is failed. Please try after some times or contact customer care", preferredStyle: UIAlertControllerStyle.alert)
                    let defaultAction = UIAlertAction(title: "OK", style: .default, handler: {(action:UIAlertAction) in
                        self.presentingViewController?.dismiss(animated: true, completion: {
                            
                        })
                    })
                    alert.addAction(defaultAction)
                    self.present(alert, animated: true, completion: {
                        self.presentingViewController?.dismiss(animated: true, completion: { 
                            
                        })
                    })
                })
            } else {
                
                self.payPalViewController?.dismiss(animated: true, completion: {
                    let alert = UIAlertController(title: "Booking success", message: "Your booking is successfully done. Please check your email for more details", preferredStyle: UIAlertControllerStyle.alert)
                    let defaultAction = UIAlertAction(title: "OK", style: .default, handler: {(action:UIAlertAction) in
                        self.presentingViewController?.dismiss(animated: true, completion: {
                            
                        })
                    })
                    alert.addAction(defaultAction)
                    self.present(alert, animated: true, completion: {
                        
                    })
                })
                
            }
        }, params: [
            "full_name":self.fullName.text!,
            "email": self.fullAddress.text!,
            "contact_number": self.contactNumber.text!,
            "age": "18",
            "number_of_person": self.noPersons.text!,
            "gender": self.sex.isOn ? "F" : "M",
            "can_swim": self.canSwim.isOn ? "true" : "false",
            "strenious_activity_rate": String(self.strength.value),
            "transaction_id": resp["id"]!,
            "booking_date": formatter.string(from: self.dateUTC!),
            "total_price": String(totalPrice!)
        ])
    }
    func payPalPaymentDidCancel(_ paymentViewController: PayPalPaymentViewController) {
        payPalViewController?.dismiss(animated: true, completion: { 
            
        })
    }
    override func viewWillAppear(_ animated: Bool) {
        UINavigationBar.appearance().tintColor = .white
        UINavigationBar.appearance().barTintColor = UIColor(red: 0.0/255.0, green: 198.0/255.0, blue: 255.0/255.0, alpha: 1.0)
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
    }
    @IBAction func checkoutAction(_ sender: Any) {
        noPersons.layer.borderColor = UIColor.white.cgColor
        fullAddress.layer.borderColor = UIColor.white.cgColor
        fullName.layer.borderColor = UIColor.white.cgColor
        contactNumber.layer.borderColor = UIColor.white.cgColor
        validator.validate(self)
        
    }
    @IBAction func strengthChnagedAction(_ sender: Any) {
        strengthLabel.text = "Your Strength " + String(Int(strength.value)) + "/5"
    }
    
    @IBAction func dareChnagedAction(_ sender: Any) {
        dareLabel.text = "Your Dare " + String(Int(dare.value)) + "/5"
    }
    
    func validationFailed(_ errors:[(Validatable ,ValidationError)]) {
        for (field, _) in errors {
            if let field = field as? UITextField {
                field.layer.borderColor = UIColor.red.cgColor
                field.layer.borderWidth = 1.0
            }
        }
    }
    
    func validationSuccessful() {
        totalPrice = Double(noPersons.text!)! * Double(place!.price)!
        let payment = PayPalPayment()
        payment.amount = NSDecimalNumber(value: totalPrice!)
        payment.currencyCode = "USD"
        payment.shortDescription = "Final booking amount"
        payment.intent = PayPalPaymentIntent.sale
        if (payment.processable) {
            UINavigationBar.appearance().tintColor = nil
            UINavigationBar.appearance().barTintColor = nil
            payPalViewController = PayPalPaymentViewController(payment: payment, configuration: paypalConfiguration, delegate: self)
            present(payPalViewController!, animated: true, completion: {
                
            })
        }
    }
    
}
