//
//  DrawingEngine.swift
//  DrawingApp
//
//  Created by Raidel Almeida on 8/3/24.
//

import Foundation
import SwiftUI

class DrawingEngine {
    func createPath(for points: [CGPoint]) -> Path {
        var path = Path()

        if let firstPoint = points.first {
            path.move(to: firstPoint)
        }

        for index in 1 ..< points.count {
            let mid = calculateMidPoint(points[index - 1], points[index])
            path.addQuadCurve(to: mid, control: points[index - 1])
        }

        if let last = points.last {
            path.addLine(to: last)
        }
        return path
    }

    func calculateMidPoint(_ startPoint: CGPoint, _ endPoint: CGPoint) -> CGPoint {
        let midX = (startPoint.x + endPoint.x) / 2
        let midY = (startPoint.y + endPoint.y) / 2
        return CGPoint(x: midX, y: midY)
    }
}
