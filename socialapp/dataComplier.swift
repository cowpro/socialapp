//
//  dataComplier.swift
//  socialapp
//
//  Created by Kian Chakamian on 6/16/19.
//  Copyright © 2019 Kian Chakamian. All rights reserved.
//

import Foundation
import Firebase

//Params should be the user ID
func gatherData(following: Array<String>, completionHandler: @escaping (_ results: NSArray) -> ()) {
    var returnData = [[Any]]()
    for follow in following {
        let refr = Database.database().reference(withPath: "/users/\(follow)/")
        refr.observeSingleEvent(of: .value, with: { (snapshot) in
            let values = snapshot.value as! NSDictionary
            let postID = values["currentPostNumber"] as! Int
            let username = "@\(values["username"] as! String)"
            let fullName = values["fullname"] as! String
            var count: Int = 0
            if (postID > 1) {
                count = postID - 1
            }
            if count != 0 {
                for index in 0...count {
                    let ref = Database.database().reference(withPath: "/posts/\(follow)/\(index)/")
                    ref.observeSingleEvent(of: .value, with: { (snapshot) in
                        let value = snapshot.value as! NSDictionary
                        let captions = value["caption"] as! String
                        let pathToUserImg = value["userImg"] as! String
                        let likes = value["likes"] as! Int
                        let likedBy = value["likedBy"] as! Array<String>
                        let refre = Storage.storage().reference(withPath: "\(pathToUserImg)")
                        print(index, pathToUserImg, refre)
                        refre.getData(maxSize: 1 * 1656 * 1656) { (data, error) in
                            let initalImage = UIImage(data: data!)!
                            let image = resizeImage(image: initalImage, targetSize: CGSize(width: 414.0, height: 414.0))
                            let refren = Storage.storage().reference(withPath: "/myPics/\(follow).jpeg")
                            refren.getData(maxSize: 1 * 1656 * 1656) { (data, error) in
                                let initalImageTwo = UIImage(data: data!)!
                                let imageTwo = resizeImage(image: initalImageTwo, targetSize: CGSize(width: 60, height: 60))
                                let insertIntoArray = [index, captions, image, username, fullName, likes, imageTwo, likedBy] as [Any]
                                returnData.append(insertIntoArray)
                                if (returnData.count == postID) {
                                    let x = returnData.sorted(by: { ($0[0] as! Int) < ($1[0] as! Int) })
                                    completionHandler(x as NSArray)
                                }
                            }
                        }
                    })
                }
            }
        })
    }
}
