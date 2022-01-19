//
//  SecondView.swift
//  TactilDetection
//
//  Created by Developer on 30/12/21.
//

import SwiftUI
import MapKit
import Foundation
import UIKit


class timeanclock {
    
    func time() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .none

        let label = UILabel()
        label.text = dateFormatter.string(from: Date())
    }
}




struct SecondView: View {
    
    
    
    
    let date: Date
        let dateFormatter: DateFormatter
        
        init() {
            date = Date()
            dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .long
            dateFormatter.timeStyle = .short
        }
    
    
    @State var isOpen: Bool = false
    @State var selectedDate = Date()
    
    var closedRange: ClosedRange<Date> {
            let twoDaysAgo = Calendar.current.date(byAdding: .day, value: -2, to: Date())!
            let fiveDaysAgo = Calendar.current.date(byAdding: .day, value: -5, to: Date())!
            
            return fiveDaysAgo...twoDaysAgo
        }

    private struct DefaultRegion {
        static let latitude = 40.4167754
        static let longitude = -3.70379019
    }
    
    private struct Span {
        static let delta = 0.5
    }
    

    
    @State var counter = 0
    
    @State var coordinateRegion: MKCoordinateRegion = .init(center: CLLocationCoordinate2D(latitude: DefaultRegion.latitude, longitude: DefaultRegion.longitude),
                                                            span: .init(latitudeDelta: Span.delta, longitudeDelta:
                                    Span.delta))
    
    
    
    
   

    var body: some View {
        Group {
            
            VStack{
                Text("User GPS Location  Area").foregroundColor(.red)
                    .padding()
                ZStack{
                
                        Map(coordinateRegion: $coordinateRegion, showsUserLocation: true)
                                    .ignoresSafeArea()
                           
                    
                        
                            .padding()
                        Spacer()
                    
                }
                VStack{
                    GroupBox("Current Date and Time "){
                    Text(date, formatter: dateFormatter).foregroundColor(.red).font(.title2)
                }
            }
                
                VStack{
                    GroupBox("Select Date"){
                        
                        DatePicker(selection: /*@START_MENU_TOKEN@*/.constant(Date())/*@END_MENU_TOKEN@*/, label: { Text("Your Date") })

                    }
                       
                        TextEditor(text: .constant("Writing you text in this location"))
                            .font(.subheadline)
                            .foregroundColor(.blue)
                            .frame(width: 352, height: 50)
                            .border(Color.gray)
                    
                }
          
                HStack{
                    NavigationView {
                        Button(action: {
                                       self.isOpen = true
                                   }, label: {
                                       Text("Tools Configuration Panel")
                                           .padding()
                                   }).sheet(isPresented: $isOpen, content: {
                                       ToolsView(Music: music(name: "alarm_clock_ringing"))
                                   })
                               }
                }
                
            }
            
            
        }
                .navigationBarTitle("User Area", displayMode: .inline)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                .background(Color.blue.opacity(0.3))
            }
}



struct SecondView_Previews: PreviewProvider {
    static var previews: some View {
        SecondView()
                    .environment(\.locale, Locale(identifier: "es"))
           
    }
}
