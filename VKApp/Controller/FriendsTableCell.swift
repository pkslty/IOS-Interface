//
//  friendsTableCell.swift
//  VKApp
//
//  Created by Denis Kuzmin on 05.04.2021.
//

import UIKit

class FriendsTableCell: UITableViewCell {

    @IBOutlet weak var cellText: UILabel!
    @IBOutlet weak var avatarImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        //super.setSelected(!selected, animated: animated)


    }

}
