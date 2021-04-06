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
        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendsTableCell", for: indexPath) as? FriendsTableCell

        cell?.cellText.text = user?.friends[indexPath.row].name
        cell?.avatarImage.image = user?.friends[indexPath.row].avatar ??
            UIImage(systemName: "person.fill.questionmark.rtl")

        return cell!
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if let viewController = segue.destination as? FriendView {
            viewController.friend = user?.friends[self.tableView.indexPathForSelectedRow!.row]
        }
    }


    
    private func getFriends(ofUser user: inout User) {
        
        user.friends.append(Person(name: "Ivan"))
       
        user.friends.append(Person(name: "Petr"))
        
        user.friends.append(Person(name: "Andrey"))

        user.friends.append(Person(name: "Anna"))

        user.friends.append(Person(name: "Nadya",
                                   avatar: UIImage(named: "woman01")))

        user.friends.append(Person(name: "Fedor",
                                   avatar: UIImage(named: "man01")))

        user.friends.append(Person(name: "Alexey"))
                                   
        user.friends[0].photos.append(UIImage(named: "man01")!)
        user.friends[1].photos.append(UIImage(named: "man02")!)
        user.friends[2].photos.append(UIImage(named: "man03")!)
        user.friends[3].photos.append(UIImage(named: "woman01")!)
        user.friends[4].photos.append(UIImage(named: "woman02")!)
        user.friends[5].photos.append(UIImage(named: "man04")!)
        user.friends[6].photos.append(UIImage(named: "man05")!)
        
        user.friends[1].photos.append(UIImage(named: "man01")!)
        user.friends[1].photos.append(UIImage(named: "man03")!)
        user.friends[1].photos.append(UIImage(named: "woman01")!)
        user.friends[1].photos.append(UIImage(named: "woman02")!)
        user.friends[1].photos.append(UIImage(named: "man04")!)
        user.friends[1].photos.append(UIImage(named: "man05")!)
    }

}
