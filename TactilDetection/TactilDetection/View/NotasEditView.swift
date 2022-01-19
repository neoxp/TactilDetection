//
//  NotasEditView.swift
//  TactilDetection
//
//  Created by Developer on 1/1/22.
//

import SwiftUI

struct RowItem: Identifiable {
    let id = UUID()
    var name: String
    var list: [RowItem]?
    
    static let mockupItems: [RowItem] = {
        var item1 = RowItem(name: "List Alarm", list: [RowItem(name: "Enable alarm 12:15 AM"),
                                                         RowItem(name: "Enable alarm 10:20 AM"),
                                                         RowItem(name: "Enable alarm 20:39 PM"),
                                                         RowItem(name: "Enable alarm 05:00 AM"),
                                                                    RowItem(name: "Enable alarm 23:20 PM"),
                                                       RowItem(name: "Enable alarm 22:20 PM")
        ])
        
        var item2 = RowItem(name: "Finances", list: [RowItem(name: "S P 500"),
                                                         RowItem(name: "IBEX 35"),
                                                         RowItem(name: "NASDAQ 100"),
                                                         RowItem(name: "NIKKEI 225"),
                                                         RowItem(name: "EURO STOXX 50®")
        ])
        
      
        
        var item3 = RowItem(name: "World Clock", list: [RowItem(name: "Asia 03:52:23 sunday 02, genuary 2022 "),
                                                         RowItem(name: "Europe 19:56:14, saturday 01, genuary 2022 CET  "),
                                                         RowItem(name: "New York 13:54:55, saturday 01, genuary 2022 EST"),
                                                         RowItem(name: "Los Angeles 10:55:37, saturday 01, genuary 2022 PST"),
                                                         RowItem(name: "Australia 05:57:36, sunday 02, genuary 2022 AEDT")
        ])
        
        return [item1, item2, item3]
    }()
}


struct NotasEditView: View {

    @State var inputText: String = ""
        
    let items: [RowItem] = RowItem.mockupItems
        
        var body: some View {
            HStack{
            
            List(items, children: \.list) { children in
                Text(children.name)
       
            }.listStyle(InsetGroupedListStyle())
          
        
            VStack{
                GroupBox("Edit Note 1") {
                    TextField("Write note", text: $inputText)
                        .frame(height: 44)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    if !inputText.isEmpty {
                        Text("User say: " + inputText)
                    }
                }
                GroupBox("Edit Note 2") {
                    TextField("Write note", text: $inputText)
                        .frame(height: 44)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    if !inputText.isEmpty {
                        Text("User say: " + inputText)
                    }
                }
                GroupBox("Edit Note 3") {
                    TextField("Write note", text: $inputText)
                        .frame(height: 44)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    if !inputText.isEmpty {
                        Text("User say: " + inputText)
                    }
                }
                GroupBox("Edit Note 4") {
                    TextField("Write note", text: $inputText)
                        .frame(height: 44)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    if !inputText.isEmpty {
                        Text("User say: " + inputText)
                    }
                }
                GroupBox("Edit Note 5") {
                    TextField("Write note", text: $inputText)
                        .frame(height: 44)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    if !inputText.isEmpty {
                        Text("User say: " + inputText)
                    }
                }
               
               
               
            
            }.padding()
                .navigationBarTitle("Note & List", displayMode: .inline)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                .background(Color.black.opacity(0.3))
}
        }

}


struct NotasEditView_Previews: PreviewProvider {
    static var previews: some View {
        NotasEditView()
    }
}
