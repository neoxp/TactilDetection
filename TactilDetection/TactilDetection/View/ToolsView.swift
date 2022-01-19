//
//  ToolsView.swift
//  TactilDetection
//
//  Created by Developer on 30/12/21.
//

import SwiftUI
import UIKit
import AudioToolbox
import MediaPlayer
import AVKit
import CoreLocation
import CallKit
import AddToSiriButton
import Foundation
import Intents
import AddToSiriButton
import IntentsUI

class siriRequestHandler: NSObject, INRequestRideIntentHandling {
    
    
    func handle(intent: INRequestRideIntent,
                completion: @escaping (INRequestRideIntentResponse) -> Void) {
      let response = INRequestRideIntentResponse(
        code: .failureRequiringAppLaunchNoServiceInArea,
        userActivity: .none)
      completion(response)
    }
    
}

func handler(for intent: INIntent) -> Any? {
  if intent is INRequestRideIntent {
    return siriRequestHandler()
  }
  return .none
}


class LocationViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var authorizationStatus: CLAuthorizationStatus
    
    private let locationManager: CLLocationManager
    
    override init() {
        locationManager = CLLocationManager()
        authorizationStatus = locationManager.authorizationStatus
        
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
    }
}


class audioSettings: ObservableObject {
    
    var audioPlayer: AVAudioPlayer?
    var playing = false
    @Published var playValue: TimeInterval = 0.0
    var playerDuration: TimeInterval = 146
    var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    
    func playSound(sound: String, type: String) {
        if let path = Bundle.main.path(forResource: sound, ofType: type) {
            do {
                if playing == false {
                    if (audioPlayer == nil) {
                        
                        
                        audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
                        audioPlayer?.prepareToPlay()
                        
                        audioPlayer?.play()
                        playing = true
                    }
                    
                }
                if playing == false {
                    
                    audioPlayer?.play()
                    playing = true
                }
                
                
            } catch {
                print("Could not find and play the sound file.")
            }
        }
        
    }

    
    
    func pauseSound() {
        if playing == true {
            audioPlayer?.pause()
            playing = false
        }
    }
    
    func changeSliderValue() {
        if playing == true {
            pauseSound()
            audioPlayer?.currentTime = playValue
            
        }
        
        if playing == false {
            audioPlayer?.play()
            playing = true
        }
    }
}


class SoundManagers{
    
    static let instance = SoundManagers()
    
    var player: AVAudioPlayer?

        
    func playSound(){
        
        guard let url = Bundle.main.url(forResource: "alarm_clock_ringing", withExtension: ".wav") else { return }
        do{
            player = try AVAudioPlayer(contentsOf: url)
            player?.play()
        } catch let error {
            
            print("Error playing sound. \(error.localizedDescription)")
            
        }
        
        
    }
    
    
}


class SoundPlayers {
    var player: AVAudioPlayer?
        
    func play(withURL url: URL) {
        player = try! AVAudioPlayer(contentsOf: url)
        player?.prepareToPlay()
        player?.play()
    }
}



struct soundModel: Hashable {
    let name: String
    
    func getURL() -> URL {
        return URL(string: Bundle.main.path(forResource: name, ofType: "wav")!)!
    }
}

let sounds: [soundModel] = [
    .init(name: "alarm_clock_ringing"),
    .init(name: "baby_crying"),
    .init(name: "card_reader_alarm"),
    .init(name: "church_bells")
]



//MARK- TOOLSVIEW MODO GRAFICO

struct ToolsView: View {
    
    var soundManager = SoundManagers()
    
    var Music : music
    
    
    @State var slider1: Double = 2
    @State var isSound: Bool = false
    @State var GPS: Bool = false
    @State var isVibration: Bool = false
    @State var isSiri: Bool = false
    
    @State var isSOSEurope: Bool = false
    @State var isSOSEUA: Bool = false
    @StateObject var locationViewModel = LocationViewModel()
    
    @State var inputText: String = ""
    
    let numberString = "112"
    
    let numberEUAString = "911"
    
    @State var isOpen: Bool = false
    
    private let soundPlayer = SoundPlayer()
    
    @ObservedObject var audiosettings = audioSettings()
    
    @Environment(\.scenePhase) private var scenePhase
    
    var isSiriEnabled:Bool {
            #if os(iOS)
            let status = INPreferences.siriAuthorizationStatus()
            
            switch status {
            case .notDetermined:
                return false
            case .restricted:
                return false
            case .denied:
                return false
            case .authorized:
                return true
            @unknown default:
                return false
            }
            #else
            return false
            #endif
        }
    
    
    @State private var showAlert = false
    @State private var buttonPressed: String?
    
    var body: some View {
        VStack{
            Form{
                //Slider SONIDO
                Text("Enable Volume")
                Slider(value: $audiosettings.playValue, in: TimeInterval(0.0)...audiosettings.playerDuration, onEditingChanged: { _ in
                            self.audiosettings.changeSliderValue()
                        })
                            .onReceive(audiosettings.timer) { _ in
                                
                                if self.audiosettings.playing {
                                    if let currentTime = self.audiosettings.audioPlayer?.currentTime {
                                        self.audiosettings.playValue = currentTime
                                        
                                        if currentTime == TimeInterval(0.0) {
                                            self.audiosettings.playing = false
                                        }
                                    }
                                    
                                }
                                else {
                                    self.audiosettings.playing = false
                                    self.audiosettings.timer.upstream.connect().cancel()
                                }
                            }
               
                    .padding()
                //Boton Sonido
                Toggle(isOn: $isSound) {
                    Text("Enable Sound")
                    Button("Play Sound") {
                        SoundManagers.instance.playSound()
                    }
                } 
                
                //Boton GPS
                Toggle(isOn: $GPS) {
                    Text("GPS")
                    
                    HStack{
                        switch locationViewModel.authorizationStatus {
                                case .notDetermined:
                                    AnyView(GPSView())
                                        .environmentObject(locationViewModel)
                                case .restricted:
                                    ErrorView(errorText: "Location use is restricted.")
                                case .denied:
                                    ErrorView(errorText: "The app does not have location permissions. Please enable them in settings->Privacity->Location->Enable")
                                case .authorizedAlways, .authorizedWhenInUse:
                                    TrackingView()
                                        .environmentObject(locationViewModel)
                                default:
                                    Text("Unexpected status")
                                }
                     
                    }
                    
                }//GPS
                    .padding()
                
                //Boton Vibration
                Toggle(isOn: $isVibration) {
                    Text("Enable Vibration")
                    
                    Button("Press Vibration"){
                        
                        isVibration.toggle()
                                    AudioServicesPlayAlertSoundWithCompletion(SystemSoundID(kSystemSoundID_Vibrate)) {   }
                                   
                      }
                }
               
                
               //Boton SIRI
                Toggle(isOn: $isSiri) {
                    Text("Enable Siri")
            
                    Button("Hey Siri") {
                    
                        showAlert.toggle()
                        INPreferences.requestSiriAuthorization { status in
                          if status == .authorized {
                              
                          } else {
                            print("Nay, Siri!")
                          }
                        }
                        
                    }.alert(isPresented: $showAlert) {
                        Alert(title: Text("Hi, I´m Siri?"), message: Text("Do you need help?"), primaryButton: .default(Text("Yes")), secondaryButton: .destructive(Text("No")))
                        
                    }
                }
                
            
            
                
               
                
        }//Tools
                    .padding()
                
            //Botones Emergencias
            ZStack{
                GroupBox("Only Emergency Calls"){
                Toggle(isOn: $isSOSEurope) {
                    Text("Call SOS EU")
                    Button(action: {
                        let telephone = "tel://"
                        let formattedString = telephone + numberString
                        guard let url = URL(string: formattedString) else { return }
                        UIApplication.shared.open(url)
                       }) {
                           Image("icon_sos").frame(width: 24, height: 24)
        
                       Text(numberString)
                           
                    }
                }
                
            Toggle(isOn: $isSOSEUA) {
                Text("Call SOS EUA")
                    Button(action: {
                        let telephone = "tel://"
                        let formattedString = telephone + numberEUAString
                        guard let url = URL(string: formattedString) else { return }
                        UIApplication.shared.open(url)
                       }) {
                           Image("icon_sos").frame(width: 24, height: 24)
                            
                       Text(numberEUAString)
                    }
                }
    
                }
            }
    
            }
            HStack{
                
                    NavigationView {
                        Button(action: {
                                    self.isOpen = true
                                   }, label: {
                                       Text("Note & List")
                                      
                                   })
                            
                            .sheet(isPresented: $isOpen, content: {
                                NotasEditView()
                                    })
                                
                       
                        .padding()
                    Spacer()

                        
                    }
            }.navigationBarTitle("Configuration tools", displayMode: .inline)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            .background(Color.black.opacity(0.3))
    }
    
}


struct ErrorView: View {
    var errorText: String
    
    var body: some View {
        VStack {
            Image(systemName: "xmark.octagon")
                    .resizable()
                .frame(width: 100, height: 100, alignment: .center)
            Text(errorText)
        }
        .padding()
        .foregroundColor(.white)
        .background(Color.red)
    }
}

struct TrackingView: View {
    @EnvironmentObject var locationViewModel: LocationViewModel
    
    var body: some View {
        Text("Thanks!")
    }
}


struct ToolsView_Previews: PreviewProvider {
    static var previews: some View {
        ToolsView(Music: music(name: ""))
    }
}
