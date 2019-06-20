//
//  postCell.swift
//  socialapp
//
//  Created by Kian Chakamian on 6/19/19.
//  Copyright © 2019 Kian Chakamian. All rights reserved.
//

import UIKit

class postCell: UITableViewCell {
    @IBOutlet weak var postedImageView: UIImageView!
    @IBOutlet weak var captionTextLabel: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
