//
//  Person.swift
//  VKApp
//
//  Created by Denis Kuzmin on 05.04.2021.
//

import UIKit

struct Person {
    var name: String
    var avatar: UIImage?
    var photos = [(image: UIImage,likes: UInt)]()
    var posts = [Post]()
}
