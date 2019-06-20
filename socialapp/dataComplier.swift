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
    var returnData: Array<Any> = []
    for follow in following {
        let refr = Database.database().reference(withPath: "/users/\(follow)/")
        refr.observeSingleEvent(of: .value, with: { (snapshot) in
            let values = snapshot.value as! NSDictionary
            let postID = values["currentPostNumber"] as! Int
            var count: Int = 0
            if (postID > 1) {
                count = postID - 1
            }
            for index in 0...count {
                let ref = Database.database().reference(withPath: "/posts/\(follow)/\(index)/")
                ref.observeSingleEvent(of: .value, with: { (snapshot) in
                    let value = snapshot.value as! NSDictionary
                    let captions = value["caption"] as! String
                    let pathToUserImg = value["userImg"] as! String
                    let refre = Storage.storage().reference(withPath: "\(pathToUserImg)")
                    refre.getData(maxSize: 1 * 1024 * 1024) { (data, error) in
                        let image = UIImage(data: data!) as Any
                        let insertIntoArray = [index, captions, image]
                        returnData.append(insertIntoArray)
                        if (index == count) {
                            completionHandler(returnData as NSArray)
                        }
                    }
                })
            }
        })
    }
}
