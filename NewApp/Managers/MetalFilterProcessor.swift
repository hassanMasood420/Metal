//
//  MetalFilterProcessor.swift
//  NewApp
//
//  Created by Hassan Masood on 11/23/23.
//

import Metal
import UIKit
import CoreImage
import MetalKit


/// An enumeration representing errors that may occur during Metal filter processing.
enum MetalFilterError: Error {
    /// Indicates a failure to load a Metal kernel function from the library.
    case failedToLoadKernelFunction

    /// Indicates a failure to create a Metal compute pipeline state.
    case failedToCreatePipelineState

    /// Indicates a failure to create a Metal command buffer.
    case failedToCreateCommandBuffer

    /// Indicates a failure to create a Metal compute command encoder.
    case failedToCreateComputeCommandEncoder

    /// Indicates an invalid filter index when applying a Metal filter.
    case invalidFilterIndex
}

/// A class responsible for processing image filters using Metal shaders.
class MetalFilterProcessor {
    /// The Metal device used for processing image filters.
    static let metalDevice: MTLDevice = MTLCreateSystemDefaultDevice()!
    
    /// The Metal command queue for managing command buffers.
    static let metalCommandQueue: MTLCommandQueue = metalDevice.makeCommandQueue()!
    
    /// The Metal library containing shader functions.
    private let library: MTLLibrary
    
    /// The array of Metal compute pipeline states for each image filter.
    private var metalPipelineStates: [MTLComputePipelineState] = []
    
    /// Initializes the MetalFilterProcessor with a list of image filters.
    /// - Parameter filterNames: An array of Filter objects representing the image filters.
    /// - Throws: A MetalFilterError if there's an issue loading or creating Metal shader functions or pipeline states.
    init(filterNames: [Filter]) throws {
        guard let library = MetalFilterProcessor.metalDevice.makeDefaultLibrary() else {
            throw MetalFilterError.failedToLoadKernelFunction
        }
        self.library = library

        for filter in filterNames {
            guard let kernelFunction = library.makeFunction(name: filter.filterKernelName) else {
                throw MetalFilterError.failedToLoadKernelFunction
            }

            do {
                let pipelineState = try MetalFilterProcessor.metalDevice.makeComputePipelineState(function: kernelFunction)
                metalPipelineStates.append(pipelineState)
            } catch {
                throw MetalFilterError.failedToCreatePipelineState
            }
        }
    }

    /// Retrieves a Metal shader function by name from the Metal library.
    /// - Parameter name: The name of the Metal shader function.
    /// - Returns: The Metal shader function if found, otherwise nil.
    func makeFunction(name: String) -> MTLFunction? {
        return self.library.makeFunction(name: name)
    }

    /// Applies a specified image filter to the source texture and stores the result in the output texture.
    /// - Parameters:
    ///   - filterIndex: The index of the image filter in the array of pipeline states.
    ///   - sourceTexture: The source texture to apply the filter to.
    ///   - outputTexture: The texture to store the filtered result.
    /// - `Discussion: May not be able to process large images`
    func applyFilter(filterIndex: Int, to sourceTexture: MTLTexture, outputTexture: MTLTexture){
        guard filterIndex >= 0, filterIndex < metalPipelineStates.count else {
            return
        }

        let commandBuffer = Self.metalCommandQueue.makeCommandBuffer()
        guard let commandBuffer = commandBuffer else {
            return
        }

        guard let computeCommandEncoder = commandBuffer.makeComputeCommandEncoder() else {
            return
        }

        computeCommandEncoder.setComputePipelineState(metalPipelineStates[filterIndex])
        computeCommandEncoder.setTexture(sourceTexture, index: 0)
        computeCommandEncoder.setTexture(outputTexture, index: 1)

        let threadgroupCount = MTLSize(width: 8, height: 8, depth: 1)
        let threadgroups = MTLSize(
            width: (sourceTexture.width + threadgroupCount.width - 1) / threadgroupCount.width,
            height: (sourceTexture.height + threadgroupCount.height - 1) / threadgroupCount.height,
            depth: 1
        )

        computeCommandEncoder.dispatchThreadgroups(threadgroups, threadsPerThreadgroup: threadgroupCount)
        computeCommandEncoder.endEncoding()

        commandBuffer.commit()
    }

}








