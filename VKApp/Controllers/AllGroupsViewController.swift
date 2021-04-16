//
//  AllGroupsViewController.swift
//  VKApp
//
//  Created by Denis Kuzmin on 16.04.2021.
//

import UIKit

class AllGroupsViewController: UIViewController, UITableViewDelegate {

    
    @IBOutlet weak var groupsTable: UITableView!
    
    var groups: [Group]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getGroups()

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

extension AllGroupsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {

        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
        return groups?.count ?? 0
    }


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewGroupCell", for: indexPath) as? NewGroupCell
        cell?.groupCellText.text = groups?[indexPath.row].name
        

        return cell!
    }
}
