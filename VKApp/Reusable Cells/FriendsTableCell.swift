//
//  friendsTableCell.swift
//  VKApp
//
//  Created by Denis Kuzmin on 05.04.2021.
//

import UIKit

class FriendsTableCell: UITableViewCell {

    @IBOutlet weak var avatarSize: NSLayoutConstraint!
    
    @IBOutlet weak var friendName: UILabel!
    
    
    @IBOutlet weak var avatarImage: RoundShadowView!
    
    
    func config(name: String?, avatar: UIImage?) {
        friendName.text = name
        avatarImage.shadowColor = UIColor.blue.cgColor
        avatarImage.image = avatar
        
        let gestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(avatarTap))
        gestureRecognizer.minimumPressDuration = 0.2
        avatarImage.addGestureRecognizer(gestureRecognizer)
        
    }
    
    @objc func avatarTap() {
        print("avatarTap")
        //avatarImage.springAnimateBounds(duration: 2, scale: 0.4)
        
        //avatarImage.frame = rect
        avatarSize.constant = 66
        
    }
}
