//
//  FriendView.swift
//  VKApp
//
//  Created by Denis Kuzmin on 06.04.2021.
//

import UIKit

class FriendView: UICollectionViewController {

    var friend: Person?
    var likeDelegate: LikeButtonProtocol?
    var username: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //print(friend)
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "friendPhoto")
        //print(self.parent?.next)
        

    }



    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return (friend?.photos.count)!
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FriendPhoto", for: indexPath) as? FriendPhoto
        else { return UICollectionViewCell() }
        
        print(friend?.photos[indexPath.row].likers.contains(username!))
        cell.config(image: (friend?.photos[indexPath.row].image)!,
                    likes: (friend?.photos[indexPath.row].likes)!,
                    tag: indexPath.row,
                    state: (friend?.photos[indexPath.row].likers.contains(username!))!,
                    delegate: likeDelegate!)
    
        return cell
    }
}


