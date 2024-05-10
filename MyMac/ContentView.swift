//
//  ContentView.swift
//  MyMac
//
//  Created by adachikouki on 2024/04/23.
//

import SwiftUI

// test
struct ContentView: View {
    // 入力中の文字列を保持する状態変数
    @State var inputText: String = ""
    // 検索キーワードを保持する状態変数、初期値は"東京駅"
    @State var displaySearchKey: String = "東京駅"
    // マップ種類 最初は標準
    @State var displayMapType: MapType = .standard
    var body: some View {
        VStack {
            //文字入力
            TextField("キーワード", text: $inputText, prompt:
                Text("キーワードを入力"))
            // 入力が完了されたとき
                .onSubmit {
                    // 検索キーワードに設定
                    displaySearchKey = inputText
                }
                // 余白
                .padding()
            // 奥から手前にレイアウト(右下基準)
            ZStack(alignment: .bottomTrailing) {
                // マップを表示
                MapView(searchKey: displaySearchKey, mapType: displayMapType)
                
                // マップ種類切り替えボタン
                Button {
                    // 標準→衛星→衛星＋交通機関
                    if displayMapType == .standard {
                        displayMapType = .satellite
                    } else if displayMapType == .satellite {
                        displayMapType = .hybrid
                    } else {
                        displayMapType = .standard
                    }
                } label: {
                    // マップアイコンの表示
                    Image(systemName: "map")
                        .resizable()
                        .frame(width: 35.0, height: 35.0)
                } // Buttonここまで
                .padding(.trailing, 20.0)
                .padding(.bottom, 30.0)
            } // ZStack
        } // Vstack
    }
}

#Preview {
    ContentView()
}
