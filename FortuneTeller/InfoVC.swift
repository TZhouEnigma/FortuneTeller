//
//  InfoVC.swift
//  FortuneTeller
//
//  Created by chuxiang zhou on 8/1/17.
//  Copyright © 2017 chuxiang zhou. All rights reserved.
//

import Foundation
import UIKit
import CoreImage

import Alamofire

public extension String {
    
    func substring(_ r: Range<Int>) -> String {
        let fromIndex = self.index(self.startIndex, offsetBy: r.lowerBound)
        let toIndex = self.index(self.startIndex, offsetBy: r.upperBound)
        return self.substring(with: Range<String.Index>(uncheckedBounds: (lower: fromIndex, upper: toIndex)))
    }
    
}

class InfoVC: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet weak var AgeBtn: UIButton!
    
    @IBOutlet weak var GenderBtn: UIButton!

    @IBOutlet weak var EducationBtn: UIButton!
    
    @IBOutlet weak var bg: UIImageView!
    
    @IBOutlet weak var agePicker: UIPickerView!
    
    @IBOutlet weak var genderPicker: UIPickerView!
    
    @IBOutlet weak var educationPicker: UIPickerView!
    
    @IBOutlet weak var predictionBtn: UIButton!
    
    @IBOutlet weak var predictionImg: UIImageView!
    
    @IBOutlet weak var required1: UILabel!
    
    @IBOutlet weak var required2: UILabel!

    @IBOutlet weak var required3: UILabel!
    
    let age = ["1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25","26","27","28","29","30","31","32","33","34","35","36","37","38","39","40","41","42","43","44","45","46","47","48","49","50","51","52","53","54","55","56","57","58","59","60","61","62","63","64","65","66","67","68","69","70","71","72","73","74","75","76","77","78","79","80","81","82","83","84","85","86","87","88","89","90"]
    let gender = ["Male", "Female"]
    let education = ["Children under 15","No HS diploma","HS diploma", "less than 4 yrs of college","bachelor or higher education"]
    
    
    var selectedVal = ["","","",""] //keep track of selected values
    
    private var _facebookUserData:[String : AnyObject]!
    
    var facebookUserData:[String : AnyObject]!{
        
        get{
            
            return _facebookUserData
        }set{
            _facebookUserData = newValue
        }
        
    }
    
    
    
    
    
    override func viewDidLoad() {
       
        self.view.layoutIfNeeded()
        super.viewDidLoad()
   
        
        predictionBtn.isEnabled = false
        
        agePicker.dataSource = self
        agePicker.delegate = self
       
        genderPicker.dataSource = self
        genderPicker.delegate = self
        
        educationPicker.dataSource = self
        educationPicker.delegate = self
        
       
        
  // set all buttons with the same styling
        let borderAlpha : CGFloat = 0.7
        let cornerRadius : CGFloat = 5.0
       
        AgeBtn.frame = CGRect(x:100,y: 100, width:200, height:40)
        
        
        print(facebookUserData,"fb data")
        
        if(facebookUserData != nil){
             let temp = String(describing: facebookUserData["age_range"]! )
             AgeBtn.setTitle(temp.substring(11..<14), for
                : UIControlState.normal)
            
          
            print(temp.substring(12..<14))
            let age_Range = Int(temp.substring(12..<14))
            
            
            if ( age_Range! > 0 && age_Range! <= 17){
                 selectedVal[0] = "0-17"
            }
            else if (age_Range! > 17 && age_Range! <= 64){
                selectedVal[0] = "18-64"
            }
            else {
                selectedVal[0] = "65-80+"
            }
            
            GenderBtn.setTitle(String(describing: facebookUserData["gender"]! ), for
                : UIControlState.normal)

            selectedVal[1] = String(describing: facebookUserData["gender"]! )
            
            selectedVal[3] = String(describing: facebookUserData["name"]! )
        }
            
        else{
        AgeBtn.setTitle("Age", for
            : UIControlState.normal)
            
        GenderBtn.setTitle("Gender", for
                : UIControlState.normal)
        }
        
        AgeBtn.setTitleColor(UIColor.white, for: UIControlState.normal)
        AgeBtn.backgroundColor = UIColor.clear
        AgeBtn.layer.borderWidth = 1.0
        AgeBtn.layer.borderColor = UIColor(white: 1.0, alpha: borderAlpha).cgColor
        AgeBtn.layer.cornerRadius = cornerRadius
        
        GenderBtn.frame = CGRect(x:100,y: 100, width:200, height:40)
        
        GenderBtn.setTitleColor(UIColor.white, for: UIControlState.normal)
        GenderBtn.backgroundColor = UIColor.clear
        GenderBtn.layer.borderWidth = 1.0
        GenderBtn.layer.borderColor = UIColor(white: 1.0, alpha: borderAlpha).cgColor
        GenderBtn.layer.cornerRadius = cornerRadius
        
        EducationBtn.frame = CGRect(x:100,y: 100, width:200, height:40)
        EducationBtn.setTitle("Education", for
            : UIControlState.normal)
        EducationBtn.setTitleColor(UIColor.white, for: UIControlState.normal)
        EducationBtn.backgroundColor = UIColor.clear
        EducationBtn.layer.borderWidth = 1.0
        EducationBtn.layer.borderColor = UIColor(white: 1.0, alpha: borderAlpha).cgColor
        EducationBtn.layer.cornerRadius = cornerRadius
    

        
        print("values are", selectedVal)
        if(selectedVal[0] != "" && selectedVal[1] != "" && selectedVal[2] != ""){
        predictionBtn.isEnabled = true
        predictionImg.isHidden = false
        
        }
        
        updateLabel()
        
     
    
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = bg.bounds
        blurEffectView.alpha = 0.5
        bg.addSubview(blurEffectView)
        
        self.view.layoutIfNeeded()
        
        
        
        
        
        
    }
    
    @IBAction func ageBtnPressed(_ sender: Any) {
         agePicker.isHidden = false
         genderPicker.isHidden = true
         educationPicker.isHidden = true
        
         AgeBtn.isHidden = false
         GenderBtn.isHidden = true
         EducationBtn.isHidden = true
        
         predictionBtn.isEnabled = false
         predictionImg.isHidden = true
        
        
        self.required2.isHidden = true
        self.required3.isHidden = true
  
        
    }
    
    @IBAction func genderBtnPressed(_ sender: Any) {
         genderPicker.isHidden = false
         agePicker.isHidden = true
         educationPicker.isHidden = true
        
        
         GenderBtn.isHidden = false
         AgeBtn.isHidden = true
         EducationBtn.isHidden = true
        
         predictionBtn.isEnabled = false
         predictionImg.isHidden = true
        
        self.required1.isHidden = true
        self.required3.isHidden = true
    
    }
    
    @IBAction func educationBtnPressed(_ sender: Any) {
        educationPicker.isHidden = false
        agePicker.isHidden = true
        genderPicker.isHidden = true
        
        EducationBtn.isHidden = false
        AgeBtn.isHidden = true
        GenderBtn.isHidden = true
        
        predictionBtn.isEnabled = false
        predictionImg.isHidden = true
        
        self.required2.isHidden = true
        self.required1.isHidden = true
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if(pickerView == agePicker){
        return age.count
        }
        else if(pickerView == genderPicker){
            return gender.count
        }
        else{
        return education.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if(pickerView == agePicker){
            return age[row]
        }
        else if(pickerView == genderPicker){
            return gender[row]
        }
        else{
            return education[row]
        }
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if(pickerView == agePicker){
            AgeBtn.setTitle(age[row], for: UIControlState.normal)
            
            if ( Int(age[row])! > 0 && Int(age[row])! <= 17){
                selectedVal[0] = "0-17"
            }
            else if ( Int(age[row])! > 17 && Int(age[row])! <= 64){
                selectedVal[0] = "18-64"
            }
            else {
                selectedVal[0] = "65-80+"
            }
            
            
            agePicker.isHidden = true
            GenderBtn.isHidden = false
            EducationBtn.isHidden = false
            
            if(selectedVal[0] != "" && selectedVal[1] != "" && selectedVal[2] != ""){
                predictionBtn.isEnabled = true
                predictionImg.isHidden = false
                
            }
           
            self.required2.isHidden = true
            self.required3.isHidden = true
        }
        else if(pickerView == genderPicker){
            GenderBtn.setTitle(gender[row], for: UIControlState.normal)
            selectedVal[1] = gender[row]

            
            genderPicker.isHidden = true
            AgeBtn.isHidden = false
            EducationBtn.isHidden = false
            
            if(selectedVal[0] != "" && selectedVal[1] != "" && selectedVal[2] != ""){
                predictionBtn.isEnabled = true
                predictionImg.isHidden = false
                
            }
        }
        else{
            EducationBtn.setTitle(education[row], for: UIControlState.normal)
            selectedVal[2] = education[row]
          print(selectedVal)
            educationPicker.isHidden = true
            AgeBtn.isHidden = false
            GenderBtn.isHidden = false
            if(selectedVal[0] != "" && selectedVal[1] != "" && selectedVal[2] != ""){
                predictionBtn.isEnabled = true
                predictionImg.isHidden = false
                
            }
        }
        
        updateLabel()
        
    }
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        var str: String
        
        if(pickerView == agePicker){
         str = age[row]
        }
        else if(pickerView == genderPicker){
         str = gender[row]
        }
        else{
         str = education[row]
        }
        return NSAttributedString(string: str, attributes: [NSForegroundColorAttributeName:UIColor.white])
    }
    
    
    @IBAction func predictBtnPressed(_ sender: Any) {
        
        let userInfomation:Array<String> = selectedVal
        performSegue(withIdentifier: "PredictionVC", sender: userInfomation)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? PredictionVC{
            if let data = sender as? Array<String>{
                destination.userData = data
            }
        }
    }
    
    func updateLabel(){
        
        if(selectedVal[0] != ""){ self.required1.isHidden = true}
        else { self.required1.isHidden = false}
        
        if(selectedVal[1] != ""){ self.required2.isHidden = true }
        else { self.required2.isHidden = false}
        
        if(selectedVal[2] != ""){ self.required3.isHidden = true }
        else { self.required3.isHidden = false}
        
    }
    
}
