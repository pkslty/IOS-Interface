//
//  friendsTableCell.swift
//  VKApp
//
//  Created by Denis Kuzmin on 05.04.2021.
//

import UIKit

class FriendsTableCell: UITableViewCell {

    @IBOutlet weak var cellText: UILabel!
    
    @IBOutlet weak var avatarImage: RoundShadowView!
    
    func config(name: String?, avatar: UIImage?) {
        cellText.text = name
        avatarImage.shadowColor = UIColor.blue.cgColor
        avatarImage.image = avatar
    }
}
