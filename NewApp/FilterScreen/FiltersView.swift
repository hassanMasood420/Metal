//
//  FiltersView.swift
//  Editing App
//
//  Created by Hassan on 24/11/2023.
//

import SwiftUI


/// View responsible for displaying an image along with a scrollable list of filter thumbnails.
struct FiltersView: View {
    @StateObject private var viewModel: FiltersViewModel
    private let image: UIImage // Image to be displayed

    /// Initializes the FiltersView with an image and a FilterManager.
    /// - Parameters:
    ///   - image: The original image to be displayed.
    ///   - filterManager: The manager responsible for applying filters to the image.
    init(image: UIImage, filterManager: FilterManager) {
        _viewModel = StateObject(wrappedValue: FiltersViewModel(filterManager: filterManager))
        self.image = image
    }


    var body: some View {
        VStack {
            if let originalImage = viewModel.originalImage {
                
                Image(uiImage: originalImage)
                    .resizable()
                    .scaledToFill()
                    .frame(maxHeight: UIScreen.main.bounds.height * 0.8)

                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        ForEach(viewModel.filteredImages.indices, id: \.self) { index in
                            if let filteredImage = viewModel.filteredImages[index] {
                                FilterThumbnailView(filteredImage: filteredImage).onTapGesture {
                                    viewModel.originalImage = filteredImage.image
                                }
                                .frame(maxWidth: UIScreen.main.bounds.width / 5)
                            }
                        }
                    }
                    .padding(.horizontal, 10)
                }
            } else {
                Text(viewModel.errorMessage ?? "")
                    .foregroundColor(.red)
            }
        }
        .onAppear {
            viewModel.originalImage = image
            viewModel.applyFilters()
        }
    }
}

//struct FiltersView_Preview: PreviewProvider {
//    static var previews: some View {
//        FiltersView(originalImage: UIImage(named: "myImage"), filters: [SepiaFilter(displayName: "Sepia")])
//    }
//}

