//
//  MeHome.swift
//  SwiftUI-WeChat
//
//  Created by Gesen on 2019/7/20.
//  Copyright © 2019 Gesen. All rights reserved.
//

import SwiftUI

struct MeHome : View {
    var body: some View {
        ZStack {
            
            MeList()
        }
        .navigationBarHidden(true)
    }
}

struct MeHome_Previews : PreviewProvider {
    static var previews: some View {
        MeHome()
    }
}
