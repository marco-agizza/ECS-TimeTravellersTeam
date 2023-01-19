//
//  ContentView.swift
//  ECS-TimeTravellers
//
//  Created by Marco Agizza on 10/01/23.
//

import SwiftUI
import CoreData
import Photos

struct ContentView: View {
    @EnvironmentObject var photoVM: PhotosViewModel
    @EnvironmentObject var weatherConditionVM: ConditionViewModel
    @StateObject var locationDataManager = LocationDataManager()
    
    var body: some View {
        NavigationView {
            VStack {
                ZStack{
                    Rectangle()
                        .fill(Color.gray)
                        .frame(width: UIScreen.main.bounds.size.width/1.2, height: UIScreen.main.bounds.size.height/2, alignment: .center)
                        .cornerRadius(/*@START_MENU_TOKEN@*/12.0/*@END_MENU_TOKEN@*/)
                        .padding()
                        .onTapGesture {
                            photoVM.photoSource = .camera
                            photoVM.showPhotoPicker()
                            print("Tapped")
                        }
                    Image(systemName: "plus")
                        .resizable(resizingMode: .stretch)
                        .foregroundColor(.black)
                        .frame(width: /*@START_MENU_TOKEN@*/100.0/*@END_MENU_TOKEN@*/, height: /*@START_MENU_TOKEN@*/100.0/*@END_MENU_TOKEN@*/)
                        .font(.largeTitle)
                        .padding()
                    if let image = photoVM.image {
                        Image(uiImage: image)
                            .resizable()
                            .frame(width: UIScreen.main.bounds.size.width/1.2, height: UIScreen.main.bounds.size.height/2, alignment: .center)
                            .aspectRatio(contentMode: .fill)
                            .scaledToFit()
                            .cornerRadius(/*@START_MENU_TOKEN@*/12.0/*@END_MENU_TOKEN@*/)
                            .padding()
                    }
                }
                Spacer()
                Rectangle()
                    .frame(height: 60, alignment: .center)
                    .foregroundColor(.white)
                    .offset(x: 0, y: 0)
                    .cornerRadius(12.0)
                    .padding()
                    .overlay(
                        HStack{
                            Image(systemName: "note.text.badge.plus")
                                .padding(.leading, 18)
                                .padding(.trailing, 18)
                            VStack{
                                Text("Story of the day")
                                    .font(.bold(.title3)())
                                Text("Description...").font(.subheadline)
                                    .padding(.trailing, 49)
                            }
                            Spacer()
                        }
                            .foregroundColor(.black)
                            .font(.title)
                            .padding()
                    )
                    .onTapGesture {
                        print("story of the day")
                        switch locationDataManager.locationManager.authorizationStatus {
                        case .authorizedWhenInUse:  // Location services are available.
                            // Insert code here of what should happen when Location services are authorized
                            print("Your current location is:")
                            var currentLatitude = locationDataManager.locationManager.location?.coordinate.latitude
                            var currentLongitude = locationDataManager.locationManager.location?.coordinate.longitude
                            print ("latitude: \(currentLatitude!); longitude: \(currentLongitude!)")
                            /*print("Latitude: \(locationDataManager.locationManager.location?.coordinate.latitude.description ?? "Error loading")")
                             print("Longitude: \(locationDataManager.locationManager.location?.coordinate.longitude.description ?? "Error loading")")*/
                            if currentLatitude != nil && currentLongitude != nil {
                                Task {
                                    try await weatherConditionVM.getCondition(latitude: currentLatitude!, longitude: currentLongitude!)
                                }
                            }
                            
                        case .restricted, .denied:  // Location services currently unavailable.
                            // Insert code here of what should happen when Location services are NOT authorized
                            print("Current location data was restricted or denied.")
                        case .notDetermined:        // Authorization not determined yet.
                            print("Finding your location...")
                            //ProgressView()
                        default:
                            print("cazzo")
                            //ProgressView()
                        }
                    }
            }
        }
        .sheet(isPresented: $photoVM.photoPickerShowen) {
            ImagePicker(sourceType: photoVM.photoSource == .library ? .photoLibrary : .camera, selectedImage: $photoVM.image)
        }
        .navigationTitle("Good morning")
        .navigationBarItems(
            trailing:
                Button(
                    action: {
                        print("apapapp")
                        if let image = photoVM.image {
                            if let assetId = image.imageAsset {
                                print(assetId)
                            }
                        }
                    },
                    label: {
                        Image(systemName: "calendar.circle")
                            .foregroundColor(Color.white)
                            .font(.title)
                    }
                )
        )
        .cornerRadius(/*@START_MENU_TOKEN@*/12.0/*@END_MENU_TOKEN@*/)
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
            .environmentObject(PhotosViewModel())
    }
}
