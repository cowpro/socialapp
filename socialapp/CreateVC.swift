//
//  CreateVC.swift
//  socialapp
//
//  Created by Kian Chakamian on 6/7/19.
//  Copyright © 2019 Kian Chakamian. All rights reserved.
//

import UIKit
import Firebase

class CreateVC: UIViewController, UITextViewDelegate {
    @IBOutlet weak var userImgView: UIImageView!
    @IBOutlet weak var captext: UITextView!
    var imagePicker: UIImagePickerController!
    var selectedImage: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.delegate = self as  UIImagePickerControllerDelegate & UINavigationControllerDelegate
        let nav = self.navigationController?.navigationBar
        nav?.barStyle = UIBarStyle.black
        nav?.tintColor = UIColor.yellow
        navigationItem.title = "Create Post"
        captext.delegate = self as UITextViewDelegate
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(false)
        userImgView.image = selectedImage
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    @IBAction func getPhoto(_ sender: AnyObject) {
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func createPost(_ sender: Any) {
        uploadToFirebase()
    }
    func uploadToFirebase() {
        let userUid = Auth.auth().currentUser!.uid
        let ref = Database.database().reference(withPath: "/users/\(userUid)/")
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            print (snapshot.key)
            let value = snapshot.value as! NSDictionary
            var postID = value["currentPostNumber"] as! Int
            if let data = self.userImgView.image!.jpegData(compressionQuality: 0.2) {
                let storageRef = Storage.storage().reference(withPath: "/posts/\(String(describing: userUid))/\(postID).jpeg")
                let uploadMetadata = StorageMetadata()
                uploadMetadata.contentType = "imgage/jpeg"
                storageRef.putData(data, metadata: uploadMetadata) { (metadata, error) in
                    let userData = [
                        "caption": self.captext.text as String,
                        "userImg": "/posts/\(String(describing: userUid))/\(postID).jpeg" as String,
                        "ID": "\(userUid)"
                        ] as [String : String]
                    Database.database().reference().child("posts").child("\(String(describing: userUid))").child("\(postID)").setValue(userData)
                }
            }
            ref.updateChildValues([
                "currentPostNumber": postID + 1
                ])
        })
    }
}
extension CreateVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    internal func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            userImgView.image = image
            selectedImage = image
        } else {
            print("Image wasn't selected!")
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }
}
