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
    @Published var photoPickerShowen = false
    @Published var photoSource: PhotoPicker.PhotoSource = .library
    
    func showPhotoPicker() {
        if photoSource == .camera {
            if !PhotoPicker.checkPermissions() {
                print ("There is no camera on this device")
                return
            }
        }
        photoPickerShowen = true
    }
}
