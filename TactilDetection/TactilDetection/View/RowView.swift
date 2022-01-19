//
//  RowView.swift
//  TactilDetection
//
//  Created by Developer on 2/1/22.
//

import SwiftUI
import MapKit

struct RowView: View {
    var Music: music
    
    var body: some View {
        
        VStack{
            GroupBox("Sounds"){
                Image(systemName: "speaker.wave.1").frame(width: 20, height: 20)
                Text(Music.name)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .font(.subheadline)
                
            }
     
            }.padding()
            Spacer()
            
        }
        
}

struct RowView_Previews: PreviewProvider {
    static var previews: some View {
        VStack{
            RowView(Music: music(name: "alarm_clock_ringing"))
            RowView(Music: music(name: "baby_crying"))
            RowView(Music: music(name: "card_reader_alarm"))
            RowView(Music: music(name: "church_bells"))
        }
    }
}
