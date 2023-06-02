//
//  AperturePickerView.swift
//  
//
//  Created by 蒋艺 on 2023/4/6.
//

import SwiftUI

struct AperturePickerView: View {
    @Binding var selectedAperture: (any Aperture)
    let cgColor: CGColor
    
    let gridItemLayout = [GridItem](repeating: GridItem(), count: 4)
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: gridItemLayout,alignment: .center ) {
                ForEach(defaultApertures, id: \.id) { apertureOption in
                    ApertureShape(aperture: apertureOption)
                        .scaleEffect(CGSize(width: 5, height: 5))
                        .foregroundColor(Color(cgColor: cgColor))
                        .aspectRatio(contentMode: .fit)
                        .overlay(content: {
                            RoundedRectangle(cornerRadius: 20)
                                .strokeBorder(lineWidth: 3)
                                .foregroundColor(.secondary)
                        })
                        .overlay(alignment: .topTrailing, content: {
                            if apertureOption.id == selectedAperture.id {
                                Image(systemName: "checkmark.circle")
                                    .font(.title)
                                    .foregroundColor(Color(cgColor: cgColor))
                            }
                        })
                        .onTapGesture {
                            selectedAperture = apertureOption
                        }
                }
            }
        }
    }
}

struct AperturePickerView_Previews: PreviewProvider {
    static var previews: some View {
        AperturePickerView( selectedAperture: .constant(defaultApertures[0]), cgColor: UIColor.red.cgColor)
    }
}
