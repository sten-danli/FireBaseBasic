//
//  MainViewController.swift
//  FireBaseBasic
//
//  Created by Dan Li on 22.10.19.
//  Copyright © 2019 Dan Li. All rights reserved.
//

import UIKit
import FirebaseAuth

class MainViewController: UIViewController {

    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

   
    
    @IBAction func logInButton(_ sender: UIButton) {
        
        Auth.auth().signIn(withEmail:emailTextField.text! , password: passwordTextField.text!) { (data, erro) in
            if let err = erro{
                print(err.localizedDescription)
                return
            }
            self.performSegue(withIdentifier: "registerSegue", sender: nil)
        }
    }
    
    
    
    
    
    
    
    
    
}
