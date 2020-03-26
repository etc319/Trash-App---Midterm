//
// DetailView.swift
// Midterm Data Model
//
// Created by Elizabeth Chiappini on 3/22/20.
// Copyright © 2020 lizzychiappini. All rights reserved.
//
import SwiftUI
struct DetailView: View {
    @Binding var item: TrashItem
    
    var body: some View {
        NavigationView{
            ZStack{
                Color(red:237/255, green: 172/255, blue: 138/255)
                    .edgesIgnoringSafeArea(.all)
                VStack{
                    Spacer()
                    Image(item.trashImage)
                        .resizable()
                        .frame(width: 200, height: 200)
                    
                    Spacer()
                        .padding()
                    
                    Text(item.trashName.rawValue)
                        .font(.custom("Times New Roman", size: 35))
                        .foregroundColor(Color.black)
//                        .padding()
//                        .border(Color.orange, width: 5)
//                        .cornerRadius(20)
                    .padding(15)
                    .overlay(
                        RoundedRectangle(cornerRadius: 40)
                            .stroke(Color.white, lineWidth: 1)
                    )
                    Spacer()
                        .padding()
                    VStack(alignment: .leading) {

                    Text("Today You Used \(item.getDayCount())")
                        .font(.custom("Times New Roman", size: 25))
                        .foregroundColor(Color.black)
                      
                    
                    Text("This Week You Used \(item.getWeekCount())")
                        .font(.custom("Times New Roman", size: 25))
                        .foregroundColor(Color.black)
                    
                    Spacer()
                    .padding(100)
                    }
                }
            }
            
        }.onAppear {
            print(self.item.dates.count)
        }
    }
}

//struct DetailView_Previews: PreviewProvider {
//  static var previews: some View {
//    DetailView(test: 1)
//  }
//}
//}






