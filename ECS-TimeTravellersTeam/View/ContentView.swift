//
//  ContentView.swift
//  ECS-TimeTravellers
//
//  Created by Marco Agizza on 10/01/23.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @EnvironmentObject var photoVM: PhotosViewModel
    @EnvironmentObject var weatherConditionVM: WeatherConditionViewModel
    @StateObject var locationDataManager = LocationDataManager()
    @State var weatherConditions : String = "default"
    
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
                Spacer()
                if let weatherCondition = weatherConditionVM.weatherCondition {
                    Text("Temperature: "+String(weatherCondition.temperature ?? 0))
                    Text("State: "+String(weatherCondition.text ?? "None"))
                }
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
                            if let currentLatitude = locationDataManager.locationManager.location?.coordinate.latitude, let currentLongitude = locationDataManager.locationManager.location?.coordinate.longitude {
                                Task {
                                    try await weatherConditionVM.getWeatherConditions(path: "/weather", latitude: currentLatitude.truncate(places: 1), longitude: currentLongitude.truncate(places: 1))
                                }
                                //Text(String(weatherConditionVM.weatherCondition?.temperature ?? 0))
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
        .alert("Connection error. Status code: \(weatherConditionVM.statusCode)", isPresented: $weatherConditionVM.anErrorOccurred){
            Button("OK", role: .cancel){
                weatherConditionVM.anErrorOccurred = false
            }
        }
        

        .cornerRadius(/*@START_MENU_TOKEN@*/12.0/*@END_MENU_TOKEN@*/)
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
            .environmentObject(PhotosViewModel())
            .environmentObject(WeatherConditionViewModel())
    }
}
