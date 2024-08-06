//
//  DrawingView.swift
//  DrawingApp
//
//  Created by Raidel Almeida on 8/2/24.
//

import SwiftUI

struct DrawingView: View {
    // MARK: Internal

    let engine = DrawingEngine()

    var body: some View {
        VStack {
            HStack {
                
                CustomSlider(
                    value: $selectedLineWidth,
                    in: 1...20,
                    step: 1,
                    userDefaultColor: selectedColor
                )
                .frame(maxWidth: 150)
                .padding(.leading)

                Text(String(format: "%.0f", self.selectedLineWidth))
                    .frame(minWidth: 20)

                Button {
                    let last = self.drawingDoc.lines.removeLast()
                    self.deletedLines.append(last)
                } label: {
                    Image(systemName: "arrow.uturn.backward.circle")
                        .imageScale(.large)
                }.disabled(self.drawingDoc.lines.count == 0)
                    .padding(.leading)

                Button {
                    let last = self.deletedLines.removeLast()
                    self.drawingDoc.lines.append(last)
                } label: {
                    Image(systemName: "arrow.uturn.forward.circle")
                        .imageScale(.large)
                }.disabled(self.deletedLines.count == 0)

                Menu {
                    Text("Are you sure?")
                    Button("Delete", role: .destructive, action: {
                        self.drawingDoc.lines = [Line]()
                        self.deletedLines = [Line]()
                    }).tint(.red)
                } label: {
                    Label("Trash", systemImage: "trash.circle")
                        .labelStyle(.iconOnly)
                        .tint(.red)
                        .imageScale(.large)
                }
                .disabled(self.drawingDoc.lines.count == 0 && self.deletedLines.count == 0)
                .padding(.leading)
            }.frame(minHeight: 60)

            //            GeometryReader { geometry in
            //                ZStack {
            //                    Color.white
            //
            //                    ForEach(lines) { line in
            //                        DrawingShape(points: line.points)
            //                            .stroke(line.color,
            //                                    style: StrokeStyle(
            //                                        lineWidth: line.lineWidth,
            //                                        lineCap: .round, lineJoin: .round
            //                                    ))
            //                    }
            //                }

            Canvas {
                context,
                    _ in
                for line in self.drawingDoc.lines {
                    let path = self.engine.createPath(for: line.points)
                    // //                    path.addLines(line.points)

                    // //                    context.stroke(path, with: .color(line.color), lineWidth:
                    // //                        line.lineWidth)
                    context.stroke(
                        path,
                        with: .color(line.color),
                        style: StrokeStyle(
                            lineWidth: line.lineWidth,
                            lineCap: .round, lineJoin: .round
                        )
                    )

                    // //                    for point in line.points {
                    // //                        context.draw(Image(systemName: "plus"), at: point)
                    // //                    }
                }
            }

            .gesture(
                DragGesture(minimumDistance: 0, coordinateSpace: .local)
                    .onChanged { value in
                        let newPoint = value.location
                        if newPoint.x >= 0,
                           //                                newPoint.x <= geometry.size.width,
                           newPoint.y >= 0
                        //                                , newPoint.y <= geometry.size.height
                        {
                            if value.translation.width + value.translation.height == 0 {
                                self.drawingDoc.lines.append(
                                    Line(
                                        points: [newPoint],
                                        color: self.selectedColor.color,
                                        lineWidth: self.selectedLineWidth
                                    ))
                            } else {
                                let index = self.drawingDoc.lines.count - 1
                                self.drawingDoc.lines[index].points.append(newPoint)
                            }
                        }
                    }
                    .onEnded { _ in
                        if let last = drawingDoc.lines.last?.points, last.isEmpty {
                            self.drawingDoc.lines.removeLast()
                        }
                    }
            )
        }
        .onChange(of: scenePhase) {
            if self.scenePhase == .background {
                self.drawingDoc.save()
            }
        }
    }

//    }

    // MARK: Private

    @Environment(\.scenePhase) var scenePhase

    @State private var showConfirmation: Bool = false

//    @State private var lines = [Line]()
    @StateObject private var drawingDoc = DrawingDocument()
    @State private var deletedLines = [Line]()

    @StateObject var selectedColor = UserDefaultColor()
//    @State private var selectedColor: Color = .black
    @SceneStorage("selectedLineWidth") var selectedLineWidth: Double = 10
}

#Preview {
    DrawingView()
}
