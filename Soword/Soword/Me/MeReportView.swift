//
//  MeReportView.swift
//  WeChat
//
//  Created by Zijian Wang on 11/11/21.
//  Copyright © 2021 Gesen. All rights reserved.
//

import SwiftUI

struct MeReportView: View {
    //@Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State var st_word = ""
    var body: some View {
        ZStack{
            VStack{
                // AppIcon
                Image(systemName: "questionmark.circle")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 150)
                VStack{
                    HStack{
                        Image(systemName: "plus.circle")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30, height: 30)
                        Spacer()
                        TextField("New word", text: $st_word)
                            .disableAutocorrection(false)
                            .autocapitalization(.none)
                            .background(Color(.secondarySystemBackground))
                            .padding()
                    }
                    HStack{
                        Image(systemName: "key.icloud")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30, height: 30)
                        Spacer()
                        Button(action: {
                            print("Visit at", "cloudH.org")
                            var i_website = "cloudH.org/word/report.php?" +
                                "query_h_id=668866" +
                                "&username=" + (UserDefaults.standard.string(forKey: "g_username") ?? "") +
                                "&word=" + self.st_word
                            if(i_website.hasPrefix("http://") || i_website.hasPrefix("https://") ){
                            } else {
                                i_website = "http://" + i_website
                            }
                            if let url = URL(string: i_website), UIApplication.shared.canOpenURL(url) {
                               if #available(iOS 10.0, *) {
                                  UIApplication.shared.open(url, options: [:], completionHandler: nil)
                               } else {
                                  UIApplication.shared.openURL(url)
                               }
                            }
                          }) {
                              Text("cloudH.org/word")
                          }
                          .padding()
                    }
                    
                }
                .padding()
                
                Spacer()
            }
            
        }
        .navigationTitle("Report a word")
    }
    
}

struct MeReportView_Previews : PreviewProvider {
    static var previews: some View {
        MeReportView()
    }
}
