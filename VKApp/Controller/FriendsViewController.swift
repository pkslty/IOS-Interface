//
//  FriendsViewController.swift
//  VKApp
//
//  Created by Denis Kuzmin on 12.04.2021.
//

import UIKit

class FriendsViewController: UIViewController, UITableViewDelegate {

    @IBOutlet weak var friendTable: UITableView!
    @IBOutlet weak var categoriesPicker: CategoriesPicker!
    
    var user: User?
    
    var categories = [String]()
    
    struct friendsSection {
        var sectionName: Character
        var friendsList: [Int]
    }
    
    var friends = [friendsSection]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.user != nil {
            getFriends(ofUser: &self.user!)
        }
        
        user!.friends = user!.friends.sorted(by: <)
        
        for i in 0 ..< user!.friends.count {
            let ch = Character(user!.friends[i].lastname.first!.uppercased()).isLetter ?
                Character(user!.friends[i].lastname.first!.uppercased()) : "#"
            
            if let num = friends.firstIndex(where: {friendsection in friendsection.sectionName == ch}) {
                friends[num].friendsList.append(i)
            } else {
                friends.append(friendsSection(sectionName: ch, friendsList: [i]))
                categoriesPicker.categories.append(String(ch))
            }
        }
        
        categoriesPicker.addTarget(self, action: #selector(categoriesPickerValueChanged(_:)),
                              for: .valueChanged)
        
    }
    
    @objc func categoriesPickerValueChanged(_ categoriesPicker: CategoriesPicker) {
        let value = categoriesPicker.pickedCategory
        let indexPath = IndexPath(row: 0, section: value)
        friendTable.scrollToRow(at: indexPath, at: .top, animated: false)
        //let generator = UIImpactFeedbackGenerator(style: .soft)
        //generator.impactOccurred()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if segue.identifier == "showFriendPhotos" {
            guard let destinationVC = segue.destination as? FriendView else { return }
            destinationVC.friendNum = friends[friendTable.indexPathForSelectedRow!.section].friendsList[friendTable.indexPathForSelectedRow!.row]
            destinationVC.friend = user?.friends[destinationVC.friendNum!]
            destinationVC.username = user?.username
        }
    }
}

extension FriendsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return friends[section].friendsList.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return friends.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FriendsTableCell", for: indexPath) as? FriendsTableCell
        else { return UITableViewCell()}
        
        let num = friends[indexPath.section].friendsList[indexPath.row]
        cell.config(name: user!.friends[num].fullname,
                    avatar: user!.friends[num].avatar ?? UIImage(systemName: "person.fill.questionmark.rtl"))

        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return String(friends[section].sectionName)
    }

    private func getFriends(ofUser user: inout User) {
        
       user.friends.append(Person(firstname: "Вадим", lastname: "Рощин",
                                   avatar: UIImage(named: "thumb-1")))
       
        user.friends.append(Person(firstname: "Илья", lastname: "Шумихин",
                                   avatar: UIImage(named: "thumb-2")))
        
        user.friends.append(Person(firstname: "Александр", lastname: "Ковалев",
                                   avatar: UIImage(named: "thumb-3")))

        user.friends.append(Person(firstname: "Георгий", lastname: "Сабанов",
                                   avatar: UIImage(named: "thumb-4")))

        user.friends.append(Person(firstname: "Николай", lastname: "Родионов",
                                   avatar: UIImage(named: "thumb-5")))

        user.friends.append(Person(firstname: "Александр", lastname: "Федоров",
                                   avatar: UIImage(named: "thumb-6")))

        user.friends.append(Person(firstname: "Андрей", lastname: "Антропов",
                                   avatar: UIImage(named: "thumb-7")))
        
        user.friends.append(Person(firstname: "Евгений", lastname: "Елчев",
                                   avatar: UIImage(named: "thumb-8")))
        user.friends.append(Person(firstname: "Владислав", lastname: "Фролов",
                                   avatar: UIImage(named: "thumb-9")))
        user.friends.append(Person(firstname: "Максим", lastname: "Пригоженков",
                                   avatar: UIImage(named: "thumb-10")))
        user.friends.append(Person(firstname: "Никита", lastname: "Филонов",
                                   avatar: UIImage(named: "thumb-11")))
        user.friends.append(Person(firstname: "Олег", lastname: "Иванов"))
        user.friends.append(Person(firstname: "Алексей", lastname: "Усанов",
                                   avatar: UIImage(named: "thumb-13")))
        user.friends.append(Person(firstname: "Станислав", lastname: "Иванов",
                                   avatar: UIImage(named: "thumb-14")))
        user.friends.append(Person(firstname: "Алёна", lastname: "Козлова",
                                   avatar: UIImage(named: "thumb-15")))
        user.friends.append(Person(firstname: "Кирилл", lastname: "Лукьянов",
                                   avatar: UIImage(named: "thumb-16")))
        user.friends.append(Person(firstname: "Анатолий", lastname: "Пешков",
                                   avatar: UIImage(named: "thumb-17")))
        user.friends.append(Person(firstname: "Леонид", lastname: "Нифантьев"))
        //user.friends.append(Person(firstname: "A", lastname: "A"))
        //user.friends.append(Person(firstname: "B", lastname: "B"))
        //user.friends.append(Person(firstname: "C", lastname: "C"))
        
        user.friends.append(Person(firstname: "Вячеслав", lastname: "Кирица",
                                   avatar: UIImage(named: "thumb-19")))
        user.friends.append(Person(firstname: "Алексей", lastname: "Кудрявцев",
                                   avatar: UIImage(named: "thumb-20")))
        user.friends.append(Person(firstname: "Юрий", lastname: "Султанов",
                                   avatar: UIImage(named: "thumb-21")))
        user.friends.append(Person(firstname: "Егор", lastname: "Петров",
                                   avatar: UIImage(named: "thumb-22")))
        //user.friends.append(Person(firstname: "Родион", lastname: "Молчанов"))
        user.friends.append(Person(firstname: "Станислав", middlename: "Дмитриевич", lastname: "Белых",
                                   avatar: UIImage(named: "thumb-24")))
        user.friends.append(Person(firstname: "Антон", lastname: "Марченко",
                                   avatar: UIImage(named: "thumb-25")))
        
                                   
        user.friends[0].photos.append((UIImage(named: "man01")!, 0, Set<String>()))
        user.friends[0].photos[0].likes = 87
        user.friends[0].photos[0].likers.insert("admin")
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

