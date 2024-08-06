//
//  SwiftUIView.swift
//  DrawingApp
//
//  Created by Raidel Almeida on 8/4/24.
//

import SwiftUI

struct CustomSlider<Label: View, MinLabel: View, MaxLabel: View>: View {
    @Binding var value: Double
    let range: ClosedRange<Double>
    let step: Double
    let label: () -> Label
    let minimumValueLabel: () -> MinLabel
    let maximumValueLabel: () -> MaxLabel
    var onEditingChanged: ((Bool) -> Void)?
    
    @ObservedObject var userDefaultColor: UserDefaultColor
    
    let trackHeight: CGFloat = 5
    let thumbSize: CGSize = CGSize(width: 25, height: 25)
    
    let trackColor: Color = .gray.opacity(0.3)
    let filledTrackColor: Color = .gray
    
    @State private var isDragging = false
    
    init(
        value: Binding<Double>,
        in range: ClosedRange<Double>,
        step: Double = 1.0,
        userDefaultColor: UserDefaultColor,
        @ViewBuilder label: @escaping () -> Label,
        @ViewBuilder minimumValueLabel: @escaping () -> MinLabel,
        @ViewBuilder maximumValueLabel: @escaping () -> MaxLabel,
        onEditingChanged: ((Bool) -> Void)? = nil
    ) {
        self._value = value
        self.range = range
        self.step = step
        self.userDefaultColor = userDefaultColor
        self.label = label
        self.minimumValueLabel = minimumValueLabel
        self.maximumValueLabel = maximumValueLabel
        self.onEditingChanged = onEditingChanged
    }
    
    var body: some View {
        VStack {
            label()
            
            HStack(alignment: .center, spacing: 15) {
                minimumValueLabel()
                
                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                            // Track
                        Capsule()
                            .fill(trackColor)
                            .frame(height: trackHeight)
                        
                            // Filled Track
                        Capsule()
                            .fill(filledTrackColor)
                            .frame(width: thumbPosition(in: geometry), height: trackHeight)
                        
                            // Thumb (Color Picker)
                        ColorPicker("", selection: $userDefaultColor.color)
                            .labelsHidden()
                            .frame(width: thumbSize.width, height: thumbSize.height)
                            .offset(x: thumbPosition(in: geometry) - thumbSize.width / 2)
                            .gesture(
                                DragGesture()
                                    .onChanged { gesture in
                                        isDragging = true
                                        updateValue(dragLocation: gesture.location, in: geometry)
                                        onEditingChanged?(true)
                                    }
                                    .onEnded { _ in
                                        isDragging = false
                                        onEditingChanged?(false)
                                    }
                            )
                    }
                }
                .frame(height: thumbSize.height)
                
                maximumValueLabel()
            }
        }
    }
    
    private func thumbPosition(in geometry: GeometryProxy) -> CGFloat {
        let percentage = (value - range.lowerBound) / (range.upperBound - range.lowerBound)
        return geometry.size.width * CGFloat(percentage)
    }
    
    private func updateValue(dragLocation: CGPoint, in geometry: GeometryProxy) {
        let percentage = dragLocation.x / geometry.size.width
        let newValue = range.lowerBound + (range.upperBound - range.lowerBound) * Double(percentage)
        let steppedValue = round((newValue - range.lowerBound) / step) * step + range.lowerBound
        value = max(range.lowerBound, min(steppedValue, range.upperBound))
    }
}

    // Extension for the version without labels
extension CustomSlider where Label == EmptyView, MinLabel == EmptyView, MaxLabel == EmptyView {
    init(
        value: Binding<Double>,
        in range: ClosedRange<Double>,
        step: Double = 1.0,
        userDefaultColor: UserDefaultColor,
        onEditingChanged: ((Bool) -> Void)? = nil
    ) {
        self.init(
            value: value,
            in: range,
            step: step,
            userDefaultColor: userDefaultColor,
            label: { EmptyView() },
            minimumValueLabel: { EmptyView() },
            maximumValueLabel: { EmptyView() },
            onEditingChanged: onEditingChanged
        )
    }
}


//#Preview {
//    VStack(spacing: 50) {
////        CustomSlider(value: .constant(5), in: 0 ... 10)
//
//        CustomSlider(
//            value: .constant(5),
//            in: 0 ... 10,
//            step: 0.5,
//            label: { Text("With Labels") },
//            minimumValueLabel: { Text("Min") },
//            maximumValueLabel: { Text("Max") }
//        )
//
//        CustomSlider(
//            value: .constant(5),
//            in: 0 ... 10,
//            step: 1,
//            thumbSize: CGSize(width: 40, height: 40)
//        )
//    }
//    .padding()
//}
