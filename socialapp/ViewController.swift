//
//  ViewController.swift
//  socialapp
//
//  Created by Kian Chakamian on 5/12/19.
//  Copyright © 2019 Kian Chakamian. All rights reserved.
//

//MARK: Imports
import UIKit
import Firebase
import SwiftKeychainWrapper

class ViewController: UIViewController {
    //MARK: Refrences
    @IBOutlet weak var userImgView: UIImageView!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var addImgButton: UIButton!
    @IBOutlet weak var errorDisplay: UILabel!
    @IBOutlet weak var signInSignUp: UIButton!
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet weak var fullName: UITextField!
    var imagePicker: UIImagePickerController!
    var selectedImage: UIImage!
    
    //MARK: Helper Functions
    @IBAction func unwindToVC1(segue:UIStoryboardSegue) {
        self.reset()
    }
    func setError(errorMes: String) {
        errorDisplay.text = errorMes
    }
    func reset() {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        errorDisplay.text = nil
        usernameField.isHidden = true
        addImgButton.isHidden = true
        fullName.isHidden = true
        usernameField.text = nil
        emailField.text = nil
        passwordField.text = nil
        userImgView.image = nil
        fullName.text = nil
    }
    func setupUser(userUid: String, username: String, fullName: String) {
        if let data = self.userImgView.image!.jpegData(compressionQuality: 0.2) {
            let storageRef = Storage.storage().reference(withPath: "myPics/\(userUid).jpeg")
            let uploadMetadata = StorageMetadata()
            uploadMetadata.contentType = "imgage/jpeg"
            storageRef.putData(data, metadata: uploadMetadata) { (metadata, error) in
                if(error != nil) {
                    print("I recived an error! \(error?.localizedDescription ?? "ERROR")")
                } else {
                    print("Upload Complete! \(String(describing: metadata))")
                }
                let userData = [
                    "username": self.usernameField.text as Any,
                    "fullname": self.fullName.text as Any,
                    "email": self.emailField.text as Any,
                    "password": self.passwordField.text as Any,
                    "userImg": "myPics/\(userUid).jpeg" as Any,
                    "ID": userUid as Any
                    ] as [String : Any]
                Database.database().reference().child("users").child(userUid).setValue(userData)
            }
        }
    }
    
    //MARK: Override Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        scrollView.isScrollEnabled = false
        self.reset()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(false)
        if let _ = KeychainWrapper.standard.string(forKey: "uid") {
            self.performSegue(withIdentifier: "toFeed", sender: nil)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: IBAction Functions
    @IBAction func signInPressed(_ sender: Any) {
        if !(emailField.text?.count ?? 0 > 0) {
            self.setError(errorMes: "Please enter an email")
            return
        } else if !(passwordField.text?.count ?? 0 > 0) {
            self.setError(errorMes: "Please enter a password")
            return
        } else {
            if let email = emailField.text?.lowercased(), let password = passwordField.text {
                Auth.auth().signIn(withEmail: email, password: password) { user, error in
                    print(error as Any)
                    if ((error) != nil) {
                        if (error!._code == 17011) {
                            self.setError(errorMes: "")
                            self.usernameField.isHidden = false
                            self.addImgButton.isHidden = false
                            self.fullName.isHidden = false
                            self.signInSignUp.setTitle("Sign Up", for: .normal)
                        } else {
                            switch error!._code {
                                case (17008): self.setError(errorMes: "Please use a valid email!")
                                case (17005): self.setError(errorMes: "Your account has been disabled!")
                                case (17009): self.setError(errorMes: "Incorrect password!")
                                default: self.setError(errorMes: "Unknown error occured. Please try again")
                            }
                                return
                            }
                        }
                    if !(self.usernameField.text?.count ?? 0 > 0) {
                        self.setError(errorMes: "Please enter a username!")
                        return
                    } else if (self.userImgView.image == nil) {
                        self.setError(errorMes: "Please enter select a photo!")
                        return
                    } else if !(self.fullName.text?.count ?? 0 > 0) {
                        self.setError(errorMes: "Please enter your name!")
                    } else if error != nil && !(self.usernameField.text?.isEmpty)! && !(self.fullName.text?.isEmpty)!{
                        let username = self.usernameField.text!
                        let fullname = self.fullName.text!
                        Auth.auth().createUser(withEmail: email.lowercased(), password: password) { (user, error) in
                            print(error as Any)
                            if ((error) != nil) {
                                switch error!._code {
                                    case (17008): self.setError(errorMes: "Please use a valid email!")
                                    case (17026): self.setError(errorMes: "Password must be 6 charecters long or more!")
                                    case (17007): self.setError(errorMes: "Email already taken!")
                                    default: self.setError(errorMes: "Unknown Error Occured. Please Try Again")
                                }
                                return
                            }
                            let userID = (user?.user.uid)!
                            self.setupUser(userUid: userID, username: username, fullName: fullname)
                            KeychainWrapper.standard.set(userID, forKey: "uid")
                            self.performSegue(withIdentifier: "toFeed", sender: nil)
                        }
                    } else {
                        if let userID = (user?.user.uid) {
                            KeychainWrapper.standard.set((userID), forKey: "uid")
                            self.performSegue(withIdentifier: "toFeed", sender: nil)
                        }
                    }
                }
            }
        }
    }
    @IBAction func getPhoto (_ sender: AnyObject) {
        present(imagePicker, animated: true, completion: nil)
    }
}

//MARK: Extension Functions
extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    internal func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            userImgView.image = image
        } else {
            setError(errorMes: "Image wasn't selected!")
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }
}
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
