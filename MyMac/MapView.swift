//
//  MapView.swift
//  MyMac
//
//  Created by adachikouki on 2024/04/23.
//

import SwiftUI
import MapKit

// 画面で選択したマップの種類を示す列挙型
enum MapType {
    case standard // 標準
    case satellite // 衛星
    case hybrid // 衛星＋交通機関
}

struct MapView: View {
    // 検索キーワード
    let searchKey: String
    // マップ種類
    let mapType: MapType
    // キーワードから取得した緯度軽度
    @State var targetCoordinate = CLLocationCoordinate2D()
    // 表示するマップの位置
    @State var cameraPosition: MapCameraPosition = .automatic
    
    // 表示するマップのスタイル
    var mapStyle: MapStyle {
        switch mapType {
        case .standard:
            return MapStyle.standard()
        case .satellite:
            return MapStyle.imagery()
        case .hybrid:
            return MapStyle.hybrid()
        }
    }
    
    var body: some View {
        Map(position: $cameraPosition){
            // マップにピンを表示
            Marker(searchKey, coordinate: targetCoordinate)
        }
        // マップのスタイルを指定
        .mapStyle(mapStyle)
        // 検索キーワードの変更を検知
        .onChange(of: searchKey, initial: true) { oldValue, newValue
            in
            // キーワードをデバッグエリアに表示
            print("検索キーワード:\(newValue)")
            // 地図の検索クエリ(命令)の作成
            let request = MKLocalSearch.Request()
            // 検索クエリにキーワードの設定
            request.naturalLanguageQuery = newValue
            // MKLocalSearchの初期化
            let search = MKLocalSearch(request: request)
            
            // 検索の開始
            search.start { response, error in
                if let mapItems = response?.mapItems,
                   let mapItem = mapItems.first {
                    // 位置情報から緯度軽度をtargetCoordinateに取り出す
                    targetCoordinate = mapItem.placemark.coordinate
                    // 緯度軽度をデバッグエリアに表示
                    print("緯度軽度：\(targetCoordinate)")
                    // 表示するマップの領域を作成
                    cameraPosition = .region(MKCoordinateRegion(
                        center : targetCoordinate,
                        latitudinalMeters: 500.0,
                        longitudinalMeters: 500.0
                    ))
                }// if
            }// search start
        } // onChange
    }
}

#Preview {
    MapView(searchKey: "東京駅", mapType: .standard)
}
