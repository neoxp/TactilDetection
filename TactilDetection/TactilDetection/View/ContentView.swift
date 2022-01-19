//
//  ContentView.swift
//  TactilDetection
//
//  Created by Developer on 30/12/21.
//

import LocalAuthentication
import SwiftUI

struct ContentView: View {
    @State private var showDetails = false
    @State var isOpen: Bool = false
    
    @State private var isUnloked = false
    
    var body: some View {
        
        VStack{
          
            Text("To access the app insert your touchid")
            
                .foregroundColor(.black)
                .padding()
        
            
            Text("Please enter the fingerprint or your touchid").foregroundColor(.red)
                .padding()
            Spacer()
            
         
                NavigationView {
                    Button(action: {
                                self.isOpen = true
                               }, label: {
                                   if self.isUnloked{
                                       Image(systemName: "touchid").resizable().frame(width: 250, height: 250)
                                           .padding(50)
                                       
                                   }
                                  
                               }).onAppear(perform: authenticate)
                        
                        .onDisappear(perform: authenticate)
                        
                        .sheet(isPresented: $isOpen, content: {
                                   SecondView()
                                })
                            
                   
                    .padding()
                Spacer()

                    
                }
           
            
            Spacer()
            
            Text("Please wait.Recognition of the fingerprint or your touchid, loading data ...")
    
                .padding()
            Spacer()
            
        }.navigationBarTitle("TactilDetection", displayMode: .inline)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            .background(Color.blue.opacity(0.3))
    }
    
    func authenticate(){
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error){
            
            let reason = "We need to unlok you data."
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason){ success , authentitaionError in
                DispatchQueue.main.async {
                    
                    if success{
                        self.isUnloked = true
                    } else {
                        //there as a problem
                    }
                    
                    
                }

            }
        } else {
            //no biometrics
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
