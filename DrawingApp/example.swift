//
//  example.swift
//  DrawingApp
//
//  Created by Raidel Almeida on 8/2/24.
//

import SwiftUI

struct example: View {
    var body: some View {
        Canvas { context, size in
            context.draw(Text("draw some'"),
                         at: CGPoint(x: size.width / 2, y: size.height / 2))

            context.draw(Image(systemName: "trash"), at: CGPoint(x: 100, y: 100))

            context.stroke(Path(roundedRect: CGRect(x: 10, y: 10, width: 100, height: 100),
                                cornerRadius: 20),
                           with: .linearGradient(Gradient(colors: [Color.red, Color.blue]),
                                                 startPoint: .zero,
                                                 endPoint: .init(x: 100, y: 100)), lineWidth: 10)
            context.drawLayer { subContext in
                subContext.clip(to: Path(roundedRect: CGRect(x: 0, y: 0, width: 200, height: 100),
                                         cornerRadius: 20))
                subContext.transform = CGAffineTransform(translationX: 10, y: -10)
                subContext.fill(Path(ellipseIn: CGRect(x: 100, y: 0, width: 200, height: 150)),
                                with: .color(.green))
            }
            context.stroke(Path(ellipseIn: CGRect(x: 100, y: 0, width: 200, height: 150)),
                           with: .color(.green))

        }.frame(width: 300, height: 300)
            .border(.blue)
    }
}

#Preview {
    example()
}
