//
//  FilterProtocol.swift
//  NewApp
//
//  Created by Hassan on 25/11/2023.
//

import Foundation

/// A protocol defining the requirements for a filter applied using Metal.
protocol Filter {
    /// The name of the Metal kernel function associated with the filter.
    var filterKernelName: String { get }
    
    /// The display name of the filter.
    var displayName: String { get set }
}
