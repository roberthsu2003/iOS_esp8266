//
//  AppDelegate.swift
//  ios1
//
//  Created by 徐國堂 on 2017/11/14.
//  Copyright © 2017年 Gjun. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let fileName = "sortednames.plist";

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        //初始化Firebase
        FirebaseApp.configure();
        
        //建立iphone2/userName節點參考
        let usernameRef = Database.database().reference(withPath: "iphone2/userName");
        
        //將節點參考加上一次監聽，實作Closue，取得dataSnapshot的資料
        usernameRef.observeSingleEvent(of: .value) { (dataSnapshot:DataSnapshot) in
            //檢查節點是否沒有資料。
            if !dataSnapshot.hasChildren(){
                //沒有資料，呼叫自訂Function
                self.uploadDataToFirebase(usernameRef: usernameRef, plistName: self.fileName);
            }
        }
        return true
    }
    
    func uploadDataToFirebase(usernameRef:DatabaseReference,plistName:String){
        //切割字串為陣列
        let plistNames = plistName.split(separator: ".");
        
        //將陣列列印出來，確認檔案有如實傳入
        print(plistNames);
        
        //使用 Bundle的 func url(forResource: String?, withExtension: String?, subdirectory: String?)，取出plist的url路徑。
        //使用guard else檢查是否有錯誤

        guard let plistURL = Bundle.main.url(forResource: String(plistNames[0]), withExtension: String(plistNames[1]))else{
            print("路徑URL有問題");
            return;
        }
        
        //使用NSDictionary先建立NSDictionary實體，透過 as! 轉型為 Dictionary
        let namesDic = NSDictionary(contentsOf: plistURL) as! [String:[String]];
        
        //導覽nameDic
        for (key,values) in namesDic {
            //取出的values為陣列，再一次使用For in導覽value陣列。
            for value in values{
                usernameRef.child(key).childByAutoId().setValue(value);
            }
            
        }
    }

   

}

