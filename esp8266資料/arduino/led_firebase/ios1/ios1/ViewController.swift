//
//  ViewController.swift
//  ios1
//
//  Created by mac on 2017/6/20.
//  Copyright © 2017年 led_DataBase. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController {
   
    var ledRef:DatabaseReference!
    
    @IBOutlet weak var ligthBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        ledRef =  Database.database().reference().child("led");
        ledRef.observe(DataEventType.value) { (snapshot:DataSnapshot) in
            let ledNode = snapshot.value as? [String:Bool] ?? [:];
            let imageName = ledNode["D2"]! ? "light_on" : "light_off";
            let image = UIImage(named: imageName);
            self.ligthBtn.setImage(image, for: UIControlState.normal);
            
        }
 
 
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

