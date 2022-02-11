//
//  WordleView.swift
//  wordle*
//
//  Created by Zijian Wang on 1/22/22.
// https://github.com/hannahcode/wordle/blob/main/src/constants/wordlist.ts
// Cleaning first (CMD+SHIFT+K)
//

import SwiftUI

struct WordleView: View {
    let grid_N: Int
    @State var grid_wordsA: [String] = [String]()
    @State var grid_wordsB: [String] = [String]()
    
    @State var grid_now = 0
    @State var grid_target = "ADIEU"
    @State var grid_cols: [Color] = [Color]()
    @State var grid_bkcols: [Color] = [Color]()
    @State var grid_txts = [String]()
    @State var kb1_cols: [Color] = [.gray, .gray, .gray, .gray, .gray, .gray, .gray, .gray, .gray, .gray]
    @State var kb1_txts = ["Q", "W", "E", "R", "T", "Y", "U", "I", "O", "P"]
    @State var kb2_cols: [Color] = [.yellow, .gray, .gray, .gray, .gray, .gray, .gray, .gray, .gray, .gray]
    @State var kb2_txts = ["Del", "A", "S", "D", "F", "G", "H", "J", "K", "L"]
    @State var kb3_cols: [Color] = [.white, .gray, .gray, .gray, .gray, .gray, .gray, .gray, .red, .white]
    @State var kb3_txts = ["", "Z", "X", "C", "V", "B", "N", "M", "Del", ""]
    @State var kb_hint = "Input a word"
    let pubItem = NotificationCenter.default.publisher(for: NSNotification.Name("NotiUpdateDataKb"))
    var body: some View {
        VStack{
            FlexibleGrid(colors: grid_cols, texts: grid_txts, focus: grid_now,
                         bkcolors: grid_bkcols, grid_h: grid_N)
            Spacer()
            FlexibleKb1(colors: kb1_cols, texts: kb1_txts)
            FlexibleKb1(colors: kb2_cols, texts: kb2_txts)
            FlexibleKb1(colors: kb3_cols, texts: kb3_txts)
            Button(action: {
                DoSubmit()
                print("Submit")
            }, label: {
                Text(kb_hint)
                    .foregroundColor(Color.white)
                    .frame(width: 150, height: 50)
                    .cornerRadius(12)
                    .background(Color.green)
            })
            Spacer()
            
        }
        .navigationBarHidden(true)
        .onAppear(perform: load)
        .onReceive(pubItem){ (output) in
            self.updateDataKb(notify: output)
        }
    }
    func load(){
        grid_cols.reserveCapacity(grid_N * (grid_N+1))
        grid_bkcols.reserveCapacity(grid_N * (grid_N+1))
        grid_txts.reserveCapacity(grid_N * (grid_N+1))
        for _ in 0..<grid_N * (grid_N+1) {
            grid_cols.append(.white)
            grid_bkcols.append(.black)
            grid_txts.append("")
        }
        // word list
        if(grid_N == 5){
            grid_wordsA = globalVars.WORD_LIST5A
            grid_wordsB = globalVars.WORD_LIST5B
        } else if(grid_N == 4){
            grid_wordsA = globalVars.WORD_LIST4A
        } else if(grid_N == 3){
            grid_wordsA = globalVars.WORD_LIST3A
        }
        let w_seed = UserDefaults.standard.integer(forKey: "g_wordle_seed")
        self.grid_target = grid_wordsA[w_seed % grid_wordsA.count]
        //self.grid_target = "adieu"
        print("  grid_target ", self.grid_target)
    }
    func reload(){
        let w_seed = Int.random(in: 0..<10000)
        UserDefaults.standard.set(w_seed, forKey: "g_wordle_seed")
        self.grid_target = grid_wordsA[w_seed % grid_wordsA.count]
        //self.grid_target = "adieu"
        print("  grid_target ", self.grid_target)
        
        grid_now = 0
        for kk in 0..<grid_N * (grid_N+1) {
            grid_cols[kk] = .white
            grid_bkcols[kk] = .black
            grid_txts[kk] = ""
        }
        kb1_cols = [.gray, .gray, .gray, .gray, .gray, .gray, .gray, .gray, .gray, .gray]
        kb1_txts = ["Q", "W", "E", "R", "T", "Y", "U", "I", "O", "P"]
        kb2_cols = [.yellow, .gray, .gray, .gray, .gray, .gray, .gray, .gray, .gray, .gray]
        kb2_txts = ["Del", "A", "S", "D", "F", "G", "H", "J", "K", "L"]
        kb3_cols = [.white, .gray, .gray, .gray, .gray, .gray, .gray, .gray, .red, .white]
        kb3_txts = ["", "Z", "X", "C", "V", "B", "N", "M", "Del", ""]
        kb_hint = "Input a word"
    }
    func DoSubmit(){
        if(self.kb_hint == "You Win!"){
            self.reload()
            return
        }
        if(self.grid_now < grid_N-1 || self.grid_now >= grid_N*(grid_N+1) ){return}
        var grid_src = ""
        for kk in 0..<grid_N{
            grid_src += grid_txts[self.grid_now-(grid_N-1)+kk]
        }
        grid_src = grid_src.lowercased()
        print("look for ", grid_src, " to ", grid_target)
        
        var w_found = 0
        for ii in 0..<grid_wordsA.count {
            if(grid_wordsA[ii] == grid_src){
                w_found += 1
                break
            }
        }
        if(w_found <= 0){
            for ii in 0..<globalVars.WORD_LIST5B.count {
                if(globalVars.WORD_LIST5B[ii] == grid_src){
                    w_found += 1
                    break
                }
            }
        }
        if(w_found <= 0){
            self.kb_hint = "Not a word"
            return
        }else{
            // move the cursor to next row
            if(self.grid_now < grid_N*(grid_N+1)) {self.grid_now += 1}
            // find the letter is matched or not
            let grid_base = self.grid_now - grid_N - self.grid_now % grid_N
            for ii in 0..<grid_N {
                let idx = grid_src.index(grid_src.startIndex, offsetBy: ii)
                var e_found = 0
                for jj in 0..<grid_N {
                    let idy = grid_src.index(grid_src.startIndex, offsetBy: jj)
                    //print("compare ", grid_src[idx], self.grid_target[idy])
                    if(grid_src[idx] == self.grid_target[idy]){
                        
                        e_found += 1
                        break
                    }
                }
                if(e_found > 0){
                    self.grid_cols[grid_base+ii] = .yellow
                    self.grid_bkcols[grid_base+ii] = .white
                    self.updateKbColor(tg_text: grid_src[idx].uppercased(), tg_col: .yellow)
                } else {
                    self.grid_cols[grid_base+ii] = .red
                    self.grid_bkcols[grid_base+ii] = .white
                    self.updateKbColor(tg_text: grid_src[idx].uppercased(), tg_col: .red)
                }
            }
            // find the letter has right postion
            var grid_right = 0
            for ii in 0..<grid_N {
                let idx = grid_src.index(grid_src.startIndex, offsetBy: ii)
                if(grid_src[idx] == self.grid_target[idx]){
                    self.grid_cols[grid_base+ii] = .green
                    self.grid_bkcols[grid_base+ii] = .white
                    self.updateKbColor(tg_text: grid_src[idx].uppercased(), tg_col: .green)
                    grid_right += 1
                }
            }
            if(grid_right >= grid_N){
                self.kb_hint = "You Win!"
                let g_powers = UserDefaults.standard.integer(forKey: "g_power")
                UserDefaults.standard.set(g_powers + grid_N*20, forKey: "g_power")
            }
        }
    }
    func updateKbColor(tg_text: String, tg_col: Color){
        for jj in 0..<kb1_txts.count {
            let idy = kb1_txts.index(kb1_txts.startIndex, offsetBy: jj)
            //print("compare ", grid_src[idx], self.grid_target[idy])
            if(kb1_txts[idy] == tg_text){
                kb1_cols[jj] = tg_col
            }
            if(kb2_txts[idy] == tg_text){
                kb2_cols[jj] = tg_col
            }
            if(kb3_txts[idy] == tg_text){
                kb3_cols[jj] = tg_col
            }
        }
    }
    func updateDataKb(notify: Notification){
        if(self.kb_hint == "You Win!"){
            return
        }
        if let i_type = notify.userInfo?["kb_type"] as? String {
            if(i_type == "Del" || i_type == "Bck"){
                if(self.grid_now >= grid_N*(grid_N+1) ){return}
                if(self.grid_now > 0) {
                    if(grid_txts[self.grid_now] == ""){
                        if( (self.grid_now % grid_N) == 0 ){
                        } else {
                            self.grid_now -= 1
                            grid_txts[self.grid_now] = ""
                            grid_cols[self.grid_now] = .white
                            grid_bkcols[self.grid_now] = .black
                            self.kb_hint = "Input a word"
                        }
                    } else {
                        grid_txts[self.grid_now] = ""
                        self.kb_hint = "Input a word"
                    }
                }
            } else if(i_type == "RESET"){
                reload()
            } else {
                if(self.grid_now >= grid_N*(grid_N+1) ){return}
                if( self.grid_now < grid_N*(grid_N+1) ) {
                    if( (self.grid_now % grid_N) == (grid_N-1) ){
                        if(grid_txts[self.grid_now] == ""){
                            grid_txts[self.grid_now] = i_type
                            self.kb_hint = "Submit"
                        }
                    } else {
                        grid_txts[self.grid_now] = i_type
                        self.grid_now += 1
                        self.kb_hint = "Input a word"
                    }
                    
                }
            }
        }
    }
    
    func drawWordlen() -> UIImage{
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        let img = renderer.image { ctx in
            ctx.cgContext.setFillColor(UIColor.red.cgColor)
            ctx.cgContext.setStrokeColor(UIColor.green.cgColor)
            ctx.cgContext.setLineWidth(10)

            let rectangle = CGRect(x: 0, y: 0, width: 128, height: 128)
            ctx.cgContext.addRect(rectangle)
            ctx.cgContext.drawPath(using: .fillStroke)
        }
        return img
    }
}

struct FlexibleGrid: View{
    let colors: [Color]
    let texts: [String]
    let focus: Int
    let bkcolors: [Color]
    let grid_h: Int
    @State var cols: [GridItem] = [GridItem]()
    @State var w_block = 50.0
    @State var h_block = 50.0
    var body: some View{
        LazyVGrid(columns: cols, spacing: 1){
            ForEach(0..<grid_h*(grid_h+1)){index in
                if(colors.count > 0){
                    colors[index % colors.count]
                        .overlay(
                            ZStack{
                                if(index <= focus){
                                    Image("rect02")
                                        .renderingMode(.original)
                                        .resizable()
                                        .frame(width: w_block, height: h_block)
                                } else {
                                    Image("rect03")
                                        .renderingMode(.original)
                                        .resizable()
                                        .frame(width: w_block, height: h_block)
                                }
                                
                                Text(texts[index % colors.count])
                                    .foregroundColor(bkcolors[index % bkcolors.count])
                                    .font(.system(size: h_block*0.618))
                            }
                            
                        ).frame(height: h_block)
                }
                
            }
        }
        .onAppear(perform: load)
    }
    func load() {
        print("FlexibleGrid load...")
        let screenSize: CGRect = UIScreen.main.bounds
        // 375.0 812.0 for iphone 13 mini
        self.w_block = (screenSize.width - 4) / Double(grid_h)
        self.h_block = screenSize.height / 16.0
        self.cols = Array(repeating: GridItem(spacing: 1), count: grid_h)
        
    }
}
struct FlexibleKb1: View{
    let colors: [Color]
    let texts: [String]
    let cols: [GridItem] = Array(repeating: GridItem(spacing: 1), count: 10)
    @State var w_block = 30.0
    @State var h_block = 50.0
    
    var body: some View{
        LazyVGrid(columns: cols, spacing: 0){
            ForEach(0..<10){index in
                colors[index % colors.count]
                    .overlay(
                        Button(action: {
                            let kbDataDict:[String: String] = ["kb_type": texts[index % colors.count]]
                            NotificationCenter.default.post(name: Notification.Name(rawValue: "NotiUpdateDataKb"),
                                object: nil,
                                userInfo: kbDataDict)
                            //print("Hit me")
                        }, label: {
                            Text(texts[index % colors.count])
                                .foregroundColor(Color.white)
                                //.frame(width: 20, height: 30)
                                .cornerRadius(12)
                                //.background(Color.green)
                        })
                    ).frame(height: h_block)
            }
        }
    }
    func load() {
        print("FlexibleKb1 load...")
        let screenSize: CGRect = UIScreen.main.bounds
        // 375.0 812.0 for iphone 13 mini
        self.h_block = screenSize.height / 20.0
    }
}
struct WordleView_Previews: PreviewProvider {
    static var previews: some View {
        WordleView(grid_N: 5)
    }
}
