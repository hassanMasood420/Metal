//
//  FilterViewModel.swift
//  NewApp
//
//  Created by Hassan on 25/11/2023.
//

import SwiftUI

/// ViewModel responsible for managing the application of filters to an image.
class FiltersViewModel: ObservableObject {
    /// The original image to be processed and displayed.
    @Published var originalImage: UIImage?
    
    /// The array of filtered images generated from applying filters to the original image.
    @Published var filteredImages: [FilteredImage?] = []
    
    /// Error message to be displayed in case of issues with the original image or filter application.
    @Published var errorMessage: String?

    /// The manager responsible for applying filters to the image.
    private let filterManager: FilterManager

    /// Initializes the FiltersViewModel with a FilterManager.
    /// - Parameter filterManager: The manager responsible for applying filters to the image.
    init(filterManager: FilterManager) {
        self.filterManager = filterManager
    }

    /// Applies filters to the original image using the configured FilterManager.
    func applyFilters() {
        guard let originalImage = originalImage else {
            errorMessage = "Original image is nil."
            return
        }

        filterManager.applyFilters(to: originalImage) { [weak self] filteredImages in
            DispatchQueue.main.async {
                self?.filteredImages = filteredImages
            }
        }
    }
}
