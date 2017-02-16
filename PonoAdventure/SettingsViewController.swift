//
//  SettingsViewController.swift
//  PonoAdventure
//
//  Created by Ria and Dev on 09/02/17.
//  Copyright © 2017 Agileinf. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var tracking: UISwitch!
    override func viewDidLoad() {
        super.viewDidLoad()
        tracking.isOn = UserDefaults.standard.bool(forKey: "tracking")
        // Do any additional setup after loading the view.
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
    @IBAction func trackingChangedAction(_ sender: UISwitch) {
        UserDefaults.standard.set(sender.isOn, forKey: "tracking")
    }

    @IBAction func logOut(_ sender: Any) {
        performSegue(withIdentifier: "logOut", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "logOut" {
            UserDefaults.standard.setValue(nil, forKey: "userId")
        }
    }
}
