//
//  FeedVC.swift
//  socialapp
//
//  Created by Kian Chakamian on 5/14/19.
//  Copyright © 2019 Kian Chakamian. All rights reserved.
//
import UIKit
import Firebase
import SwiftKeychainWrapper

class FeedVC: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nav = self.navigationController?.navigationBar
        nav?.barStyle = UIBarStyle.black
        nav?.tintColor = UIColor.yellow
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Sign Out", style: .plain, target: self, action: #selector(signOut))
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    @objc func signOut(_ sender: AnyObject) {
        KeychainWrapper.standard.removeObject(forKey: "uid")
        do {
            try Auth.auth().signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        performSegue(withIdentifier: "signOut", sender: self)
    }
}
