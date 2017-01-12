//
//  BookingFormViewController.swift
//  PonoAdventure
//
//  Created by Ria and Dev on 08/01/17.
//  Copyright © 2017 Agileinf. All rights reserved.
//

import UIKit

class BookingFormViewController: UIViewController, UIScrollViewDelegate, PayPalPaymentDelegate {

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
    var payPalViewController:PayPalPaymentViewController?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(LoginViewController.keyboardWillShow(_:)), name:NSNotification.Name.UIKeyboardWillShow, object: nil);
        NotificationCenter.default.addObserver(self, selector: #selector(LoginViewController.keyboardWillHide(_:)), name:NSNotification.Name.UIKeyboardWillHide, object: nil);
        paypalConfiguration.acceptCreditCards = true
        paypalConfiguration.payPalShippingAddressOption = PayPalShippingAddressOption.none
        PayPalMobile.preconnect(withEnvironment: PayPalEnvironmentSandbox)
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
        let payment = PayPalPayment()
        payment.amount = NSDecimalNumber(string: "34")
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
