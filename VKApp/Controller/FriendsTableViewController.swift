//
//  FriendsTableViewController.swift
//  VKApp
//
//  Created by Denis Kuzmin on 05.04.2021.
//

import UIKit

class FriendsTableViewController: UITableViewController {

    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.user != nil {
            getFriends(ofUser: &self.user!)
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return (user?.friends.count) ?? 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FriendsTableCell", for: indexPath) as? FriendsTableCell
        else { return UITableViewCell()}

        cell.config(name: user?.friends[indexPath.row].firstname,
                    avatar: user?.friends[indexPath.row].avatar ??
                        UIImage(systemName: "person.fill.questionmark.rtl"))

        return cell
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if let viewController = segue.destination as? FriendView {
            viewController.friend = user?.friends[self.tableView.indexPathForSelectedRow!.row]
            viewController.username = user?.firstname
        }
    }


    
    private func getFriends(ofUser user: inout User) {
        
        user.friends.append(Person(firstname: "Ivan", lastname: "Ivanov"))
       
        user.friends.append(Person(firstname: "Petr", lastname: "Petrov"))
        
        user.friends.append(Person(firstname: "Andrey", lastname: "Andreev"))

        user.friends.append(Person(firstname: "Anna", lastname: "Annova"))

        user.friends.append(Person(firstname: "Nadya", lastname: "TheHope",
                                   avatar: UIImage(named: "woman01")))

        user.friends.append(Person(firstname: "Fedor", lastname: "Fedorov",
                                   avatar: UIImage(named: "man01")))

        user.friends.append(Person(firstname: "Alexey", lastname: "Alexeev"))
                                   
        user.friends[0].photos.append((UIImage(named: "man01")!, 0, Set<String>()))
        user.friends[0].photos[0].likes = 87
        user.friends[0].photos[0].likers.insert("Admin")
        user.friends[1].photos.append((UIImage(named: "man02")!, 0, Set<String>()))
        
        user.friends[2].photos.append((UIImage(named: "man03")!, 0, Set<String>()))
        user.friends[3].photos.append((UIImage(named: "woman01")!, 0, Set<String>()))
        user.friends[4].photos.append((UIImage(named: "woman02")!, 0, Set<String>()))
        user.friends[5].photos.append((UIImage(named: "man04")!, 0, Set<String>()))
        user.friends[6].photos.append((UIImage(named: "man05")!, 0, Set<String>()))
        
        user.friends[1].photos.append((UIImage(named: "man01")!, 0, Set<String>()))
        user.friends[1].photos.append((UIImage(named: "man03")!, 0, Set<String>()))
        user.friends[1].photos.append((UIImage(named: "woman01")!, 0, Set<String>()))
        user.friends[1].photos.append((UIImage(named: "woman02")!, 0, Set<String>()))
        user.friends[1].photos.append((UIImage(named: "man04")!, 0, Set<String>()))
        user.friends[1].photos.append((UIImage(named: "man05")!, 0, Set<String>()))
    }

}


