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
    var dataArray: NSArray = []
    
    func getDataFromAPI(following: Array<String>) {
        //Call your api function here
        gatherData(following: following) { results in
            self.dataArray = results
            self.tableView.reloadData() //Then reload your tableView
        }
    }
    
    @IBAction func backToFeed(segue:UIStoryboardSegue) {
    }
    
    override func viewDidLoad() {
        dataArray = []
        self.getDataFromAPI(following: ["09IPDwPtrKSwn2f5TBccLveUj342"])
        super.viewDidLoad()
        self.tabBarController!.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Sign Out", style: .plain, target: self, action: #selector(signOut))
        self.tabBarController!.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "+", style: .plain, target: self, action: #selector(create))
        self.tabBarController!.navigationItem.title = "Fifer"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
//        self.getDataFromAPI(following: ["UwaITPZP1nUY6M2Tht3cPLau8Du1"])
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cellPost", for: indexPath) as? postCell else { fatalError() }
        let post = dataArray[indexPath.row] as! Array<Any>
        print(dataArray)
        cell.captionTextLabel.text = (post[1] as! String)
        cell.postedImageView.image = (post[2] as! UIImage)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 322
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
    @objc func create(_ sender: AnyObject) {
        performSegue(withIdentifier: "toCreate", sender: self)
    }
}
