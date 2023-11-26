//
//  Filters.swift
//  NewApp
//
//  Created by Hassan on 25/11/2023.
//

import Foundation

/// A filter to apply sepia effect using Metal.
class SepiaFilter: Filter {
    let filterKernelName: String = "sepiaFilter"
    var displayName: String
    
    /// Initializes a SepiaFilter with a given display name.
    /// - Parameter displayName: The display name for the filter.
    init(displayName: String) {
        self.displayName = displayName
    }
}

/// A filter to apply grayscale effect using Metal.
class GrayscaleFilter: Filter {
    let filterKernelName: String = "grayscaleFilter"
    var displayName: String
    
    /// Initializes a GrayscaleFilter with a given display name.
    /// - Parameter displayName: The display name for the filter.
    init(displayName: String) {
        self.displayName = displayName
    }
}

/// A filter to invert colors using Metal.
class InvertFilter: Filter {
    let filterKernelName: String = "invertFilter"
    var displayName: String
    
    /// Initializes an InvertFilter with a given display name.
    /// - Parameter displayName: The display name for the filter.
    init(displayName: String) {
        self.displayName = displayName
    }
}

/// A filter to apply vignette effect using Metal.
class VignetteFilter: Filter {
    let filterKernelName: String = "vignetteFilter"
    var displayName: String
    
    /// Initializes a VignetteFilter with a given display name.
    /// - Parameter displayName: The display name for the filter.
    init(displayName: String) {
        self.displayName = displayName
    }
}

/// A filter to apply a gold-toned effect using Metal.
class GoldFilter: Filter {
    let filterKernelName: String = "goldFilter"
    var displayName: String
    
    /// Initializes a GoldFilter with a given display name.
    /// - Parameter displayName: The display name for the filter.
    init(displayName: String) {
        self.displayName = displayName
    }
}
