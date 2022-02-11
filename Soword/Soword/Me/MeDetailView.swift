//
//  MeDetailView.swift
//  WeChat
//
//  Created by Zijian Wang on 11/11/21.
//  Copyright © 2021 Gesen. All rights reserved.
//

import SwiftUI

struct MeDetailView: View {
    //@Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        ZStack{
            VStack{
                // AppIcon
                Image("AppIcon_150")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 150)
                VStack{
                    HStack{
                        Image(systemName: "house.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30, height: 30)
                        Spacer()
                        Text("iLetter")
                    }
                    //
                    HStack{
                        Image(systemName: "key.icloud")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30, height: 30)
                        Spacer()
                        Button(action: {
                            print("Visit at", "cloudH.org")
                            var i_website = "cloudH.org/word"
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
                    }
                    //
                    HStack{
                        Image(systemName: "tag.circle")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30, height: 30)
                        Spacer()
                        Text(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0.1")
                    }
                    
                }
                .padding()
                
                Spacer()
            }
            
        }
        .navigationTitle("About iLetter")
    }
    
}

struct MeDetailView_Previews : PreviewProvider {
    static var previews: some View {
        MeDetailView()
    }
}
