//
//  RideRequestHandler.swift
//  TactilDetection
//
//  Created by Developer on 9/1/22.
//

import Foundation
import SwiftUI
import Intents
import IntentsUI
import AVKit

class SiriRequestHandler: NSObject, INRequestRideIntentHandling {
    
    
    func handle(intent: INRequestRideIntent,
                completion: @escaping (INRequestRideIntentResponse) -> Void) {
      let response = INRequestRideIntentResponse(
        code: .failureRequiringAppLaunchNoServiceInArea,
        userActivity: .none)
      completion(response)
    }
    
}


