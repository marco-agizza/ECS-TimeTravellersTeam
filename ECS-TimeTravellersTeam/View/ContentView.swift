//
//  ContentView.swift
//  ECS-TimeTravellers
//
//  Created by Marco Agizza on 10/01/23.
//

import SwiftUI
import CoreData
import Foundation
import CoreFoundation

struct ContentView: View {
    @EnvironmentObject var photoVM: PhotosViewModel
    @EnvironmentObject var weatherConditionVM: WeatherConditionViewModel
    
    
    @State var weatherConditions : String = "default"
    
    
    var body: some View {
        NavigationView {
            VStack {
                ZStack{
                    PictureOfTheDayView()
                        .environmentObject(photoVM)
                        .environmentObject(weatherConditionVM)
                }
                .navigationTitle("Good morning")
                .navigationBarItems(
                    trailing:
                        Button(
                            action: {
                                print("Going to the archive view")
                            },
                            label: {
                                Image(systemName: "calendar.circle")
                                    .foregroundColor(Color.white)
                                    .font(.title)
                            }
                        )
                )
                Spacer()
                PictureDescriptionButton()
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
        .onAppear(){
            print("La data attuale è \(Date.now) ma formattata è: \(takeMyFormatter().string(from: Date.now))")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environment(\.managedObjectContext, PersistenceManager.preview.container.viewContext)
            .environmentObject(PhotosViewModel())
            .environmentObject(WeatherConditionViewModel())
    }
}
