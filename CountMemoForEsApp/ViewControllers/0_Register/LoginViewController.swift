//
//  LoginViewController.swift
//  CountMemoForEsApp
//
//  Created by ADV on 2020/03/20.
//  Copyright © 2020 Yoko Ishikawa. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    
    @IBOutlet weak var emailLe: UITextField!
    
    @IBOutlet weak var passwordLe: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func loginBtnClicked(_ sender: Any) {
        
        
        let delegateObj = AppDelegate.instance();
        self.dismiss(animated: true) {
            let vc: UIViewController = self.storyboard!.instantiateViewController(withIdentifier: "mainView") as UIViewController
            vc.modalPresentationStyle = .fullScreen
            delegateObj.window?.rootViewController!.present(vc, animated: true, completion: nil)
        }
    }
    

}
