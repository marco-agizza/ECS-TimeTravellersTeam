//
//  Picker.swift
//  ECS-TimeTravellers
//
//  Created by Marco Agizza on 11/01/23.
//

import UIKit

enum Picker {
    enum Source: String {
        case library, camera
    }
    
    static func checkPermissions() -> Bool {
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            return true
        } else {
            return false
        }
    }
}
