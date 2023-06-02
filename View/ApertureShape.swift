//
//  ApertureShapeView.swift
//  LightPlayground
//
//  Created by 蒋艺 on 2023/4/4.
//

import SwiftUI

struct ApertureShape: View {
    let aperture: any Aperture
    
    var body: some View {
        GeometryReader { geometry in
            let width = geometry.size.width
            
            Path { path in
                let rect = CGRect(x: 0 ,
                                  y: 0,
                                  width: width  ,
                                  height: width )
                path.addPath(aperture.path(in: rect))
            }
        }
    }
}

struct ApertureShape_Previews: PreviewProvider {
    static var previews: some View {
        ScrollView{
            ForEach(defaultApertures, id: \.id) { aperture in
                ApertureShape(aperture: aperture)
                .frame(width: 200, height: 200)
                .background(.secondary)
            }
        }
    }
}
