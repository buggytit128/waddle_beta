//
//  SignUpViewController.swift
//  Groupo Beta 1
//
//  Created by Dominick Picchione on 7/20/17.
//  Copyright © 2017 Dominick Picchione. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class SignUpViewController: UIViewController {
    
    //outlets for the text fields
    @IBOutlet weak var EmailTextField: UITextField!
    @IBOutlet weak var PasswordTextField: UITextField!
    @IBOutlet weak var VerifyPasswordTextField: UITextField!
    
    //variable for database reference
    let databaseref = FIRDatabase.database().reference(fromURL: "https://groupo-beta-1.firebaseio.com/")

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //user tapped the button to register
    @IBAction func RegisterButtonTapped(_ sender: Any) {
        
        //variable to make sure passwords match
        var passwordmatch = false
        
        //if statement to make sure passwords match
        if PasswordTextField.text == VerifyPasswordTextField.text {
            passwordmatch = true
        } else {
            
            //alerts user that the passwords do not match
            // create the alert
            let alert = UIAlertController(title: "OOPS!", message: "The passwords you entered do not match. Plesae try again.", preferredStyle: UIAlertControllerStyle.alert)
            
            // add an action (button)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            
            // show the alert
            self.present(alert, animated: true, completion: nil)        }
        
        //if statement to only sign up user if passwords match each other
        if passwordmatch == true {
        
        //creates variables for the text fields
        let email = EmailTextField.text
        let password = PasswordTextField.text
        
        //creates user
        FIRAuth.auth()?.createUser(withEmail: email!, password: password!, completion: { (user:FIRUser?, error: Error?) in
            if (error == nil) {
                
                //sets uid variable
                let uid = user?.uid
                
                //creates the child in the database
                let userReference = self.databaseref.child("users").child(uid!)
                let values = ["username":"", "bio":"", "profilepicture":""]
                
                userReference.updateChildValues(values, withCompletionBlock: { (error, ref) in
                    if error != nil{
                        print(error!)
                        return
                        
                    }
                })
                
                
                //pushes the edit profile view controller
               let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SuccessLogInViewController")
                self.present(vc, animated: true, completion: nil)
               
            }
                else{
                
                //alert that there was an error
                // create the alert
                let alert = UIAlertController(title: "OOPS!", message: "Sorry there was a problem creating your account. Please try again.", preferredStyle: UIAlertControllerStyle.alert)
                
                // add an action (button)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                
                // show the alert
                self.present(alert, animated: true, completion: nil)                };
            })
        
        }
    }
}








