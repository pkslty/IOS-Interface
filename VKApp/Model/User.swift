//
//  User.swift
//  VKApp
//
//  Created by Denis Kuzmin on 05.04.2021.
//

import UIKit

struct User {
    var name: String
    var login: String
    var password: String
    var friends = [Person]()
    var avatar: UIImage?
}
