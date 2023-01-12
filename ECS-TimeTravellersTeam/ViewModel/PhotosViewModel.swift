//
//  PhotosViewModel.swift
//  ECS-TimeTravellers
//
//  Created by Marco Agizza on 11/01/23.
//

import Foundation
import SwiftUI

class PhotosViewModel: ObservableObject {
    @Published var image: UIImage?
    @Published var showPicker = false
    @Published var source: Picker.Source = .library
    
    func showPhotoPicker() {
        if source == .camera {
            if !Picker.checkPermissions() {
                print ("There is no camera on this device")
                return
            }
        }
        showPicker = true
    }
}
