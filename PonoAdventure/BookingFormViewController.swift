//
//  BookingFormViewController.swift
//  PonoAdventure
//
//  Created by Ria and Dev on 08/01/17.
//  Copyright © 2017 Agileinf. All rights reserved.
//

import UIKit

class BookingFormViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var noPersons: UITextField!
    @IBOutlet weak var fullName: UITextField!
    @IBOutlet weak var fullAddress: UITextField!
    @IBOutlet weak var contactNumber: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(LoginViewController.keyboardWillShow(_:)), name:NSNotification.Name.UIKeyboardWillShow, object: nil);
        NotificationCenter.default.addObserver(self, selector: #selector(LoginViewController.keyboardWillHide(_:)), name:NSNotification.Name.UIKeyboardWillHide, object: nil);
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
}
