//
//  AllGroupsViewController.swift
//  VKApp
//
//  Created by Denis Kuzmin on 06.04.2021.
//

import UIKit



class AllGroupsViewController: UITableViewController {

    var groups: [Group]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getGroups()

    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {

        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
        return groups?.count ?? 0
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewGroupCell", for: indexPath) as? NewGroupCell
        cell?.groupCellText.text = groups?[indexPath.row].name
        

        return cell!
    }

    
    private func getGroups() {
        if groups == nil {
            groups = [Group]()
            for i in 1...10 {
                groups?.append(Group(name: "Group \(i)", description: "A Group number \(i)"))
            }
            groups?[1].avatar = UIImage(named: "group01")
            groups?[3].avatar = UIImage(named: "group02")
            groups?[5].avatar = UIImage(named: "group03")
            
        }
        
    }
    
}
