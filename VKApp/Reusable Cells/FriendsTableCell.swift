//
//  friendsTableCell.swift
//  VKApp
//
//  Created by Denis Kuzmin on 05.04.2021.
//

import UIKit

class FriendsTableCell: UITableViewCell {

   
    @IBOutlet weak var friendName: UILabel!
    
    
    @IBOutlet weak var avatarImage: RoundShadowView!
    
    
    func config(name: String?, avatar: UIImage?) {
        friendName.text = name
        avatarImage.shadowColor = UIColor.blue.cgColor
        avatarImage.image = avatar
    }
}
