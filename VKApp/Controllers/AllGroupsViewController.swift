//
//  AllGroupsViewController.swift
//  VKApp
//
//  Created by Denis Kuzmin on 16.04.2021.
//

import UIKit

class AllGroupsViewController: UIViewController, UITableViewDelegate {

    struct Section {
        var sectionName: Character
        var rows: [Int]
    }
    
    @IBOutlet weak var groupsTable: UITableView!
    
    var groups: [Group]?
    
    var sections = [Section]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //searchBar.delegate = self
        getGroups()
        fillSections()

    }

    
    private func getGroups() {
        if groups == nil {
            groups = [Group]()
            groups?.append(Group(name: "Группа номер один", avatar: nil, description: "Описание группы"))
            groups?.append(Group(name: "Вторая группа", avatar: nil, description: "Описание группы"))
            groups?.append(Group(name: "Другая", avatar: nil, description: "Описание группы"))
            groups?.append(Group(name: "Ещё одна", avatar: nil, description: "Описание группы"))
            groups?.append(Group(name: "Тестовая группа", avatar: nil, description: "Описание группы"))
            groups?.append(Group(name: "Сюда надо вступить", avatar: nil, description: "Описание группы"))
            groups?.append(Group(name: "Эта для проверки поиска", avatar: nil, description: "Описание группы"))
            groups?.append(Group(name: "И эта", avatar: nil, description: "Описание группы"))
            groups?.append(Group(name: "  С разными;разделителями", avatar: nil, description: "Описание группы"))
            groups?.append(Group(name: "Очень:много;разных,разделителей   ", avatar: nil, description: "Описание группы"))
            groups?.append(Group(name: "Последняя группа", avatar: nil, description: "Описание группы"))
            
            groups?[1].avatar = UIImage(named: "group01")
            groups?[3].avatar = UIImage(named: "group02")
            groups?[5].avatar = UIImage(named: "group03")
        }
    }
    
    private func fillSections() {
        
        sections = [Section]()
        
        let section = Section(sectionName: "1", rows: [Int]())
        sections.append(section)
        if let count = groups?.count {
            for i in 0 ..< count {
                sections[0].rows.append(i)
            }
        }
    }
    
    private func filterRows(by keyword: String) {
        //Remove leading spaces
        fillSections()
        var filtered = [Section]()
        let keyword = keyword.trimmingCharacters(in: .whitespaces).lowercased()
        print("keyword: \(keyword) count: \(keyword.count)")
        guard keyword.count > 0
        else {
            groupsTable.reloadData()
            return
        }
        
        for (i, section) in sections.enumerated() {
            filtered.append(Section(sectionName: section.sectionName, rows: [Int]()))
            for row in section.rows {
                
                if let string = groups?[row].name {
                    if !keyword.contains(" ") {
                        let words = string.lowercased().components(separatedBy: " ")
                        print(words)
                        for word in words {
                            if word.contains(keyword) {
                                if word.first == keyword.first {
                                    //print("Found! keyword \(keyword) == word \(word) in string \(string)")
                                    filtered[i].rows.append(row)
                                    
                                    break
                                }
                            }
                        }
                    }
                    else if string.trimmingCharacters(in: .whitespaces).lowercased().contains(keyword) {
                        filtered[i].rows.append(row)
                        break
                    }
                }
                
            }
            print(filtered)
            sections = filtered
            groupsTable.reloadData()
        }
    }
    
}

extension AllGroupsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {

        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
        return sections[section].rows.count
    }


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "GroupCell", for: indexPath) as? GroupCell,
              let groups = groups
        else { return UITableViewCell() }
        let num = sections[indexPath.section].rows[indexPath.row]
        cell.groupCellText.text = groups[num].name
        cell.config(name: groups[num].name,
                    avatar: (groups[num].avatar ?? UIImage(systemName: "person.3.fill"))!,
                     description: groups[num].description)

        return cell
    }
    
    
}

extension AllGroupsViewController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        //добавить инсеты под клавиату
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let searchtext = searchBar.text else { return }
        filterRows(by: searchtext)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //убрать клавиатуру
     }
    
    
}
