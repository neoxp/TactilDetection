//
//  ListSoundsView.swift
//  TactilDetection
//
//  Created by Developer on 2/1/22.
//

import SwiftUI
import UIKit
import AudioToolbox
import MediaPlayer
import AVKit

class SoundPlayer {
    var player: AVAudioPlayer?
        
    func play(withURL url: URL) {
        player = try! AVAudioPlayer(contentsOf: url)
        player?.prepareToPlay()
        player?.play()
    }
}



struct SoundModel: Hashable {
    let name: String
    
    func getURL() -> URL {
        return URL(string: Bundle.main.path(forResource: name, ofType: "wav")!)!
    }
}

let arrayOfSounds: [SoundModel] = [
    .init(name: "alarm_clock_ringing"),
    .init(name: "baby_crying"),
    .init(name: "card_reader_alarm"),
    .init(name: "church_bells")
]


struct ListSoundsView: View {
    private let soundPlayer = SoundPlayer()
    
    var body: some View {
            
       
        VStack{
            
            NavigationView{
                
                NavigationLink(destination: ToolsView(Music: music(name: "alarm_clock_ringing"))){
                List {
                    ForEach(arrayOfSounds, id: \.self) { sound in
                        Button("Select Sound \(sound.name)") {
                            soundPlayer.play(withURL: sound.getURL())
                        }
                    }
                }.navigationBarTitle("Alarm list Sounds", displayMode: .inline)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                    .background(Color.black.opacity(0.3))
                }
            }
                            
            }
        }
    }

struct ListSoundsView_Previews: PreviewProvider {
    static var previews: some View {
        ListSoundsView()
    }
}
