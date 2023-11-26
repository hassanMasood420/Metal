//
//  FilterManager.swift
//  NewApp
//
//  Created by Hassan on 25/11/2023.
//

import UIKit
import MetalKit



/// Manages the application of filters to images using Metal.
class FilterManager {
    /// The Metal filter processor responsible for applying filters.
    private let metalFilter: MetalFilterProcessor
    
    /// The array of filters to be applied.
    private let filters: [Filter]
    
    /// Initializes a `FilterManager` with the specified filters.
    /// - Parameter filters: The array of filters to be applied.
    /// - Returns: An initialized `FilterManager` instance, or `nil` if there was an error initializing the Metal filter processor.
    init?(filters: [Filter]) {
        do {
            self.metalFilter = try MetalFilterProcessor(filterNames: filters)
        } catch {
            return nil
        }
        
        self.filters = filters
    }
    
    /// Applies the configured filters to the given image asynchronously.
    /// - Parameters:
    ///   - image: The input image to which filters will be applied.
    ///   - completion: A closure called upon completion with an array of filtered images.
    func applyFilters(to image: UIImage, completion: @escaping ([FilteredImage]) -> ()) {
        
        guard let cgImage = image.cgImage else {
            completion([])
            return
        }
        
        let context = CIContext()
        
        MTKTextureLoader(device: MetalFilterProcessor.metalDevice).newTexture(cgImage: cgImage, options: nil, completionHandler: { metalTexture, error in
            
            guard let metalTexture = metalTexture else {
                completion([])
                return
            }
            
            var filteredImages: [FilteredImage] = []
            
            for (index, filter) in self.filters.enumerated() {
                let outputTextureDescriptor = MTLTextureDescriptor.texture2DDescriptor(
                    pixelFormat: metalTexture.pixelFormat,
                    width: metalTexture.width,
                    height: metalTexture.height,
                    mipmapped: false
                )
                
                outputTextureDescriptor.usage = [.shaderRead, .shaderWrite]
                
                guard let outputTexture = MetalFilterProcessor.metalDevice.makeTexture(descriptor: outputTextureDescriptor) else {
                    continue
                }
                
                self.metalFilter.applyFilter(filterIndex: index, to: metalTexture, outputTexture: outputTexture)
                
                guard let ciImageFromMetal = CIImage(mtlTexture: outputTexture, options: nil),
                      let cgImageFromMetal = context.createCGImage(ciImageFromMetal, from: ciImageFromMetal.extent) else {
                    continue
                }
                
                let filteredImage = UIImage(cgImage: cgImageFromMetal)
                filteredImages.append(FilteredImage(image: filteredImage, filterName: filter.displayName))
            }
            
            completion(filteredImages)
        })
    }
}

