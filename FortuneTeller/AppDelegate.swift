//
//  AppDelegate.swift
//  FortuneTeller
//
//  Created by chuxiang zhou on 7/28/17.
//  Copyright © 2017 chuxiang zhou. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FacebookCore

import FacebookLogin


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    
    
    
    
    //added these 3 methods
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
      /*
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
        
        let mainStoryboard = UIStoryboard.init(name: "Main", bundle: nil)
        self.window = UIWindow(frame: UIScreen.main.bounds)
        var initialViewController: UIViewController
        
        if(FBSDKAccessToken.current() != nil){
        
            let vc = mainStoryboard.instantiateViewController(withIdentifier: "InfoVC") as! InfoVC
            initialViewController = vc
        }else{
            initialViewController = mainStoryboard.instantiateViewController(withIdentifier: "LoginVC")
        }
        print("jiang jieshi")
        print(FBSDKAccessToken.current())
        
        
        self.window?.rootViewController = initialViewController
        
        self.window?.makeKeyAndVisible()
        */
        return FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
    }
 
   
    
    func applicationWillResignActive(_ application: UIApplication) {
        FBSDKAppEvents.activateApp()
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return FBSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
    }
    
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        
    }

}

