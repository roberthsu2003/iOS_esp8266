//
//  AppDelegate.swift
//  ios1
//
//  Created by 徐國堂 on 2017/11/3.
//  Copyright © 2017年 Gjun. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let fileName = "sortednames.plist";

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure();
        let usernameRef = Database.database().reference(withPath: "iphone2/userName");
        usernameRef.observeSingleEvent(of: .value) { (dataSnapshot:DataSnapshot) in
            if !dataSnapshot.hasChildren(){
                self.uploadDataToFirebase(usernameRef: usernameRef, plistName: self.fileName);
            }
        }
        
        return true
    }

    func uploadDataToFirebase(usernameRef:DatabaseReference,plistName:String){
        let plistNames = plistName.split(separator: ".");
        print(plistNames);
        guard let plistURL = Bundle.main.url(forResource: String(plistNames[0]), withExtension: String(plistNames[1]))else{
            //error message
            return;
        }
        let namesDic = NSDictionary(contentsOf: plistURL) as! [String:[String]];
        for (key,values) in namesDic {
            for value in values{
                usernameRef.child(key).childByAutoId().setValue(value);
            }
           
        }
       
    }

}

