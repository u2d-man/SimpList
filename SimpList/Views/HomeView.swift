//
//  HomeView.swift
//  SimpList
//
//  Created by kazunari.ueeda on 2021/03/13.
//

import SwiftUI
import CoreData

struct HomeView: View {
    @EnvironmentObject var viewModel: ItemViewModel
    @State private var showAddItemView = false
    
    @State var isInputKeybord: Bool = false
    
    @State private var itemTitle: String = ""
    @State private var date: Date = Date()
    
    var body: some View {
        ZStack(alignment: Alignment(horizontal: .trailing, vertical: .bottom), content: {
            VStack {
                Header()
                
                HStack {
                    Text("\(viewModel.items.count) Tasks Today")
                        .font(Font.custom(FontsManager.Monstserrat.medium, size: 18))
                        .foregroundColor(Color("primary"))
                        .fontWeight(.semibold)
                    
                    Spacer()
                }
                .padding()
                
                ScrollView(.vertical, showsIndicators: false, content: {
                    ForEach(viewModel.items, id: \.self) { item in
                        HStack(spacing: 20) {
                            Button(action: {
                                self.viewModel.toggleIsDone(item)
                            }, label: {
                                if item.isDone {
                                    LottieView()
                                        .frame(width: 45, height: 45)
                                } else {
                                    Image(systemName: "circle")
                                        .font(.title2)
                                        .frame(width: 45, height: 45)
                                }
                            })
                            
                            VStack(alignment: .leading) {
                                Text("\(item.title)")
                                    .font(Font.custom(FontsManager.Monstserrat.medium, size: 18))
                                    .fontWeight(.regular)
                                    .multilineTextAlignment(.leading)
                                
                                Text("\(item.date)")
                                    .font(Font.custom(FontsManager.Monstserrat.medium, size: 14))
                                    .foregroundColor(Color.gray.opacity(0.8))
                            }
                            .contextMenu(menuItems: {
                                Button(action: {
                                    withAnimation {
                                        viewModel.deleteItem(item)
                                    }
                                }, label: {
                                    Text("Delete")
                                })
                            })
                            
                            Spacer()
                        }
                        .padding(.leading)
                        .padding(.top, 5)
                    }
                })
            }
            
            HStack {
                TextField("Write a new task...", text: $itemTitle,
                          onEditingChanged: { begin in
                            if begin {
                                self.isInputKeybord.toggle()
                            }
                          },
                          
                          onCommit: {
                            if itemTitle != "" {
                                let dateString = viewModel.formattedDateForUserData(date: date)
                                _ = viewModel.createItem(itemTitle, dateString)
                            }
                            
                            self.isInputKeybord.toggle()
                            itemTitle = ""
                          })
                    .padding()
                
                DatePicker("", selection: $date, displayedComponents: .hourAndMinute)
                    .padding()
            }
            .frame(height: 50)
            .background(Color("secondary"))
            .cornerRadius(15)
            .padding()
            .padding(.top, 20)
            .animation(.spring())
        })
        .background(isInputKeybord ? Color("background").opacity(0.8).edgesIgnoringSafeArea(.all) : Color("background").edgesIgnoringSafeArea(.all))
    }
//        NavigationView {
//            List {
//                ForEach(viewModel.items, id: \.self) { item in
//                    TodoItemView(item: item)
//                        .onTapGesture {
//                            self.viewModel.toggleIsDone(item)
//                        }
//                }
//                .onDelete(perform: deleteItems)
//            }
//            .navigationTitle("RealmTodo")
//            .toolbar {
//                ToolbarItem(placement: .navigationBarLeading) {
//                    Button(action: {
//
//                    }, label: {
//                        Text("Edit")
//                    })
//                }
//
//                ToolbarItem(placement: .navigationBarTrailing) {
//                    HStack {
//                        Button(action: {
//                            viewModel.toggleDisplayFilter()
//                        }, label: {
//                            Image(systemName: viewModel.showUndoneItems ? "checkmark" : "circle")
//                        })
//
//                        Button(action: {
//                            showAddItemView.toggle()
//                        }, label: {
//                            Image(systemName: "plus")
//                                .font(.title)
//                        })
//                    }
//
//                }
//            }
//            .sheet(isPresented: $showAddItemView) {
//                AddItemView(showAddItemView: $showAddItemView)
//            }
//        }
//    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

struct Header: View {
    @EnvironmentObject var viewModel: ItemViewModel
    
    @State var isShow = false
    @State var viewState = CGSize.zero
    @State var isDragging = false
    
    var body: some View {
        VStack {
            GeometryReader { geometry in
                Text("SimpList")
                    .font(Font.custom(FontsManager.Monstserrat.bold, size: geometry.size.width / 10))
                    .foregroundColor(.white)
                    .offset(x: viewState.width / 15, y: viewState.height / 15)
                    .offset(x: 0, y: -70)
                
                Text("\(viewModel.formattedDateForHeader())")
                    .font(Font.custom(FontsManager.Monstserrat.bold, size: geometry.size.width / 10))
                    .foregroundColor(.white)
                    .offset(x: viewState.width / 15, y: viewState.height / 15)
                    .offset(x: 75, y: 45)
            }
            .frame(maxWidth: 300)
            .padding(.horizontal, 16)
        }
        .padding(.top, 100)
        .frame(height: 200)
        .frame(maxWidth: .infinity)
        .background(
            Image("top")
                .offset(x: viewState.width / 25, y: viewState.height / 25)
            , alignment: .center
        )
        .background(LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.368627451, green: 0.431372549, blue: 1, alpha: 1)), .purple]), startPoint: .topLeading, endPoint: .bottomTrailing))
        .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
        .scaleEffect(isDragging ? 0.9 : 1)
        .animation(.timingCurve(0.2, 0.8, 0.2, 1, duration: 0.8))
        .rotation3DEffect(Angle(degrees: 5), axis: (x: viewState.width, y: viewState.height, z:0))
        .gesture(
            DragGesture().onChanged { value in
                self.viewState = value.translation
                self.isDragging = true
            }
            .onEnded { value in
                self.viewState = .zero
                self.isDragging = false
            }
        )
        .padding()
    }
}