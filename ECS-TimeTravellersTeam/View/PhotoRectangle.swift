//
//  PhotoRectangle.swift
//  ECS-TimeTravellersTeam
//
//  Created by Carmine Cinquegrana on 01/02/23.
//

import SwiftUI

struct PhotoRectangle: View {
    @State private var blink = false
    var body: some View {
        ZStack{
            
            GeometryReader { geometry in
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
                            self.blink.toggle()
                        }
                        .animation(Animation.easeOut(duration: 2.5).repeatForever(autoreverses: true))
                }
            }
        }        
    }
}

struct PhotoRectangle_Previews: PreviewProvider {
    static var previews: some View {
        PhotoRectangle()
    }
}
