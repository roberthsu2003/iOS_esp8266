//
//  AddViewController.swift
//  ios1
//
//  Created by 徐國堂 on 2017/11/6.
//  Copyright © 2017年 Gjun. All rights reserved.
//

import UIKit
import Firebase

class AddViewController: UITableViewController {
    @IBOutlet weak var addField: UITextField!
    let userNameRef = Database.database().reference(withPath: "iphone2/userName");
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    
    @IBAction func addName(_ sender: UIButton) {
        let name = addField.text!;
        let firstChar = String(name[name.startIndex]).uppercased();
        let letters = NSCharacterSet.uppercaseLetters;
        let range = firstChar.rangeOfCharacter(from: letters);
        if range != nil{
            
            let removeFirstName = name[name.index(after: name.startIndex)...];            
            
            userNameRef.child(firstChar).childByAutoId().setValue(firstChar + removeFirstName);
            navigationController?.popToRootViewController(animated: true);
        }else{
           
        }
        
    }
    

    
}
