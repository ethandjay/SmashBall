//
//  ViewController.swift
//  SmashBall
//
//  Created by Vu Ngo on 14.11.17.
//  Copyright © 2017 Vu Ngo. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {
    
    @IBOutlet var sceneView: ARSCNView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var livesLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Create a new scene
        let scene = SCNScene()
        
        // Set the scene to the view
        sceneView.scene = scene
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        
        // Run the view's session
        sceneView.session.run(configuration)
        
        Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(addObject), userInfo: nil, repeats: true)
        
        Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(addPowerUp), userInfo: nil, repeats: true)
        
        print("test")
        print("test2")
        
    }
    
    @objc func addObject(){
        /*let ship = SpaceShip()
         ship.loadModal()*/
        
        var xPos:Float, yPos:Float, zPos:Float
        //repeat {
        xPos = randomPosition(lowerBound: -10.0 , upperBound: 10.0)
        yPos = randomPosition(lowerBound: 1.5, upperBound: 1.5)
        zPos = randomPosition(lowerBound: -6.0, upperBound: 6.0)
        //} while node(xPos, yPos, zPos) < 6
        
        let position = SCNVector3Make(xPos, yPos, zPos)
        
        let colors = [UIColor.darkGray]
        
        let sphere = SCNSphere(radius: 0.1)
        sphere.firstMaterial?.diffuse.contents = colors[Int(arc4random_uniform(1))]
        let node = SCNNode(geometry: sphere)
        node.name = "ball"
        node.position = position
        
        sceneView.scene.rootNode.addChildNode(node)
        
        let randSpeed = SCNVector3(-xPos/5, -yPos/5, -zPos/5)
        node.physicsBody = SCNPhysicsBody(type: .dynamic, shape: nil)
        node.physicsBody?.isAffectedByGravity = false
        node.physicsBody?.applyForce(randSpeed, asImpulse: true)
        
        Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(updateBall), userInfo: node, repeats: true)
    }
    
    @objc func updateBall(timer: Timer) -> Void {
        //        TODO: update velocity of node; check for closeness
        let node = timer.userInfo as! SCNNode
        print(node.position.x)
    }
    
    @objc func addPowerUp(){
        /*let ship = SpaceShip()
         ship.loadModal()*/
        
        var xPos:Float, yPos:Float, zPos:Float
        //repeat {
        xPos = randomPosition(lowerBound: -10.0 , upperBound: 10.0)
        yPos = randomPosition(lowerBound: 1.5, upperBound: 1.5)
        zPos = randomPosition(lowerBound: -6.0, upperBound: 6.0)
        //} while node(xPos, yPos, zPos) < 6
        
        let position = SCNVector3Make(xPos, yPos, zPos)
        
        let colors = [UIColor.white]
        
        let sphere = SCNSphere(radius: 0.1)
        sphere.firstMaterial?.diffuse.contents = colors[Int(arc4random_uniform(1))]
        let node = SCNNode(geometry: sphere)
        node.name = "powerup"
        node.position = position
        
        sceneView.scene.rootNode.addChildNode(node)
        
        let randSpeed = SCNVector3(0, -yPos/5, 0)
        node.physicsBody = SCNPhysicsBody(type: .dynamic, shape: nil)
        node.physicsBody?.isAffectedByGravity = false
        node.physicsBody?.applyForce(randSpeed, asImpulse: true)
    }
    
    func randomPosition (lowerBound lower:Float, upperBound upper:Float) -> Float {
        return Float(arc4random()) / Float(UInt32.max) * (lower - upper) + upper
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        
        if let touch = touches.first {
            let location = touch.location(in: sceneView)
            
            let hitList = sceneView.hitTest(location, options: nil)
            
            if let hitObject = hitList.first {
                let node = hitObject.node
                
                if node.name == "ball" || node.name == "powerup" {
                    
                    node.removeFromParentNode()
                }
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    // MARK: - ARSCNViewDelegate
    
    /*
     // Override to create and configure nodes for anchors added to the view's session.
     func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
     let node = SCNNode()
     
     return node
     }
     */
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
}


