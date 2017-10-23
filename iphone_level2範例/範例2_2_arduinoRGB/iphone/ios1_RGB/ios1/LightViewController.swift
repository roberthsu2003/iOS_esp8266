//
//  LightViewController.swift
//  ios1
//
//  Created by 徐國堂 on 2017/10/19.
//  Copyright © 2017年 Gjun. All rights reserved.
//

import UIKit
import Firebase

class LightViewController: UIViewController {
    //宣告資料庫節點的參考relayRef
    var relayRef:DatabaseReference!;
    @IBOutlet weak var lightBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //建立relayRef的實體，這實體是參考Relay/D1這個節點
        relayRef = Database.database().reference(withPath: "Relay/D1");
        //將節點加入監聽器
        relayRef.observe(.value) { (snapshot:DataSnapshot) in
            //取得Relay/D1節點的值
            let d1State = snapshot.value as! Bool;
            //判斷true或false時，改變prompt的內容，並改變成適當的圖片
            if d1State {
                self.navigationItem.prompt = "目前狀態:開啟";
                self.lightBtn.setImage(UIImage.init(named: "open_light"), for: UIControlState.normal);
            }else{
                self.navigationItem.prompt = "目前狀態:關閉";
                self.lightBtn.setImage(UIImage.init(named: "close_light"), for: UIControlState.normal)
            }
        }
        
        
    }
    
    
    
    @IBAction func userChangeLight(_ sender: UIButton) {
        //當使用者點選按鈕時，加入監聽一次的程式碼
        relayRef.observeSingleEvent(of: .value) { (snapshot:DataSnapshot) in
            let d1State = snapshot.value as! Bool;
            self.relayRef.setValue(!d1State);
        }
    }
}
