//
//  ContentView.swift
//  ModelPickerApp
//
//  Created by koki isshiki on 13.11.20.
//

import SwiftUI
import RealityKit
import ARKit
import FocusEntity

struct ContentView : View {
    @State private var isPlacementEnabled = false
    @State private var selectedModel: Model?
    @State private var modelConfirmedForPlacement: Model?
        
    private var models: [Model] = {
        //dynamic get our model file
        let filemanager = FileManager.default
        
        guard let path  = Bundle.main.resourcePath, let files = try?
                filemanager.contentsOfDirectory(atPath: path) else{
            return[]
        }
        
        var availableModels: [Model] = []
        for filename in files where filename.hasSuffix("usdz") {
            let modelName = filename.replacingOccurrences(of: ".usdz", with: "")
            let model = Model(modelName: modelName)
            
            availableModels.append(model)
        }
        return availableModels
    }()
    
    
    
    var body: some View {
        ZStack(alignment: .bottom) {
            ARViewContainer(modelConfirmedForPlacement: self.$modelConfirmedForPlacement)
            
            if self.isPlacementEnabled {
                PlacementButtonView(
                    isPlacementEnabled: self.$isPlacementEnabled,
                    selectedModel: self.$selectedModel,
                    modelConfirmedForPlacement: self.$modelConfirmedForPlacement
                )
            } else {
                ModelPickerView(
                    isPlacementEnabled: self.$isPlacementEnabled, selectedModel: self.$selectedModel, models: self.models
                )
            }
        }
    }
}

struct ARViewContainer: UIViewRepresentable {
    @Binding var modelConfirmedForPlacement: Model?
    
    func makeUIView(context: Context) -> ARView {
        
        let arView = CustomARView(frame: .zero)//ARView(frame: .zero)
        
        return arView
        
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {
        if let model = self.modelConfirmedForPlacement {
            
            if let modelEntity = model.modelEntity{
                print("DEBUG: adding model to scene \(model.modelName)")
                
                let anchorEntity = AnchorEntity(plane: .any)
                anchorEntity.addChild(modelEntity)
                
                uiView.scene.addAnchor(anchorEntity)
            }else{
                print("DEBUG: Uncable to load model to schene: \(model.modelName)")
            }
            
            
            
            DispatchQueue.main.async {
                self.modelConfirmedForPlacement = nil
            }
        }
    }
}

class CustomARView: ARView {
    let focusSquare = FESquare()
    
    required init(frame frameRect: CGRect) {
        super.init(frame: frameRect)
        
        focusSquare.viewDelegate = self
        focusSquare.delegate = self
        focusSquare.setAutoUpdate(to: true)
        
        self.setupARView()
    }
    @objc required dynamic init?(coder decoder: NSCoder) {
        fatalError("init(coder:) hanst been implemented")
    }
    
    func setupARView() {
        let config = ARWorldTrackingConfiguration()
        config.planeDetection = [.horizontal, .vertical]
        config.environmentTexturing = .automatic
        
        if ARWorldTrackingConfiguration.supportsSceneReconstruction(.mesh) {
            config.sceneReconstruction = .mesh
        }
        
        self.session.run(config)
        
    }
}

extension CustomARView: FEDelegate {
    func toTrackingState() {
        print("tracking")
    }
    func toInitializingState(){
        print("initializing")
    }
}

struct ModelPickerView: View {
    @Binding var isPlacementEnabled: Bool
    @Binding var selectedModel: Model?
    
    var models:[Model]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 20){
                ForEach(0 ..< self.models.count){ index in
                    Button(action: {
                        print("DEBUG: selected model with name: \(self.models[index].modelName)")
                        
                        self.selectedModel = self.models[index]
                        self.isPlacementEnabled = true
                    }) {
                        Image(uiImage: self.models[index].image)
                            .resizable()
                            .frame(height: 80)
                            .aspectRatio(1/1, contentMode: .fit)
                            .background(Color.white)
                            .cornerRadius(12)
                    }.buttonStyle(PlainButtonStyle())
                }
            }
        }
        .padding(10)
        .background(Color.black.opacity(0.5))
    }
}

struct PlacementButtonView: View{
    @Binding var isPlacementEnabled: Bool
    @Binding var selectedModel: Model?
    @Binding var modelConfirmedForPlacement: Model?

    
    var body: some View{
        HStack {
            //cancel button
            Button(action: {
                print("DEBUG: Cancel model placement.")
                self.resetPlacementParameters()
            }) {
                Image(systemName: "xmark")
                    .frame(width: 60, height: 60)
                    .font(.title)
                    .background(Color.white.opacity(0.75))
                    .cornerRadius(30)
                    .padding(20)
            }
            
            Button(action: {
                print("DEBUG: model placement Confirmed .")
                self.modelConfirmedForPlacement = self.selectedModel
                self.resetPlacementParameters()
            }) {
                Image(systemName: "checkmark")
                    .frame(width: 60, height: 60)
                    .font(.title)
                    .background(Color.white.opacity(0.75))
                    .cornerRadius(30)
                    .padding(20)
            }
        }
    }
    
    func resetPlacementParameters(){
        self.isPlacementEnabled = false
        self.selectedModel = nil
    }
}

#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
