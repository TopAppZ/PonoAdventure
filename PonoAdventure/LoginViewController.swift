//
//  LoginViewController.swift
//  PonoAdventure
//
//  Created by Ria and Dev on 21/10/16.
//  Copyright © 2016 Agileinf. All rights reserved.
//

import UIKit
import PKHUD
class LoginViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var email: CustomTextField!
    @IBOutlet weak var password: CustomTextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(LoginViewController.keyboardWillShow(_:)), name:NSNotification.Name.UIKeyboardWillShow, object: nil);
        NotificationCenter.default.addObserver(self, selector: #selector(LoginViewController.keyboardWillHide(_:)), name:NSNotification.Name.UIKeyboardWillHide, object: nil);
                
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    func keyboardWillShow(_ sender: Notification) {
        self.scrollView.contentSize = CGSize(width: self.view.frame.width, height: self.view.frame.height + 270);
        self.scrollView.setContentOffset(CGPoint(x: self.view.frame.origin.x, y: self.view.frame.origin.y + 150), animated: true)
    }
    
    func keyboardWillHide(_ sender: Notification) {
        self.scrollView.contentSize = CGSize(width: self.view.frame.width, height: self.view.frame.height);
    }
    @IBAction func actionLogin(_ sender: Any) {
        HUD.show(.labeledProgress(title: "Wait", subtitle: "Logging in!"))
        let w = Web()
        w.login(completion: { (user) in
            HUD.hide()
            if(user != nil) {
                UserDefaults.standard.setValue(user!.id, forKey: "userId")
                let storyboard = UIStoryboard(name: "TabPane", bundle: nil)
                let initialViewController = storyboard.instantiateViewController(withIdentifier: "TabPane") as! UITabBarController
                self.navigationController?.setViewControllers([initialViewController], animated: true)
            } else {
                let alert = UIAlertController(title: "Login failed", message: "Please check your email or password", preferredStyle: UIAlertControllerStyle.alert)
                let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(defaultAction)
                self.present(alert, animated: true, completion: {
                    
                })
            }
            
        }, params: ["email":email.text! , "password":password.text!, "device_id":UserDefaults.standard.string(forKey: "deviceID")!])
    }

}
