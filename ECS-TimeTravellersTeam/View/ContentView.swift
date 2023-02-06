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
    
    @State var weatherConditions : String = "default"
    @State var isStoryPresented : Bool = false
    @State private var blink = false
    @State private var unexistingPictureOfTheDay: Bool = false
    
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
                        NavigationLink(destination: ArchiveView()) {
                            Image(systemName: "calendar.circle")
                                .foregroundColor(Color.white)
                                .font(.title)
                        }
                )
                .transaction { transaction in
                    transaction.animation = nil
                    
                }
                Spacer()
                PictureDescriptionButton()
                    .onTapGesture {
                        if photoVM.image != nil {
                            isStoryPresented.toggle()
                        } else {
                            unexistingPictureOfTheDay.toggle()
                        }
                    }
            }
            
        }
        .sheet(isPresented: $photoVM.photoPickerShowen) {
            ImagePicker(sourceType: photoVM.photoSource == .library ? .photoLibrary : .camera, selectedImage: $photoVM.image)
        }
        .sheet(isPresented: $isStoryPresented){
            if let currentMomentImage = photoVM.image {
                PictureDescriptionView(image: currentMomentImage, temperature: String(weatherConditionVM.weatherCondition?.temperature ?? 0)).ignoresSafeArea()
            }
        }
        .alert("Connection error. Status code: \(weatherConditionVM.statusCode)", isPresented: $weatherConditionVM.anErrorOccurred){
            Button("OK", role: .cancel){
                weatherConditionVM.anErrorOccurred = false
            }
        }
        .alert("You should take a picture before this.", isPresented: $unexistingPictureOfTheDay){
            Button("OK", role: .cancel){
                unexistingPictureOfTheDay.toggle()
            }
        }
        .cornerRadius(/*@START_MENU_TOKEN@*/12.0/*@END_MENU_TOKEN@*/)
    }
    
    /*
     private func addImage(){
     let pngImageData  = (photoVM.image!).pngData()
     let moment = Moment(context: viewContext)
     moment.picture = pngImageData
     saveContext()
     }*/
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(PhotosViewModel())
            .environmentObject(WeatherConditionViewModel())
    }
}
