//
//  FriendPhoto.swift
//  VKApp
//
//  Created by Denis Kuzmin on 06.04.2021.
//

import UIKit

class FriendPhoto: UICollectionViewCell {
    
    @IBOutlet weak var likeButton: LikeButton!
    @IBOutlet weak var photo: UIImageView!
    
    func config(image: UIImage, likes: Int, tag: Int, state: Bool, delegate: LikeButtonProtocol) {
        likeButton.likes = likes
        photo.image = image
        likeButton.tag = tag
        likeButton.like = state
        likeButton.delegate = delegate
    }
    
}
