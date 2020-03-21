//
//  RegisterViewController.swift
//  CountMemoForEsApp
//
//  Created by ADV on 2020/03/20.
//  Copyright © 2020 Yoko Ishikawa. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var memoTypeLe: UITextField!
    
    @IBOutlet weak var userNameLe: UITextField!
    
    @IBOutlet weak var emailLe: UITextField!
    
    @IBOutlet weak var passwordLe1: UITextField!
    
    @IBOutlet weak var passwordLe2: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func memoTypeBtnClicked(_ sender: Any) {
    }
    
    @IBAction func registerBtnClicked(_ sender: Any) {
        self.dismiss(animated: true) {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let delegateObj = AppDelegate.instance();
            DispatchQueue.main.async {
                        let vc: UIViewController = storyboard.instantiateViewController(withIdentifier: "mainView") as UIViewController
                        vc.modalPresentationStyle = .fullScreen
                        delegateObj.window?.rootViewController!.present(vc, animated: true, completion: {
                        })
            }
        }
    }
    
}
