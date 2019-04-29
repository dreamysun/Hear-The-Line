//
//  Tool.swift
//  HearTheLIne
//
//  Created by Dreamy Sun on 4/17/19.
//  Copyright © 2019 ChenyuSun. All rights reserved.
//


import Foundation
import CoreGraphics
import SceneKit
import AudioKit

class Tool {
    
    // MARK: - Class Properties
    var size: CGFloat
    var distanceFromCamera: Float
    var currentMode: toolMode
    var rootNode: SCNNode?
    var toolNode: SCNNode!
    var selection: Set<SCNNode>
    
    // MARK: - Initializers
    init() {
        size = CGFloat(0.007)
        distanceFromCamera = 0.5
        currentMode = toolMode.Pen
        selection = []
       // toolNode = SCNNode()
        let image = UIImage(named: "recordicon")
        toolNode = SCNNode(geometry: SCNPlane(width: 0.7, height: 0.6))
        toolNode.geometry?.firstMaterial?.diffuse.contents = image
    }
    
    enum toolMode {
        
        case Pen
        /*
         The pen tool draws lines
         Pressing and holding should begin drawing a line
         Pinching should change the size of the pen
         */
        
        case player
   
    }
    
    // MARK: - Public Class Methods
    
    func updateSelection(withSelectedNode parentNode: SCNNode) {
        if selection.contains(parentNode) {
            selection.remove(parentNode) // bad access
            for childNode in parentNode.childNodes {
                childNode.geometry?.firstMaterial?.diffuse.contents = UIColor.white
            }
        } else {
            selection.insert(parentNode)
            for childNode in parentNode.childNodes {
                childNode.geometry?.firstMaterial?.diffuse.contents = UIColor.darkGray
            }
        }
    }
    
    func changeMode(_ newMode: toolMode) {
        self.currentMode = newMode
    }
    
    
    func pinch(_ recognizer: UIPinchGestureRecognizer) {
        switch currentMode {
        case .Pen:
            switch recognizer.state {
            case .began, .changed:
                size *= recognizer.scale
                recognizer.scale = 1
            default: break
            }
//        case .Manipulator:
//            switch recognizer.state {
//            case .began, .changed:
//                for parentNode in selection {
//                    parentNode.scale.scaleBy(Float(recognizer.scale))
//                    recognizer.scale = 1
//                }
//            default: break
//            }
             default: break
        }
    }
    
    
    private func loadNodeFromFile(filename: String, directory: String) -> SCNNode {
        if let scene = SCNScene(named: filename) {
            let retNode = SCNNode()
            scene.rootNode.childNodes.forEach({node in
                retNode.addChildNode(node)
            })
            return retNode
        } else {
            print("Invalid path supplied")
            return SCNNode()
        }
    }
    
    
 
    
}
