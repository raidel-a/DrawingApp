//
//  UserDefaultColor.swift
//  DrawingApp
//
//  Created by Raidel Almeida on 8/4/24.
//

import Foundation
import SwiftUI
import Combine

class UserDefaultColor: ObservableObject {
    
    @Published var color: Color = .black
    
    var subscriptions = Set<AnyCancellable>()

    init() {
        if let data = UserDefaults.standard.data(forKey: key),
           let customColor = try? JSONDecoder().decode(
            CustomColor.self,
            from: data
           ){
            color = customColor.color
        }
        
        $color.map { color in
            CustomColor(color:  color)
        }
        .encode(encoder: JSONEncoder())
        .sink { _ in
        } receiveValue: { [unowned self] data in
            UserDefaults.standard.set(data, forKey: self.key)
        }.store(in: &subscriptions)
    }
    
    let key = "selectedColor"
    
}
