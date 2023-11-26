//
//  Editing_AppApp.swift
//  Editing App
//
//  Created by Hassan on 22/11/2023.
//

import SwiftUI
import UIKit

@main
struct Editing_AppApp: App {

    var body: some Scene {
        WindowGroup {
            
            let filtersToApply: [Filter] = [
                SepiaFilter(displayName: "Sepia"),
                GoldFilter(displayName: "Gold"),
                VignetteFilter(displayName: "Vignette"),
                GrayscaleFilter(displayName: "Gray"),
                InvertFilter(displayName: "Invert")
            ]
            
            if let manager = FilterManager(filters: filtersToApply){
                FiltersView(image: UIImage(named: "girl") ?? UIImage(), filterManager: manager)
            }
        }
    }
}
    

