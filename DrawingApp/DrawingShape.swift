//
//  DrawingShape.swift
//  DrawingApp
//
//  Created by Raidel Almeida on 8/3/24.
//

import SwiftUI

struct DrawingShape: Shape {
    let points: [CGPoint]
    let engine = DrawingEngine()
    
    func path(in rect: CGRect) -> Path {
        engine.createPath(for: points)
    }
}

