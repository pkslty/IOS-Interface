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
    
    var model = ["Add", "Foo","SSs","ddDD","fFFfF","GGGG","jjjjjj","KKKKkk","LLLLll","ZZZZZ","xxxxx","ccccc","vvvvv","BBBBB","Nnnnn","Mmmmmmm","qqqqq","WWWWW","eeeeeee","RRRRRRRRRRR","TTTTTTT","YYYYYYY","UUUU","IIIIIII<","oo","pp", "e", "Woo", "900", "11111","2222","3333","4444","5555","666666","77777","8888888","9999","((((((","Xmm", "#&^", "Woo", "100", "Ух", "зво", "Aй", "Аъ", "Бэ", "Вэ","Гэ","Дэ","Ее","Ёе","Жэ","Зэ","Ии","Кэ","tц","Мэ","Нэ","Оу","Пэ","mц","Сэ","Тэ","Ух","Фэ","Хэ","Цэ","Че","Шэ","Ще","Ээ","Юу","Яа"]
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
        for (i, s) in user!.friends.enumerated() {
            let ch = Character(user!.friends[i].name.first!.uppercased()).isLetter ?
                Character(user!.friends[i].name.first!.uppercased()) : "#"
            
            print("i = \(i) s = \(s) ch = \(ch)")
            if let num = friends.firstIndex(where: {friendsection in friendsection.sectionName == ch}) {
                friends[num].friendsList.append(i)
            } else {
                friends.append(friendsSection(sectionName: ch, friendsList: [i]))
                categoriesPicker.categories.append(String(ch))
            }
        }
        print(friends)
        
        categoriesPicker.addTarget(self, action: #selector(categoriesPickerValueChanged(_:)),
                              for: .valueChanged)
        //categoriesPicker.style = .all
        
    }
    
    @objc func categoriesPickerValueChanged(_ categoriesPicker: CategoriesPicker) {
        let value = categoriesPicker.pickedCategory
        print("Value changed: \(value)")
        let indexPath = IndexPath(row: 0, section: value)
        friendTable.scrollToRow(at: indexPath, at: .top, animated: false)
        //let generator = UIImpactFeedbackGenerator(style: .soft)
        //generator.impactOccurred()
    }    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if segue.identifier == "showFriendPhotos" {
            guard let destinationVC = segue.destination as? FriendView else { return }
            destinationVC.friend = user?.friends[friends[friendTable.indexPathForSelectedRow!.section].friendsList[friendTable.indexPathForSelectedRow!.row]]
            destinationVC.username = user?.name
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
        cell.config(name: user!.friends[num].name,
                    avatar: user!.friends[num].avatar ?? UIImage(systemName: "person.fill.questionmark.rtl"))

        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return String(friends[section].sectionName)
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

extension FriendsViewController: LikeButtonProtocol {
    
    func updateLike(likes: Int, tag: Int, like: Bool) {
        user?.friends[friendTable.indexPathForSelectedRow!.row].photos[tag].likes = likes
        //print(self.tableView.indexPathForSelectedRow)
        let username = user!.name
        if like {
            user?.friends[friendTable.indexPathForSelectedRow!.row].photos[tag].likers.insert(username)
        } else {
            user?.friends[friendTable.indexPathForSelectedRow!.row].photos[tag].likers.remove(username)
        }
        //print(friend?.photos[tag])
    }
}
