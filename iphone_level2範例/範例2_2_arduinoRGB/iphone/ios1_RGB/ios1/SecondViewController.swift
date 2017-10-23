//
//  SecondViewController.swift
//  ios1
//
//  Created by 徐國堂 on 2017/10/19.
//  Copyright © 2017年 Gjun. All rights reserved.
//

import UIKit
import Firebase;
import Color_Picker_for_iOS


class SecondViewController: UIViewController {
    var rgbRef:DatabaseReference!;
    let colorPickerView = HRColorPickerView();
    override func viewDidLoad() {
        super.viewDidLoad()
        
        colorPickerView.color = UIColor.blue;
        colorPickerView.addTarget(self, action: #selector(colorChange), for: UIControlEvents.valueChanged);
        colorPickerView.frame = view.frame;
        colorPickerView.frame.origin.y = 20;
        print(colorPickerView.frame.size.width);
        print(colorPickerView.frame.size.height);
        self.view.addSubview(colorPickerView);
        rgbRef = Database.database().reference(withPath: "RGB");
        rgbRef.observeSingleEvent(of:.value) { (snapshot:DataSnapshot) in
           let rgbValues = snapshot.value as! [String:Float];
            let r = rgbValues["R"]!;
            let g = rgbValues["G"]!;
            let b = rgbValues["B"]!;
            self.colorPickerView.color = UIColor(red: CGFloat(r/255.0)  , green: CGFloat(g/255.0) , blue: CGFloat(b/255.0), alpha: 1);
        }
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        self.navigationController?.setNavigationBarHidden(true, animated: false);
    }

    @objc func colorChange(_ sender:HRColorPickerView){
        var rValue:CGFloat = 0.0;
        var gValue:CGFloat = 0.0;
        var bValue:CGFloat = 0.0;
        var aValue:CGFloat = 0.0;
        sender.color.getRed(&rValue, green: &gValue, blue: &bValue, alpha: &aValue);
        let r = Int(rValue*255);
        let g = Int(gValue*255);
        let b = Int(bValue*255);
        
        self.rgbRef.setValue(["R":r,"G":g,"B":b]);
        
        
    }
}

