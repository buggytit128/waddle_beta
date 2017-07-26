//
//  EditProfileViewController.swift
//  Groupo Beta 1
//
//  Created by Dominick Picchione on 7/21/17.
//  Copyright © 2017 Dominick Picchione. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class EditProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    //outlets for the user's full name and their bio
    @IBOutlet weak var usernametextfield: UITextField!
    @IBOutlet weak var biotextfield: UITextField!
    @IBOutlet weak var profilepictureimage: UIImageView!
    
    //variables for the storage and database references
    var databaseRef: FIRDatabaseReference!
    var storageRef: FIRStorageReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        databaseRef = FIRDatabase.database().reference()
        storageRef = FIRStorage.storage().reference()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
   
    
    
    
    //user tapped to update their profile
    @IBAction func gobacktoprofile_tapped(_ sender: Any) {
        updateUsersProfile()
    }
    
    func updateUsersProfile(){
    
        //check to see if the user is logged in
        if let userID = FIRAuth.auth()?.currentUser?.uid{
            //creates an access point for the firevase storage
            let storageItem = storageRef.child("profile_Images").child(userID)
            //get the image uploaded from photo library
            guard let image = profilepictureimage.image else {return}
            if let newimage = UIImagePNGRepresentation(image){
                //upload to firebase storage
                storageItem.put(newimage, metadata: nil, completion: { (metadata, error) in
                    if error != nil{
                        print(error!)
                        return
                    }
                    storageItem.downloadURL(completion: { (url, error) in
                        if error != nil{
                            print(error!)
                            return
                        }
                        if let profilePhotoURL = url?.absoluteString{
                            guard let newUserName = self.usernametextfield.text else {return}
                            guard let newBioText = self.biotextfield.text else {return}
                            
                            let newValuesForProfile =
                                ["bio": newBioText, "profilepicture": profilePhotoURL, "username": newUserName]
                        
                            //update the firebase database for that user
                            self.databaseRef.child(userID).updateChildValues(newValuesForProfile, withCompletionBlock: { (error, ref) in
                                if error != nil{
                                    print(error!)
                                    return
                                }
                                print("Profile Successfully Updated")
                        })

                    }
                        })
})
}
}
}

    
    
    
    @IBAction func changeProPic_tapped(_ sender: Any) {
    
    //creates image picker controller
    let picker = UIImagePickerController()
    //sets the delegate
    picker.delegate = self
    //set details
    picker.allowsEditing = false
    picker.sourceType = .photoLibrary
    picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
    //show photolibrary
    present(picker, animated: true, completion: nil)
    
    //function for when the user selects an image
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
    
    //creates variable for the chosen image
    var chosenImage = UIImage()
    //save image into variable
    print(info)
    chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
    //update image view
    profilepictureimage.image = chosenImage
    //dismiss
    dismiss(animated: true, completion: nil)
    }
    
    //what happens when the user hits cancel
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
    dismiss(animated: true, completion: nil)
    }
    }
    
    
    
    
    func loadProfileData(){
        
    }
    
}

    
    


