//
//  NewsViewController.swift
//  VKApp
//
//  Created by Denis Kuzmin on 17.04.2021.
//

import UIKit

class NewsViewController: UIViewController, UICollectionViewDelegate{

    @IBOutlet weak var newsCollection: UICollectionView!
    var posts = [Post]()
    var postIsCollapsed = [Bool]()
    var cellType = [Int: Int]()
    //Dictionary for cells types:
    var cellsTypes = [Int: [Int: Int]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getPosts()
        
        newsCollection.register(UINib(nibName: "NewsAuthorCell", bundle: nil), forCellWithReuseIdentifier: "NewsAuthorCell")
        newsCollection.register(UINib(nibName: "NewsTextCell", bundle: nil), forCellWithReuseIdentifier: "NewsTextCell")
        newsCollection.register(UINib(nibName: "NewsImageCell", bundle: nil), forCellWithReuseIdentifier: "NewsImageCell")
        newsCollection.register(UINib(nibName: "NewsActionsCell", bundle: nil), forCellWithReuseIdentifier: "NewsActionsCell")
        
        
        
        // Do any additional setup after loading the view.
    }
    

    private func getPosts() {
        posts.append(Post(author: Person(firstname: "Иван", lastname: "Иванов"), date: DateComponents(), text: "vfrevnjiovfrnejvongjreiovnjgrienovjonjviorejnviogrenvjgiore", images: [UIImage(named: "man01")!, UIImage(named: "man02")!, UIImage(named: "man03")!, UIImage(named: "man04")!]))
        posts.append(Post(author: Person(firstname: "Петр", lastname: "Петров"), date: DateComponents(), text: "vnjojiovnejtivontjrivontjerivotnjviotrnvitoewvytivnbehwionvruvhr", images: [UIImage(named: "man02")!]))
    }

}

extension NewsViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //Минимум: Автор и количество лайков:
        var cellType = [Int: Int]()
        var numberOfItems = 2
        cellType[0] = 0 //author
        if posts[section].text != nil {
            numberOfItems += 1
            cellType[1] = 1 //text
        }
        if posts[section].isCollapsed {
            switch posts[section].images.count {
            case 1:
                numberOfItems += 1
            case 2, 3:
                numberOfItems += 2

            case let count where count >= 4:
                numberOfItems += 4
            default:
                break
            }
        } else {
            numberOfItems += posts[section].images.count
        }
        cellType[numberOfItems - 1] = 3 //actions
        for i in 2 ..< numberOfItems-1 {
            cellType[i] = 2 //image
        }
        cellsTypes[section] = cellType
        print(cellsTypes)
        return numberOfItems
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print(indexPath)
        guard let celltype = cellsTypes[indexPath.section]?[indexPath.row]
        else { return UICollectionViewCell()}
        switch celltype {
        case 0:
            guard let cell = newsCollection.dequeueReusableCell(withReuseIdentifier: "NewsAuthorCell", for: indexPath) as? NewsAuthorCell
            
            else { return UICollectionViewCell() }
            
            cell.configure(image: posts[indexPath.section].images[0], name: posts[indexPath.section].author.fullname, date: Date())
            
            return cell
        case 1:
            guard let cell = newsCollection.dequeueReusableCell(withReuseIdentifier: "NewsTextCell", for: indexPath) as? NewsTextCell
                
            else { return UICollectionViewCell() }
                
            cell.configure(text: posts[indexPath.section].text!)
                
            return cell
            
        case 2:
            guard let cell = newsCollection.dequeueReusableCell(withReuseIdentifier: "NewsImageCell", for: indexPath) as? NewsImageCell
            
            else { return UICollectionViewCell() }
            let rowdecr = posts[indexPath.section].text == nil ? 1 : 2
            cell.configure(image: posts[indexPath.section].images[indexPath.row - rowdecr])
            
            return cell
        case 3:
            guard let cell = newsCollection.dequeueReusableCell(withReuseIdentifier: "NewsActionsCell", for: indexPath) as? NewsActionsCell
            
            else { return UICollectionViewCell() }
            
            cell.configure(likes: 10, tag: 1, state: true)
            
            return cell
        default:
            break
        }
        return UICollectionViewCell()
    }
    
    
}
