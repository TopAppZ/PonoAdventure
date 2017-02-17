//
//  TermsAndConditionsViewController.swift
//  PonoAdventure
//
//  Created by Ria and Dev on 15/02/17.
//  Copyright © 2017 Agileinf. All rights reserved.
//

import UIKit

class TermsAndConditionsViewController: UIViewController {

    @IBOutlet weak var webView: UIWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let url = NSURL (string: "https://s3-us-west-2.amazonaws.com/pono-adventure-s3/tnc.html")
        let requestObj = NSURLRequest(url: url! as URL);
        webView.loadRequest(requestObj as URLRequest)
        // Do any additional setup after loading the view.
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
