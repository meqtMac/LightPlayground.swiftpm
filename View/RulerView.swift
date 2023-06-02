//
//  RulerView.swift
//  LightPlayground
//
//  Created by 蒋艺 on 2023/4/2.
//

import SwiftUI

/// A view that displays a ruler with centimeter markings.
struct RulerView: View {
    /// length or ruler in meters
    let length: CGFloat
    /// length of interval length presented by tick, cm, mm for example
    let tickLength: CGFloat
    /// upper Limit that marker can move to
    let upperLimit: CGFloat
    @Binding var position: CGFloat
    let showText: Bool
    let showMark: Bool
    var ratio: CGFloat
    init(length: CGFloat,
         tickLength: CGFloat,
         position: Binding<CGFloat>,
         showMark: Bool = true,
         showText: Bool = true
    ) {
        self.length = length
        self.tickLength = tickLength
        self._position = position
        self.upperLimit = length-0.01
        self.showMark = showMark
        self.showText = showText && showMark
        ratio = 3
        if self.showMark {
            ratio += 2.2
        }
        self.ratio = length/tickLength/ratio
    }
    
    /// Initializes a new `RulerView`.
    ///
    /// - Parameters:
    ///     - length: The length of the ruler in meters.
    ///     - orientation: The orientation of the ruler.
    ///     - tickLength: The size of the primary ticks.
    init(length: CGFloat,
         tickLength: TickUnit,
         position: Binding<CGFloat>,
         showMark: Bool = true,
         showText: Bool = true
    ) {
        
        self.init(
            length: length,
            tickLength: tickLength.rawValue,
            position: position,
            showMark: showMark,
            showText: showText
        )
    }
    
    
    var body: some View {
        GeometryReader { geometry in
            let tickCount = Int( length / tickLength )
            let tickSize =  geometry.size.width / CGFloat(tickCount)
            let lengthTextOffset = CGSize(
                width: position / length * geometry.size.width + tickSize ,
                height: 2.2*tickSize)
            
            HStack(spacing: 0) {
                ForEach(0...tickCount, id: \.self) { index in
                    Rectangle()
                        .fill(.primary)
                        .frame(width: 2, height: index % 10 == 0 ? 3*tickSize : tickSize, alignment: .leading)
                        .frame(width: tickSize)
                }
            }
            .offset(x: -tickSize/2, y: 0*tickSize)
            if showMark {
                Image(systemName: "arrow.up")
                    .font(.system(size: tickSize*3).bold())
                    .offset(x: position / length * geometry.size.width  - 1.5*tickSize, y: 2*tickSize)
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                position = (value.startLocation.x + value.translation.width) / geometry.size.width * length
                                position = max(0, min(upperLimit, position))
                            }
                    )
            }
            if showText{
                Text(TickUnit.lengthMark(position))
                    .font(.system(size: tickSize*3))
                    .offset(lengthTextOffset)
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                position = (value.startLocation.x + value.translation.width) / geometry.size.width * length
                                position = max(0, min(upperLimit, position))
                            }
                    )
            }
        }
        .aspectRatio(ratio, contentMode: .fit)
        
    }
    
    var lengthMark: String{
        TickUnit.lengthMark(length)
    }
    
    /// The orientation of the ruler.
    enum Orientation {
        case horizontal
        case vertical
    }
    
    /// The size of ticks
    enum TickUnit: CGFloat, CaseIterable{
        case m = 1
        case km = 1e3
        case dm =  0.1
        case cm = 0.01
        case mm = 1e-3
        case um = 1e-6
        case nm = 1e-9
        
        var unitMark: String {
            switch self {
                case .m:
                    return "m"
                case .km:
                    return "km"
                case .dm:
                    return "dm"
                case .cm:
                    return "cm"
                case .mm:
                    return "mm"
                case .um:
                    return "um"
                case .nm:
                    return "nm"
            }
        }
        
        static func lengthMark(_ length: CGFloat) -> String {
            let unitCandit = TickUnit.allCases.sorted(by: {abs($0.rawValue - length) < abs($1.rawValue - length)} ).first
            if let unit = unitCandit {
                return String(format: "%.3f", length/unit.rawValue)+unit.unitMark
            }else{
                return String(format: "%.3f", length) + m.unitMark
            }
        }
    }
}

struct RulerView_Previews: PreviewProvider {
    static var previews: some View {
        let length: CGFloat = 1.5
        let tickLength = 0.01
        VStack{
            RulerView(length: length,
                      tickLength: tickLength,
                      position: .constant(1))
            .roundedBorder(radius: 20, lineWidth: 1)
            .padding()
            .roundedBorder(radius: 20, lineWidth: 5)
            
            RulerView(length: length,
                      tickLength: tickLength,
                      position: .constant(1),
                      showText: false)
            .roundedBorder(radius: 20, lineWidth: 1)
            .padding()
            .roundedBorder(radius: 20, lineWidth: 5)
            
            
            RulerView(length: length,
                      tickLength: tickLength,
                      position: .constant(1),
                      showMark: false)
            .roundedBorder(radius: 20, lineWidth: 1)
            .padding()
            .roundedBorder(radius: 20, lineWidth: 5)
        }
    }
    
}
