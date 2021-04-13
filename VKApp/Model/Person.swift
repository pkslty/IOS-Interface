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
    var photos = [(image: UIImage, likes: Int, likers: Set<String>)]()
    var posts = [Post]()
}

extension Person: Comparable {
    static func < (lhs: Person, rhs: Person) -> Bool {
        lhs.name < rhs.name
    }
    
    static func == (lhs: Person, rhs: Person) -> Bool {
        lhs.name == rhs.name
    }
    
    
}
