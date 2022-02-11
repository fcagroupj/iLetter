//
//  MeList.swift
//  WeChat
//
//  Created by Gesen on 2020/10/16.
//  Copyright © 2020 Gesen. All rights reserved.
//

import SwiftUI

struct MeList: View {
    @State var wordleN = 5
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                Group {
                    Header()
                    LineR()
                }
                Group {
                    NavigationLink(destination: MeSetNView()) {
                        MeRow(icon: "n.circle", title: "iLetter N = " + String(wordleN) + " letters in a word")
                    }
                    LineY()
                }
                Group {
                    Button(action: {
                        //
                        //let w_seed = Int.random(in: 0..<10000)
                        //UserDefaults.standard.set(w_seed, forKey: "g_wordle_seed")
                        // reset
                        let kbDataDict:[String: String] = ["kb_type": "RESET"]
                        NotificationCenter.default.post(name: Notification.Name(rawValue: "NotiUpdateDataKb"),
                            object: nil,
                            userInfo: kbDataDict)
                    }, label: {
                        MeRow(icon: "restart.circle", title: "Reset guessing word")
                    })
                    LineG()
                }
                Group {
                    //
                    NavigationLink(destination: MePowerView()) {
                        MeRow(icon: "list.number", title: "Power rank list")
                    }
                    NavigationLink(destination: MeReportView()) {
                        MeRow(icon: "questionmark.circle", title: "Report a word")
                    }
                    //
                    //Separator().padding(.leading, 52)
                    NavigationLink(destination: MeDetailView()) {
                        MeRow(icon: "square.grid.2x2", title: "About iLetter")
                    }
                }
                Spacer()
            }
            
            //.background(Color("cell"))
        }
        .onAppear(perform: load)
    }
    func load() {
        print("MeList load")
        wordleN = UserDefaults.standard.integer(forKey: "g_wordle_n")
        if(wordleN > 5){ wordleN = 4 }
        else if(wordleN < 3){ wordleN = 4 }
    }
    struct Header: View {
        @State var me = Member(
            background: "",
            icon: "person",
            identifier: "Power: 0",
            name: "ABCD",
            description: ""
        )
        
        let pubItem = NotificationCenter.default.publisher(for: NSNotification.Name("updateDataUserImg"))
        var body: some View {
            VStack(spacing: 36) {
                HStack {
                    Spacer()
                    Image(systemName: "gear")
                        .padding(.trailing, 4)
                    
                }
                .frame(height: 44)
                
                HStack(spacing: 20) {
                    Image(systemName: me.icon)
                        .resizable()
                        .cornerRadius(6)
                        .frame(width: 62, height: 62)
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text(me.name)
                            .font(.system(size: 22, weight: .medium))
                        
                        HStack {
                            Text("\(me.identifier ?? "")")
                                .foregroundColor(Color.secondary)
                            
                            Spacer()
                            Image(systemName: "qrcode")
                            //Image(systemName: "cell_detail_indicator")
                        }
                    }
                }
            }
            .padding(EdgeInsets(top: 0, leading: 24, bottom: 40, trailing: 16))
            .onAppear(perform: load)
            .onReceive(pubItem){ (output) in
                self.updateDataUserItem()
            }
        }
        func load() {
            print("MeList Header load ")
            self.me.name = UserDefaults.standard.string(forKey: "g_username") ?? ""
            self.me.identifier = "Power: " + String( UserDefaults.standard.integer(forKey: "g_power") )
            if(self.me.name.count < 7){
                self.me.name = MD5_hex(i_string: String( Int(Date().timeIntervalSince1970) ))
                UserDefaults.standard.set(self.me.name, forKey: "g_username")
            }
            if(self.me.name.count > 10){
                self.me.name = self.me.name.prefix(10) + "..."
            }
        }
        func updateDataUserItem(){
            print("MeList updateDataUserItem")
            
        }
        
    }
    
    struct LineR: View {
        var body: some View {
            Rectangle()
                .foregroundColor(Color(.red))
                .frame(height: 8)
        }
    }
    struct LineY: View {
        var body: some View {
            Rectangle()
                .foregroundColor(Color(.yellow))
                .frame(height: 8)
        }
    }
    struct LineG: View {
        var body: some View {
            Rectangle()
                .foregroundColor(Color(.green))
                .frame(height: 8)
        }
    }
}

struct MeList_Previews: PreviewProvider {
    static var previews: some View {
        MeList()
    }
}
