//
//  FilterThumbnailView.swift
//  Editing App
//
//  Created by Hassan on 24/11/2023.
//

import SwiftUI

/// A SwiftUI View representing a thumbnail of a filtered image with additional details.
struct FilterThumbnailView: View {
    /// The  image to be displayed in the thumbnail.
    let filteredImage: FilteredImage
//    let onTap: () -> Void

    var body: some View {
        VStack {
            Image(uiImage: filteredImage.image)
                .resizable()
                .scaledToFill()
                .frame(width: 80, height: 80)
                .cornerRadius(10)
//                .onTapGesture {
//                    onTap()
//                }

            Text(filteredImage.filterName)
        }
    }
}

