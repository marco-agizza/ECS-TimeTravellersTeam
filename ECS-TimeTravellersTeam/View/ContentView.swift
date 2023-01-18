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
    @State var showStoryView = false
    
    
    var body: some View {
        NavigationView {
            VStack {
                ZStack{
                    Rectangle()
                        .fill(Color.gray)
                        .frame(width: UIScreen.main.bounds.size.width/1.2, height: UIScreen.main.bounds.size.height/2, alignment: .center)
                        .cornerRadius(12.0)
                        .padding()
                        .onTapGesture {
                            photoVM.photoSource = .camera
                            photoVM.showPhotoPicker()
                            print("Tapped")
                        }
                    Image(systemName: "plus")
                        .resizable(resizingMode: .stretch)
                        .foregroundColor(.black)
                        .frame(width: 100.0/*@END_MENU_TOKEN@*/, height: /*@START_MENU_TOKEN@*/100.0)
                        .font(.largeTitle)
                        .padding()
                    if let image = photoVM.image {
                        Image(uiImage: image)
                            .resizable()
                            .frame(width: UIScreen.main.bounds.size.width/1.2, height: UIScreen.main.bounds.size.height/2, alignment: .center)
                            .aspectRatio(contentMode: .fill)
                            .scaledToFit()
                            .cornerRadius(12.0)
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
                        // Perform action on tap
                        //StoryDayView()
                        showStoryView = true
                            
                        
                        
                        //print("Tapped")
                    }
                
            }
            .sheet(isPresented: $showStoryView) {
                        StoryDayView()
                    }
            .sheet(isPresented: $photoVM.photoPickerShowen) {
                ImagePicker(sourceType: photoVM.photoSource == .library ? .photoLibrary : .camera, selectedImage: $photoVM.image)
            }
            .navigationTitle("Good morning")
            .navigationBarItems(
                trailing:
                    Button(
                        action: {
                            // Perform button action
                        },
                        label: {
                            Image(systemName: "calendar.circle")
                                .foregroundColor(Color.white)
                                .font(.title)
                        }
                    )
            )
            .cornerRadius(12.0)
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
            .environmentObject(PhotosViewModel())
    }
}
