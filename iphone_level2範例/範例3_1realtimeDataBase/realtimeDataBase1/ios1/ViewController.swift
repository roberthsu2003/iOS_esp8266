//
//  ViewController.swift
//  ios1
//
//  Created by 徐國堂 on 2017/11/3.
//  Copyright © 2017年 Gjun. All rights reserved.
//

import UIKit
import Firebase;

class ViewController: UIViewController {
    @IBOutlet var tableView:UITableView!;
    var keys:[String] = [];
    var namesDic:[String:[UserName]] = [:];
    var searchController:UISearchController!
    var resultViewController:ResultViewController!;
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        resultViewController = storyboard?.instantiateViewController(withIdentifier: "ResultViewController") as! ResultViewController;
        searchController = UISearchController(searchResultsController: resultViewController);
        searchController.searchResultsUpdater = resultViewController as UISearchResultsUpdating;
        tableView.tableHeaderView = searchController.searchBar;
        
        
        let userNameRef = Database.database().reference(withPath: "iphone2/userName");
        userNameRef.observe(.value) { (userNameSnapshot:DataSnapshot) in
            var totalNames:[UserName] = [];
            if let userNameValue = userNameSnapshot.value as? [String:[String:String]]{
                self.keys = Array(userNameValue.keys).sorted();
                
                for key in self.keys{
                    /*
                    let keyValues = Array(userNameValue[key]!.values);
                    names += keyValues;
                    self.namesDic[key] = keyValues;
                     */
                    var names:[UserName] = [];
                    let keyGroup = userNameValue[key]!;
                    for (autoKey,userName) in keyGroup{
                        let name = UserName(AutoKeyId: autoKey, name: userName);
                        names += [name];
                    }
                    totalNames += names;
                    self.namesDic[key] = names;
                }
            }
            print(self.keys);
            print(self.namesDic);
            self.resultViewController.sourceNames = totalNames;
            self.tableView.reloadData();
            
        }
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

extension ViewController:UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int{
        return self.keys.count;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        let names = namesDic[keys[section]]!;
        return names.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let names = namesDic[keys[indexPath.section]]!;
        let name = names[indexPath.row];
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell1", for: indexPath);
        cell.textLabel?.text = name.name;
        return cell;
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?{
        return keys[section];
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]?{
        return keys;
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath){
        if editingStyle == .delete{
            let key = keys[indexPath.row];
            let userNames = namesDic[key]!;
            let userName = userNames[indexPath.row];
            let removeAutoKey = userName.AutoKeyId;
            let userNameRef = Database.database().reference(withPath: "iphone2/userName");            
            userNameRef.child(key).child(removeAutoKey).removeValue();
        }
    }
}




