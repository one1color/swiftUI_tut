//
//  Model.swift
//  ModelPickerApp
//
//  Created by koki isshiki on 15.11.20.
//

import UIKit
import RealityKit
import Combine

class Model {
    var modelName: String
    var image: UIImage
    var modelEntity: ModelEntity?
    
    private var cancellabel: AnyCancellable? = nil
    
    init(modelName: String) {
        self.modelName = modelName
        
        self.image = UIImage(named: modelName)!
        
        let filename = modelName + ".usdz"
        self.cancellabel = ModelEntity.loadModelAsync(named: filename)
            .sink(receiveCompletion: { loadCompetition in
                print("DEBUG: Unable to load modelEntity for modelName: \(self.modelName)")
            
            }, receiveValue: { modelEntity in
                self.modelEntity = modelEntity
                print("DEBUG: Successfully loaded modelEntity for modelName: \(self.modelName)")
                
            })
        
    }
}
