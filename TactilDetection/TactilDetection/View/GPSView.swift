//
//  GPSView.swift
//  TactilDetection
//
//  Created by Developer on 31/12/21.
//

import SwiftUI
import MapKit

struct GPSView: View {
    @State var isOpen: Bool = false

    private struct DefaultRegion {
        static let latitude = 40.4167754
        static let longitude = -3.70379019
    }
    
    private struct Span {
        static let delta = 0.5
    }
    

    
    @State var coordinateRegion: MKCoordinateRegion = .init(center: CLLocationCoordinate2D(latitude: DefaultRegion.latitude, longitude: DefaultRegion.longitude),
                                                            span: .init(latitudeDelta: Span.delta, longitudeDelta: Span.delta))

    var body: some View {
        Group {
            
            ZStack{
                Text("GPS").foregroundColor(.red)
                    .padding()
               
                
                        Map(coordinateRegion: $coordinateRegion, showsUserLocation: true)
                                    .ignoresSafeArea()
                                    .frame(width: 115, height: 100)
                                  
                            .padding()
                        Spacer()

              
            
                
                
            }
            
            
        }
            
    }
}

struct GPSView_Previews: PreviewProvider {
    static var previews: some View {
        GPSView()
    }
}
