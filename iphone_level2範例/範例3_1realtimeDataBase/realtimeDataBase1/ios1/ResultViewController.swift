//
//  ResultViewController.swift
//  ios1
//
//  Created by 徐國堂 on 2017/11/6.
//  Copyright © 2017年 Gjun. All rights reserved.
//

import UIKit

class ResultViewController: UITableViewController {
    var names = [UserName]();
    var sourceNames:[UserName]!;
    
    override func viewDidLoad() {
        super.viewDidLoad();        
    }

   

}

extension ResultViewController{
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return names.count;
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath);
        cell.textLabel?.text = names[indexPath.row].name;
        return cell;
    }
}

extension ResultViewController:UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController){
        let searchBar = searchController.searchBar;
        let searchWorld = searchBar.text!;
        /*
        names = sourceNames.filter({ (name:String) -> Bool in
            return name.contains(searchWorld);
        })
 */
        names = sourceNames.filter({ (userName:UserName) -> Bool in
            let userNameString = userName.name;
            return userNameString.contains(searchWorld);
        })
        self.tableView.reloadData();
    }
}
