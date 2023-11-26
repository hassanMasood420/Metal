//
//  FilteredImageModel.swift
//  NewApp
//
//  Created by Hassan on 26/11/2023.
//

import UIKit

/// A representation of an image after applying a filter.
struct FilteredImage: Equatable {
    /// The filtered image.
    let image: UIImage

    /// The name of the filter applied to generate the image.
    let filterName: String
}
