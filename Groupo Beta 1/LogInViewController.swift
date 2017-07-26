//
//  LogInViewController.swift
//  Groupo Beta 1
//
//  Created by Dominick Picchione on 7/21/17.
//  Copyright © 2017 Dominick Picchione. All rights reserved.
//

import UIKit
import FirebaseAuth

class LogInViewController: UIViewController {
    
    //outlets for the text fields
    @IBOutlet weak var EmailTextField: UITextField!
    @IBOutlet weak var PasswordTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //user tapped button to log in
    @IBAction func LogIn_Tapped(_ sender: Any) {
        
        //creates variables for the text fields
        let email = EmailTextField.text
        let password = PasswordTextField.text
        
        //signs in the user 
        FIRAuth.auth()?.signIn(withEmail: email!, password: password!, completion: { (user:FIRUser?, error: Error?) in
            if (error == nil) {
                
                //pushes the home screen 
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeScreenViewController")
                self.present(vc, animated: true, completion: nil)
            }
            else{
                
                //alert that there was a problem logging the user in 
                let alert = UIAlertController(title: "UH OH", message: "The email/password combonation that you entered is incorrect. Please try again.", preferredStyle: UIAlertControllerStyle.alert)
                
                //add an action button to the alert
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                
                //show the alert
                self.present(alert, animated: true, completion: nil)
            };
        })
    }
}
    
