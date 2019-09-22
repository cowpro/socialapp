//
//  postCell.swift
//  socialapp
//
//  Created by Kian Chakamian on 6/19/19.
//  Copyright © 2019 Kian Chakamian. All rights reserved.
//

import UIKit

protocol postCellDelegate {
    func like()
    func comment()
    func share()
}

class postCell: UITableViewCell {
    @IBOutlet weak var postedImageView: UIImageView!
    @IBOutlet weak var captionTextLabel: UILabel!
    //DO
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var profileLabel: UILabel!
    @IBOutlet weak var username: UILabel!
    
    @IBOutlet weak var likeCount: UILabel!
    
    var delegate: postCellDelegate?
    
    @IBAction func likeButtonTapped(_ sender: Any) {
        delegate?.like()
    }
    @IBAction func commentButtonTapped(_ sender: Any) {
        delegate?.comment()
    }
    @IBAction func shareButtonTapped(_ sender: Any) {
        delegate?.share()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension UIResponder {
    
    func next<T: UIResponder>(_ type: T.Type) -> T? {
        return next as? T ?? next?.next(type)
    }
}

extension UITableViewCell {
    
    var tableView: UITableView? {
        return next(UITableView.self)
    }
    
    var indexPath: IndexPath? {
        return tableView?.indexPath(for: self)
    }
}
