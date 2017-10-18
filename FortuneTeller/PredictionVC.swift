//
//  PredictionVC.swift
//  FortuneTeller
//
//  Created by chuxiang zhou on 8/1/17.
//  Copyright © 2017 chuxiang zhou. All rights reserved.
//

import Foundation
import UIKit
import CoreImage
import Alamofire
import FacebookCore
import FacebookLogin
import FBSDKShareKit
import UICircularProgressRing
import FacebookShare

class PredictionVC: UIViewController, UICircularProgressRingDelegate {

    @IBOutlet weak var userInfo: UILabel!
    
    @IBOutlet weak var bg: UIImageView!
    
    @IBOutlet weak var ring1: UICircularProgressRingView!
    
    @IBOutlet weak var shareBtn: UIButton!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var backBtn: UIButton!
    
    
    
    private var _userData:Array<String>!
    
    var userData:Array<String>{
        
        get{
            return _userData
        }set{
            _userData = newValue
        }
        
    }
    
    func processdata()->String{
        var age = "0"
        var gen = "0"
        var edu = "0"
     
        if(userData[0] == "0-17") {age = "0"}
        if(userData[0] == "18-64") {age = "0.5"}
        if(userData[0] == "65-80+") {age = "1"}
        if(userData[1] == "Male" || userData[1] == "male") {gen = "1"}
        if(userData[1] == "Female" || userData[1] == "female") {gen = "0"}
        if(userData[2] == "Children under 15") {edu = "0"}
        if(userData[2] == "No HS diploma") {edu = "0.25"}
        if(userData[2] == "HS diploma") {edu = "0.5"}
        if(userData[2] == "less than 4 yrs of college") {edu = "0.75"}
        if(userData[2] == "bachelor or higher education") {edu = "1"}
        return  age+"&"+gen+"&"+edu
        
 }
    func initialText()->String{
        return "According to "
    }
    
    override func viewDidLoad() {
        
        if(userData[3] != ""){
            nameLabel.text = "Hi, "+userData[3]
            nameLabel.textColor = UIColor.white
        }
        
        
        let borderAlpha : CGFloat = 0.7
        let cornerRadius : CGFloat = 5.0
        
        self.view.layoutIfNeeded()
        
        super.viewDidLoad()
        
        
        shareBtn.frame = CGRect(x:100,y: 100, width:200, height:40)
        shareBtn.setTitleColor(UIColor.white, for: UIControlState.normal)
        shareBtn.backgroundColor = UIColor.clear
        shareBtn.layer.borderWidth = 1.0
        shareBtn.layer.borderColor = UIColor(white: 1, alpha: borderAlpha).cgColor
        shareBtn.layer.cornerRadius = cornerRadius
        
        ring1.font = UIFont.systemFont(ofSize: 22, weight: UIFontWeightSemibold)
        ring1.delegate = self
        ring1.valueIndicator = " $USD"
        ring1.animationStyle = kCAMediaTimingFunctionLinear
        
        ring1.fontColor = UIColor.white
        
        
        let userString = processdata()
        let test = NeuroNetwork()
        test.ChangeRequestUrl(userurl: userString)
        
        
        test.getResponse { (tempPred) in
            let pred = Float(tempPred)!*100000
            DispatchQueue.main.async {
                    self.ring1.setProgress(value: CGFloat(pred), animationDuration: 4) {
                    self.ring1.font = UIFont.systemFont(ofSize: 22, weight: UIFontWeightSemibold)
                }
            }
        }
        //let tempPred = test.getResponse()
        
        
        userInfo.text = "Your projected annual earning is"
        userInfo.textColor = UIColor.white
     
        
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = bg.bounds
        blurEffectView.alpha = 0.5
        bg.addSubview(blurEffectView)
    

        

      
        
        self.view.layoutIfNeeded()
        
        
        
    }



    @IBAction func backBtnPressed(_ sender: Any) {
          dismiss(animated: false, completion: nil)
    }


    @IBAction func fbShare(_ sender: Any) {
        
        shareBtn.isHidden = true
        backBtn.isHidden = true
        let loop = RunLoop.current
        
        let loopShouldStart = loop.run(mode: RunLoopMode.defaultRunLoopMode, before: Date(timeIntervalSinceNow: 0))
        
        while (!backBtn.isHidden && !shareBtn.isHidden  && loopShouldStart) { }
        
        ScreenShot()
        shareBtn.isHidden = false
        backBtn.isHidden = false
 
        
    }
 
 
    
    func finishedUpdatingProgress(forRing ring: UICircularProgressRingView) {
    
    }
    
    func ScreenShot(){
        
        let screen = UIScreen.main
        
        if let window = UIApplication.shared.keyWindow {
            UIGraphicsBeginImageContextWithOptions(screen.bounds.size, false, 0);
            window.drawHierarchy(in: window.bounds, afterScreenUpdates: false)
            let image = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            
            let sharePhoto = FBSDKSharePhoto()
            sharePhoto.caption = "according to a superior intellect"
            sharePhoto.image = image
            
            let content = FBSDKSharePhotoContent()
            content.photos = [sharePhoto]
            
            
            let shareDialog = FBSDKShareDialog()
            shareDialog.shareContent = content
            shareDialog.delegate = nil
            
            if !shareDialog.canShow() {
                print("cannot show native share dialog")
            }
            
            shareDialog.show()
        }
        
    }
    
}
