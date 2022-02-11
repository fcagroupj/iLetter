//
//  MeSetNView.swift
//  WeChat
//
//  Created by Zijian Wang on 11/11/21.
//  Copyright © 2021 Gesen. All rights reserved.
//

import SwiftUI

struct MeSetNView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State var isAlert = false
    @State var alertTitle = "Change Wordle N"
    @State var alertMsg = "After saving, you must manually restart the APP to take effect."
    @State var st_wordle_n = 0
    var h_wordle_n = ["3", "4", "5"]
    var body: some View {
        ZStack{
            VStack{
                // AppIcon
                Image(systemName: "n.circle")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 150)
                VStack{
                    HStack{
                        Image(systemName: "n.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30, height: 30)
                        Spacer()
                        Picker(selection: $st_wordle_n,
                               label: Text(self.h_wordle_n[st_wordle_n])) {
                            ForEach(0 ..< h_wordle_n.count) {
                                   Text(self.h_wordle_n[$0])
                                }
                             }.padding()
                            .pickerStyle(MenuPickerStyle())
                        Text(" letters in a word")
                    }
                    Button(action: {
                        DoSave()
                    }, label: {
                        Text("Save")
                            .foregroundColor(Color.white)
                            .frame(width: 250, height: 50)
                            .cornerRadius(12)
                            .background(Color.blue)
                    })
                }
                .padding()
                
                Spacer()
            }
            
        }
        .navigationTitle("Set letters in a word")
        .onAppear(perform: load)
        .alert(isPresented: $isAlert) { () -> Alert in
            Alert(title: Text(self.alertTitle),
                  message: Text(self.alertMsg),
                  primaryButton: .default(Text("Okay"), action: {
                    self.isAlert = false
                    self.presentationMode.wrappedValue.dismiss()
                  }),
                  secondaryButton: .default(Text("Dismiss")) )
        }
    }
    func load() {
        print("MeSetNView load")
        var wordleN = UserDefaults.standard.integer(forKey: "g_wordle_n")
        if(wordleN > 5){ wordleN = 4 }
        else if(wordleN < 3){ wordleN = 4 }
        st_wordle_n = wordleN - 3
    }
    func DoSave() {
        print("Save to letters ", st_wordle_n + 3)
        UserDefaults.standard.set(st_wordle_n + 3, forKey: "g_wordle_n")
        self.isAlert = true
    }
}

struct MeSetNView_Previews : PreviewProvider {
    static var previews: some View {
        MeSetNView()
    }
}
