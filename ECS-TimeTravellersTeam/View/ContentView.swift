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
    @State private var blink = false

    var body: some View {
        NavigationView {
            VStack {
                ZStack{
                    
                    GeometryReader { geometry in
                        ZStack {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.gray)
                                .frame(width: geometry.size.width * 0.91, height: geometry.size.height * 1.5, alignment: .center)
                                .padding()
                                .opacity(0.6)
                                
                                     //   .stroke(blink ? Color.white : Color.clear, lineWidth: 5)
                                    //    .animation(Animation.easeOut(duration: 2).repeatForever(autoreverses: true))
                                
                               
                          
                                Image(systemName: "photo.on.rectangle.angled")
                                .foregroundColor(blink ? Color.gray : Color.white)
                                    .padding()
                                    .font(.system(size: 130))
                                    .opacity(blink ? 0.2 : 0.8)
                                    .onAppear {
                                            self.blink.toggle()
                                        }
                                    .animation(Animation.easeOut(duration: 2).repeatForever(autoreverses: true))
                                  
                            
                        }
                        
                        .onTapGesture {
                            withAnimation(.none) {
                                photoVM.photoSource = .camera
                                photoVM.showPhotoPicker()
                            }
                            print("Tapped")
                        }
                    
                        
                        if let image = photoVM.image {
                            Image(uiImage: image)
                                .resizable()
                                .frame(width: geometry.size.width * 0.92, height: geometry.size.height * 1.5, alignment: .center)
                           
                                .cornerRadius(/*@START_MENU_TOKEN@*/12.0/*@END_MENU_TOKEN@*/)
                             
                                .padding()
                        }
                       
                         
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
                
               
                    GeometryReader { geometry in
                        VStack {
                            Spacer()
                        Rectangle()
                            .frame(width: geometry.size.width * 0.92, height: geometry.size.height * 0.25)
                            .foregroundColor(.white)
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
            }
        }
    .navigationViewStyle(StackNavigationViewStyle())
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
