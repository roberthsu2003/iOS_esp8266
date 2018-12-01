//
//  ViewController.swift
//  ios1
//
//  Created by 徐國堂 on 2017/11/14.
//  Copyright © 2017年 Gjun. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    //建立本地端tableView的資料來源，負責Section的數量和title
    //一開始建立空的陣列
    var keys:[String] = [];
    
    //建立本地端tableView的資料來源，負責ros的數量和內容
    //一開始建立空的Dictionary
    var namesDic:[String:[UserName]] = [:];
    
    override func viewDidLoad() {
        super.viewDidLoad();
        //取得節點
        let userNameRef = Database.database().reference(withPath: "iphone2/userName");
        //監聽並取得資料
        userNameRef.observe(.value) { (userNameSnapshot:DataSnapshot) in
            
            //取得firebase userName節點的所有資料
            if let userNamesValue = userNameSnapshot.value as? [String:[String:String]]{
                //取出userNamesValue內，所有的keys和排序內容
                self.keys = Array( userNamesValue.keys).sorted();
                
                //使用for..in導覽所有的keys
                for key in self.keys{
                    
                    //建立names字串陣列空陣列，將收集每一個內的所有userName
                    var names:[UserName] = [];
                    
                    //取得Firebase內，單一key內所有的values([String:String])
                    let keyGroup = userNamesValue[key]!;
                    
                    //取出所有單一key內的userName，並且將一個一個的userName加入至names陣列。
                    for (key,userName) in keyGroup{
                        let name = UserName(AutoKeyId: key, name: userName);
                        names += [name];
                    }
                    
                    //將key和names加入至namesDic內
                    self.namesDic[key] = names;
                }
                
            }
            self.tableView.reloadData();
        }
        
    }
}

//建立extension，並採納protocol UITableViewDataSource
extension ViewController:UITableViewDataSource{
    
    //回傳tableView有多少個Section
    func numberOfSections(in tableView: UITableView) -> Int{
        return self.keys.count;
    }
    
    //回傳每個Section有多少個Rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        //取出每個Section的namse, 並傳出names的數量
        let names = namesDic[keys[section]]!;
        return names.count;
    }
    
    //回傳每個Row需要的Cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        //取出section的names
        let names = namesDic[keys[indexPath.section]]!;
        //取出應section內對應row的name
        let userName = names[indexPath.row];
        //建立Cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell1", for: indexPath);
        //將name顯示在cell上
        cell.textLabel?.text = userName.name;
        return cell;
    }
    
    //建立每個Section的title
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?{
        return keys[section];
    }
    //建立索引的indexTitle
    func sectionIndexTitles(for tableView: UITableView) -> [String]?{
        return keys;
    }
    
}
