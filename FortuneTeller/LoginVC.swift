//
//  ViewController.swift
//  FortuneTeller
//
//  Created by chuxiang zhou on 7/28/17.
//  Copyright © 2017 chuxiang zhou. All rights reserved.
//

import UIKit
import CoreImage
import FacebookCore
import FacebookLogin
import FBSDKLoginKit
import simd
import Accelerate

class LoginVC: UIViewController   {
    
     var shouldRun = true
     var shouldRun2 = true
    
     var dict : [String : AnyObject]!
    
    
    @IBOutlet weak var bg: UIImageView!
    @IBOutlet weak var LoginButton1: UIButton!
    @IBOutlet weak var LoginButton2: UIButton!
  
    
    @IBAction func visitorPressed(_ sender: Any) {
        
         self.performSegue(withIdentifier: "InfoVC", sender: nil )
        
    }
    
    
    @IBAction func loginPressed(_ sender: Any) {
        
        let loginManager = LoginManager()
        
        loginManager.logIn([ .publishActions], viewController: self) { loginResult in
            switch loginResult {
            case .failed(let error):
                print(error)
            case .cancelled:
                print("User cancelled login.")
            case .success( _, _, _):
               self.shouldRun = false
            }
           
            print("Should run is ",self.shouldRun)
            if self.shouldRun == false{
                self.getFBUserData()
                
            }
            print("end here hehe")
          
        }

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? InfoVC{
            if let data = sender as? [String : AnyObject]{
                
                print(data, "user data")
                destination.facebookUserData = data
            }
        }
    }

    override func viewDidLoad() {
        
        self.view.layoutIfNeeded()
        super.viewDidLoad()
        UIApplication.shared.statusBarStyle = .lightContent
        let borderAlpha : CGFloat = 0.7
        let cornerRadius : CGFloat = 5.0
        
        //creating button
        
        LoginButton1.frame = CGRect(x:100,y: 100, width:200, height:40)
        LoginButton1.setTitle("Visitor", for: UIControlState.normal)
        LoginButton1.setTitleColor(UIColor.white, for: UIControlState.normal)
        LoginButton1.backgroundColor = UIColor.clear
        LoginButton1.layer.borderWidth = 1.0
        LoginButton1.layer.borderColor = UIColor(white: 1.0, alpha: borderAlpha).cgColor
        LoginButton1.layer.cornerRadius = cornerRadius
        
        LoginButton2.frame = CGRect(x:100,y: 100, width:200, height:40)
        LoginButton2.setTitle("Facebook Connect", for
            : UIControlState.normal)
        LoginButton2.setTitleColor(UIColor.white, for: UIControlState.normal)
        LoginButton2.backgroundColor = UIColor.clear
        LoginButton2.layer.borderWidth = 1.0
        LoginButton2.layer.borderColor = UIColor(white: 1.0, alpha: borderAlpha).cgColor
        LoginButton2.layer.cornerRadius = cornerRadius
        
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = bg.bounds
        blurEffectView.alpha = 0.5
        bg.addSubview(blurEffectView)
        
        self.view.layoutIfNeeded()
        
        
        /*
        if let accessToken = FBSDKAccessToken.current(){
            getFBUserData()
        }
        */
        
        
    }


    //function is fetching the user data and trigger segueway
    func getFBUserData(){
        print("fb access token", FBSDKAccessToken.current())
        if((FBSDKAccessToken.current()) != nil){
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "name, gender,age_range"]).start(completionHandler: { (connection, result, error) -> Void in
                if (error == nil){
                    self.dict = result as! [String : AnyObject]
                    print(result!)
                    print(self.dict)
                    self.performSegue(withIdentifier: "InfoVC", sender: self.dict )
                }
              }
            )
        }
    }
   
    
   

}

