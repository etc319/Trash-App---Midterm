
//
// ContentView.swift
// Midterm Data Model
//
// Created by Elizabeth Chiappini on 3/9/20.
// Copyright © 2020 lizzychiappini. All rights reserved.
//
import SwiftUI
let KeyForUserDefaults = "MY_DATA_KEY"
struct MyData: Codable {
    let id = UUID()
    var msg: String
    var date: Date
}
enum TrashTypes: String, Codable, CaseIterable {
    case plasticBag
    case plasticCup
    case plasticStraw
    case coffeeCup
    case cutlery
    case takeOutContainer
}

struct TrashItem: Codable {
    var trashImage: String
    var trashName: TrashTypes
    var dates: [DateComponents] // Date
    
    func getDayCount() -> Int {
        let currentDate = Calendar.current.dateComponents([.year, .month, .day], from: Date())
        
        var dayCount = 0
        
        for date in self.dates {
            if (currentDate == date) {
                dayCount+=1
            }
        }
        print("dayCount:", dayCount)
        return dayCount
    }
    
    func getWeekCount() -> Int {
        let currentDate = Calendar.current.dateComponents([.year, .month, .day], from: Date())
        
        var weekCount = 0
        
        for date in self.dates {
            //if (currentDate.day != date.day){
            if ((currentDate.day!-7) < date.day!){
                weekCount+=1
                //&& (currentDate.day!) > date.day!
            }
        }
        print("date.day:", currentDate.day)
        return weekCount
    }
}


class TrashModel: ObservableObject {
    //    @Published var trashs = [TrashItem]()
    @Published var myDataArray = [MyData]()
    @Published var trashs = [TrashItem]()
    
    init() {
        
        if loadData() == false {
            //array #0
            let plasticBag = TrashItem(trashImage: TrashTypes.plasticBag.rawValue,
                                       trashName: TrashTypes.plasticBag,
                                       dates: [DateComponents]())
            trashs.append(plasticBag)
            
            //array #1
            let plasticCup = TrashItem (trashImage: TrashTypes.plasticCup.rawValue,
                                        trashName: TrashTypes.plasticCup,
                                        dates: [DateComponents]())
            trashs.append(plasticCup)
            
            //array #2
            let plasticStaw = TrashItem (trashImage: TrashTypes.plasticStraw.rawValue,
                                         trashName: TrashTypes.plasticStraw,
                                         dates: [DateComponents]())
            trashs.append(plasticStaw)
            
            //array #3
            let coffeeCup = TrashItem (trashImage: TrashTypes.coffeeCup.rawValue,
                                       trashName: TrashTypes.coffeeCup,
                                       dates: [DateComponents]())
            trashs.append(coffeeCup)
            
            //array #4
            let cutlery = TrashItem (trashImage: TrashTypes.cutlery.rawValue,
                                     trashName: TrashTypes.cutlery,
                                     dates: [DateComponents]())
            trashs.append(cutlery)
            
            //array #5
            let takeOutContainer = TrashItem (trashImage: TrashTypes.takeOutContainer.rawValue,
                                              trashName: TrashTypes.takeOutContainer,
                                              dates: [DateComponents]())
            trashs.append(takeOutContainer)
        }
        //print("trashs array:", trashs[4])
    }
    
    
    func addDate(index: Int) {
        let now = Calendar.current.dateComponents([.year, .month, .day], from: Date())
        trashs[index].dates.append(now)
        
        let count = trashs[index].dates.count
        //print("dates:", trashs[index].dates)
    }
    
    func getCount(index: Int) -> Int {
        return trashs[index].getDayCount()
    }
    
    // Method to save myDataArray.
    func saveData() {
        let data = trashs.map { try? JSONEncoder().encode($0) }
        UserDefaults.standard.set(data, forKey: KeyForUserDefaults)
    }
    
    // Method to load myDataArray.
    func loadData () -> Bool {
        guard let encodedData = UserDefaults.standard.array(forKey: KeyForUserDefaults) as? [Data] else {
            return false
        }
        trashs = encodedData.map { try! JSONDecoder().decode(TrashItem.self, from: $0) }
        return true
    }
    
    // Add message to data array.
    //I need to change this to be able to remember date and count NOT msg and date, so myData would include the date
    func addMessage(msg: String) {
        let myData = MyData(msg: msg.isEmpty ? "Empty Message" : msg, date: Date())
        myDataArray.append(myData)
        
        //// SAVE DATA TO USER DEFAULTS //
        saveData()
    }
}


struct ContentView: View {
    @ObservedObject var trashModel = TrashModel()
    //  @State var item: TrashItem
    @State var linkToDetail = false
    @State var linkToDetail1 = false
    @State var linkToDetail2 = false
    @State var linkToDetail3 = false
    @State var linkToDetail4 = false
    @State var linkToDetail5 = false
    
    var body: some View {
        
        NavigationView {
            ZStack{
                Color(red:255/255, green: 226/255, blue: 148/255)
                    .edgesIgnoringSafeArea(.all)
                VStack{
                    //Spacer()
                    HStack{
                        ZStack{
                            NavigationLink(
                                destination: DetailView(item: self.$trashModel.trashs[0]),
                                isActive: $linkToDetail
                            ) { EmptyView() }.background(Color.red)
                            Image(self.trashModel.trashs[0].trashImage)
                                .resizable()
                                .frame(width: 150, height: 150)
                            VStack{
                                // Text(self.trashModel.trashs[0].trashName.rawValue)
                                // Text("\(self.item.getDayCount())")
                                ZStack{
                                    Circle()
                                        .fill(Color.orange)
                                        .frame(width: 40, height: 40)
                                        .offset(x: 0, y: 30)
                                    Circle()
                                        .fill(Color.white)
                                        .frame(width: 38, height: 38)
                                        .offset(x: 0, y: 30)
                                    Text("\(self.trashModel.getCount(index: 0))")
                                        .font(.custom("Times New Roman", size: 25))
                                        //.fontWeight(.bold)
                                        .foregroundColor(Color.black)
                                        .offset(x: 0, y: 30)
//                                    .padding(15)
//                                    .overlay(
//                                        RoundedRectangle(cornerRadius: 40)
//                                            .stroke(Color.white, lineWidth: 1)
//                                        .offset(x: 0, y: 30)

 //                                   )
                                }
                            }
                        }
                        .onTapGesture(count: 2, perform: {
                            self.linkToDetail = !self.linkToDetail
                            
                        }).onTapGesture {
                            self.trashModel.addDate(index: 0)
                            self.trashModel.saveData()
                        }
                        
                        ZStack{
                            NavigationLink(
                                destination: DetailView(item: self.$trashModel.trashs[1]),
                                isActive: $linkToDetail1
                            ) { EmptyView() }.background(Color.red)
                            Image(self.trashModel.trashs[1].trashImage)
                                .resizable()
                                .frame(width: 150, height: 150)
                            VStack{
                                ZStack{
                                    Circle()
                                        .fill(Color.orange)
                                        .frame(width: 40, height: 40)
                                        .offset(x: 0, y: 30)
                                    Circle()
                                        .fill(Color.white)
                                        .frame(width: 38, height: 38)
                                        .offset(x: 0, y: 30)
                                    Text("\(self.trashModel.getCount(index: 1))")
                                        .font(.custom("Times New Roman", size: 25))
                                        //.fontWeight(.bold)
                                        .foregroundColor(Color.black)
                                        .offset(x: 0, y: 30)
                                }
                            }
                        }
                        .onTapGesture(count: 2, perform: {
                            self.linkToDetail1 = !self.linkToDetail1
                        }).onTapGesture {
                            self.trashModel.addDate(index: 1)
                        }
                    }
                    Spacer()
                    
                    HStack {
                        //Array #2&#3 here
                        ZStack{
                            NavigationLink(
                                destination: DetailView(item: self.$trashModel.trashs[2]),
                                isActive: $linkToDetail2
                            ) { EmptyView() }.background(Color.red)
                            Image(self.trashModel.trashs[2].trashImage)
                                .resizable()
                                .frame(width: 150, height: 150)
                            VStack{
                                ZStack{
                                    Circle()
                                        .fill(Color.orange)
                                        .frame(width: 40, height: 40)
                                        .offset(x: 0, y: 30)
                                    Circle()
                                        .fill(Color.white)
                                        .frame(width: 38, height: 38)
                                        .offset(x: 0, y: 30)
                                    Text("\(self.trashModel.getCount(index: 2))")
                                        .font(.custom("Times New Roman", size: 25))
                                        .foregroundColor(Color.black)
                                        .offset(x: 0, y: 30)
                                }
                            }
                        }
                        .onTapGesture(count: 2, perform: {
                            self.linkToDetail2 = !self.linkToDetail2
                        }).onTapGesture {
                            self.trashModel.addDate(index: 2)
                            self.trashModel.saveData()
                        }
                        
                        ZStack{
                            NavigationLink(
                                destination: DetailView(item: self.$trashModel.trashs[3]),
                                isActive: $linkToDetail3
                            ) { EmptyView() }.background(Color.red)
                            Image(self.trashModel.trashs[3].trashImage)
                                .resizable()
                                .frame(width: 150, height: 150)
                            VStack{
                                ZStack{
                                    Circle()
                                        .fill(Color.orange)
                                        .frame(width: 40, height: 40)
                                        .offset(x: 0, y: 30)
                                    Circle()
                                        .fill(Color.white)
                                        .frame(width: 38, height: 38)
                                        .offset(x: 0, y: 30)
                                    Text("\(self.trashModel.getCount(index: 3))")
                                        .font(.custom("Times New Roman", size: 25))
                                        //.fontWeight(.bold)
                                        .foregroundColor(Color.black)
                                        .offset(x: 0, y: 30)
                                }
                            }
                        }
                        .onTapGesture(count: 2, perform: {
                            self.linkToDetail3 = !self.linkToDetail3
                        }).onTapGesture {
                            self.trashModel.addDate(index: 3)
                        }
                    }
                    Spacer()
                    
                    HStack {
                        //Array #4&#5 here
                        ZStack{
                            NavigationLink(
                                destination: DetailView(item: self.$trashModel.trashs[4]),
                                isActive: $linkToDetail4
                            ) { EmptyView() }.background(Color.red)
                            Image(self.trashModel.trashs[4].trashImage)
                                .resizable()
                                .frame(width: 150, height: 150)
                            VStack{
                                ZStack{
                                    Circle()
                                        .fill(Color.orange)
                                        .frame(width: 40, height: 40)
                                        .offset(x: 0, y: 30)
                                    Circle()
                                        .fill(Color.white)
                                        .frame(width: 38, height: 38)
                                        .offset(x: 0, y: 30)
                                    Text("\(self.trashModel.getCount(index: 4))")
                                        .font(.custom("Times New Roman", size: 25))
                                        //.fontWeight(.bold)
                                        .foregroundColor(Color.black)
                                        .offset(x: 0, y: 30)
                                }
                            }
                        }
                        .onTapGesture(count: 2, perform: {
                            self.linkToDetail4 = !self.linkToDetail4
                            
                        }).onTapGesture {
                            self.trashModel.addDate(index: 4)
                            self.trashModel.saveData()
                        }
                        
                        ZStack{
                            NavigationLink(
                                destination: DetailView(item: self.$trashModel.trashs[5]),
                                isActive: $linkToDetail5
                            ) { EmptyView() }.background(Color.red)
                            Image(self.trashModel.trashs[5].trashImage)
                                .resizable()
                                .frame(width: 150, height: 150)
                            VStack{
                                ZStack{
                                    Circle()
                                        .fill(Color.orange)
                                        .frame(width: 40, height: 40)
                                        .offset(x: 0, y: 30)
                                    Circle()
                                        .fill(Color.white)
                                        .frame(width: 38, height: 38)
                                        .offset(x: 0, y: 30)
                                    
                                    Text("\(self.trashModel.getCount(index: 5))")
                                        .font(.custom("Times New Roman", size: 25))
                                        //.fontWeight(.bold)
                                        .foregroundColor(Color.black)
                                        .offset(x: 0, y: 30)
                                    
                                }
                            }
                        }
                        .onTapGesture(count: 2, perform: {
                            self.linkToDetail5 = !self.linkToDetail5
                        }).onTapGesture {
                            self.trashModel.addDate(index: 5)
                        }
                    }
                    Spacer()
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
