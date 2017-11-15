//
//  SpaceShip.swift
//  SmashBall
//
//  Created by Vu Ngo on 15.11.17.
//  Copyright © 2017 Vu Ngo. All rights reserved.
//

import ARKit

class SpaceShip: SCNNode {

    func loadModal(){
        guard let virtualObjectScene = SCNScene(named: "art.scnassets/ship.scn") else {return}
        
        let wrapperNode = SCNNode()
        
        for child in virtualObjectScene.rootNode.childNodes {
            wrapperNode.addChildNode(child)
        }
        
        self.addChildNode(wrapperNode)
    }
    
}
