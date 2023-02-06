//
//  PictureOfTheDayView.swift
//  ECS-TimeTravellersTeam
//
//  Created by Marco Agizza on 05/02/23.
//

import SwiftUI

struct PictureOfTheDayView: View {
    @EnvironmentObject var photoVM: PhotosViewModel
    @EnvironmentObject var weatherConditionVM: WeatherConditionViewModel
    @StateObject var locationDataManager = LocationDataManager()
    
    // Uso il contesto per controllare se è stato catturato il momento per la data corrente
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(entity: Moment.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Moment.date, ascending: true)], predicate: NSPredicate(format: "date LIKE %@", takeMyFormatter().string(from: Date.now)))
    private var todayMoment: FetchedResults<Moment>
    
    @State private var blink = false
    let blinkingDuration: Double = 0.75
    
    var body: some View {
        GeometryReader { geometry in
            if let image = photoVM.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: geometry.size.width * 0.92, height: geometry.size.height * 1.5, alignment: .center)
                    .cornerRadius(12)
                    .padding()
            } else {
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.gray)
                        .frame(width: geometry.size.width * 0.91, height: geometry.size.height * 1.5, alignment: .center)
                        .padding()
                        .opacity(0.6)
                    
                    Image(systemName: "photo.on.rectangle.angled")
                        .foregroundColor(blink ? Color.gray : Color.white)
                        .padding()
                        .font(.system(size: 130))
                        .opacity(blink ? 0.2 : 0.6)
                        .onAppear {
                            withAnimation(.easeOut(duration: blinkingDuration).repeatForever()){
                                blink.toggle()
                            }
                        }
                }
                .onTapGesture {
                    withAnimation(.none) {
                        photoVM.photoSource = .camera
                        if photoVM.image == nil {
                            apiRequest()
                            photoVM.showPhotoPicker()
                        }
                    }
                    print("Tapped")
                }
            }
        }
        .onAppear {
            // Check if the moment of today is taken
            if let takenTodayMoment = todayMoment.first {
                print("The picture of today was taken at \(takenTodayMoment.date ?? "DATE UNKNOWN")")
                let imageData = takenTodayMoment.value(forKey: "picture") as! Data
                if let loadedImage = UIImage(data: imageData) {
                    photoVM.image = loadedImage.rotate(radians: .pi/2)
                }
            } else {
                print("The picture of today wasn't taken")
            }
        }
    }
    
    private func apiRequest(){
        switch locationDataManager.locationManager.authorizationStatus {
        case .authorizedWhenInUse:  // Location services are available.
            // Insert code here of what should happen when Location services are authorized
            if let currentLatitude = locationDataManager.locationManager.location?.coordinate.latitude, let currentLongitude = locationDataManager.locationManager.location?.coordinate.longitude {
                Task {
                    try await weatherConditionVM.getWeatherConditions(path: "/weather", latitude: currentLatitude.truncate(places: 1), longitude: currentLongitude.truncate(places: 1))
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



/*struct PictureOfTheDayView_Previews: PreviewProvider {
 static var previews: some View {
 PictureOfTheDayView()
 .environmentObject(PhotosViewModel())
 }
 }*/
