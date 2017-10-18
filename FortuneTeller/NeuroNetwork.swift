//
//  NeuroNetwork.swift
//  FortuneTeller
//
//  Created by chuxiang zhou on 8/5/17.
//  Copyright © 2017 chuxiang zhou. All rights reserved.
//

import Foundation
import UIKit
import Accelerate
import simd
import Alamofire


class NeuroNetwork{
    
    var URLresponse = "can't reach server"
    
    var shouldRun = true
    var requestURL = " "
    
    func getResponse(completion: @escaping (String) -> Void) {
        Alamofire.request(requestURL).responseString { response in
            print("Success: \(response.result.isSuccess)")
            print("Response String: \(String(describing: response.result.value))")
            
            if response.result.isSuccess {
                self.URLresponse = String(describing: (response.result.value)!)
                completion(self.URLresponse)
            }
            
        }
    }
    
    func ChangeRequestUrl(userurl: String){
        
        self.requestURL = "https://fortuneteller.pythonanywhere.com/"+userurl
        
    }

}
