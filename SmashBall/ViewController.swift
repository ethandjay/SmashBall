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
    
    var player: AVAudioPlayer!
    
    @IBOutlet var sceneView: ARSCNView!

    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var timeField: UILabel!
    @IBOutlet weak var livesLabel: UILabel!
    @IBOutlet weak var livesField: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var scoreField: UILabel!
    
    @IBOutlet weak var powerUp1Field: UIBarButtonItem!
    @IBOutlet weak var powerUp2Field: UIBarButtonItem!
    @IBOutlet weak var powerUp3Field: UIBarButtonItem!
    @IBOutlet weak var powerUp4Field: UIBarButtonItem!
    @IBOutlet weak var powerUp5Field: UIBarButtonItem!
    
    @IBAction func powerUp1(_ sender: Any) {
    }
    @IBAction func powerUp2(_ sender: Any) {
    }
    @IBAction func powerUp3(_ sender: Any) {
    }
    @IBAction func powerUp4(_ sender: Any) {
    }
    @IBAction func powerUp5(_ sender: Any) {
    }
    
    
    var scoreValue: Int = 0
    var lifeValue: Int = 3
    var timeValue: Int = 0
    
    var timer = Timer()
    var minutes: Int = 0
    var seconds: Int = 0
    
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
        
        livesField.text = String(3)
        
        //timer code found here: https://blog.apoorvmote.com/create-simple-stopwatch-with-nstimer-swift/
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(ViewController.counter), userInfo: nil, repeats: true)
    }
    
    @objc func counter() {
        seconds += 1
        if seconds == 60 {
            minutes += 1
            seconds = 0
        }
        
        if minutes < 10 {
            if seconds < 10 {
                timeField.text = String(0) + String(minutes) + ":" + String(0) + String(seconds)
            }
            else {
                timeField.text = String(0) + String(minutes) + ":" + String(seconds)
            }
        }
        else {
            if seconds < 10 {
                timeField.text = String(minutes) + ":" + String(0) + String(seconds)
            }
            else {
                timeField.text = String(minutes) + ":" + String(seconds)
            }
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        
        // Run the view's session
        sceneView.session.run(configuration)
        
        Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(addObject), userInfo: nil, repeats: true)
        
        Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(addPowerUp), userInfo: nil, repeats: true)
        
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
        
        let sphere = SCNSphere(radius: 0.1)
        sphere.firstMaterial?.diffuse.contents = UIImage(named: "metal.jpg")
        let edge = SCNMaterial()
        edge.shininess = 50.0
        
        let node = SCNNode(geometry: sphere)
        node.name = "ball"
        node.position = position
        
        sceneView.scene.rootNode.addChildNode(node)
        
        let randSpeed = SCNVector3(-xPos/5, -yPos/5, -zPos/5)
        node.physicsBody = SCNPhysicsBody(type: .dynamic, shape: nil)
        node.physicsBody?.isAffectedByGravity = false
        node.physicsBody?.applyForce(randSpeed, asImpulse: true)
        
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
        
        let chosenNumber = Int(arc4random_uniform(4))
        let colors = [UIColor.white, UIColor.blue, UIColor.red, UIColor.brown]
        
        let sphere = SCNSphere(radius: 0.1)
        sphere.firstMaterial?.diffuse.contents = colors[chosenNumber]
        let node = SCNNode(geometry: sphere)
        
        if chosenNumber == 0
        {
            node.name = "white"
        }
        if chosenNumber == 1
        {
            node.name = "blue"
        }
        if chosenNumber == 2
        {
            node.name = "red"
        }
        if chosenNumber == 3
        {
            node.name = "brown"
        }
        
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
                
                if node.name == "red" {
                    scoreValue += 5
                    scoreField.text = String(scoreValue)
                    node.removeFromParentNode()
                }
                
                if node.name == "blue" {
                    lifeValue += 1
                    livesField.text = String(lifeValue)
                    node.removeFromParentNode()
                }
                
                if node.name == "ball" {
                    self.playSoundEffect(ofType: .collision)
                    scoreValue += 15
                    scoreField.text = String(scoreValue)
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
    
    func playSoundEffect(ofType effect: SoundEffect) {
        do {
            guard let effectURL = Bundle.main.url(forResource: effect.rawValue, withExtension: "mp3") else { return }
            self.player = try AVAudioPlayer(contentsOf: effectURL)
            self.player.play()
        } catch let error as NSError {
            print(error.description)
        }
    }
    
    enum SoundEffect: String {
        case collision = "collision"
    }
    
}
