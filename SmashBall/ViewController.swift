//
//  ViewController.swift
//  SmashBall
//
//  Created by Vu Ngo on 14.11.17.
//  Copyright © 2017 Vu Ngo. All rights reserved.
//
//  timer code found here: https://blog.apoorvmote.com/create-simple-stopwatch-with-nstimer-swift/


import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var alertPowerUp: UILabel!
    @IBOutlet weak var highScoreButton: UIButton!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var nameLabel: UILabel!
    var player: AVAudioPlayer!
    
    @IBOutlet var sceneView: ARSCNView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var playButton: UIButton!
    
    @IBOutlet weak var timeField: UILabel!
    @IBOutlet weak var livesField: UILabel!
    @IBOutlet weak var scoreField: UILabel!
    @IBOutlet weak var gameOverLabel: UILabel!
    
    @IBOutlet weak var finalTimeLabel: UILabel!
    @IBOutlet weak var finalScoreLabel: UILabel!
    @IBOutlet weak var finalTimeField: UILabel!
    @IBOutlet weak var finalScoreField: UILabel!
    
    
    var scoreValue: Int = 0
    var lifeValue: Int = 10
    var timeValue: Int = 0
    
    var timer = Timer()
    var minutes: Int = 0
    var seconds: Int = 0
    
    var newTimer = Timer()
    var newestTimer = Timer()
    var newSeconds: Int = 11
    
    var speedClicked = false
    var doublePoints = false
    var isInvulnerable = false
    
    var blurView: UIVisualEffectView?
    
    
    @IBAction func playPressed(_ sender: Any) {
        for child in view.subviews {
            child.isHidden = false
        }
        blurView!.isHidden = true
        titleLabel.isHidden = true
        playButton.isHidden = true
        gameOverLabel.isHidden = true
        finalTimeLabel.isHidden = true
        finalScoreLabel.isHidden = true
        finalTimeField.isHidden = true
        finalScoreField.isHidden = true
        nameField.isHidden = true
        nameLabel.isHidden = true
        submitButton.isHidden = true
        highScoreButton.isHidden = true
        alertPowerUp.isHidden = true
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(ViewController.counter), userInfo: nil, repeats: true)
        
        Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(addObject), userInfo: nil, repeats: true)
        
        Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(addCoin), userInfo: nil, repeats: true)
        
        Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(addLife), userInfo: nil, repeats: true)
        
        Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(addInvincible), userInfo: nil, repeats: true)
        
        Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(addFreeze), userInfo: nil, repeats: true)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scoreValue = 0
        lifeValue = 10
        timeValue = 0
        minutes = 0
        seconds = 0
        
        speedClicked = false
        doublePoints = false
        isInvulnerable = false
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Create a new scene
        let scene = SCNScene()
        
        // Set the scene to the view
        sceneView.scene = scene
        
        livesField.text = String(lifeValue)
        scoreField.text = "0"
        livesField.font = UIFont.boldSystemFont(ofSize: 16)
        timeField.font = UIFont.boldSystemFont(ofSize: 16)
        scoreField.font = UIFont.boldSystemFont(ofSize: 16)
        
        // Load menu
        for child in view.subviews {
            child.isHidden = true
        }
        sceneView.isHidden = false
        titleLabel.isHidden = false
        playButton.isHidden = false
        highScoreButton.isHidden = false
        gameOverLabel.isHidden = true
        finalTimeLabel.isHidden = true
        finalScoreLabel.isHidden = true
        finalTimeField.isHidden = true
        finalScoreField.isHidden = true
        nameField.isHidden = true
        nameLabel.isHidden = true
        submitButton.isHidden = true
        
        let blur = UIBlurEffect(style: .light)
        blurView = UIVisualEffectView(effect: blur)
        blurView!.frame = view.bounds
        view.addSubview(blurView!)
        view.bringSubview(toFront: blurView!)
        view.bringSubview(toFront: titleLabel)
        view.bringSubview(toFront: playButton)
        view.bringSubview(toFront: highScoreButton)
    }
    
    @objc func counter() {
        
        updatePosition()
        
        checkHit()
        
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
        
        if livesField.text == String(0) {
            timer.invalidate()
            
            let blur = UIBlurEffect(style: .light)
            blurView = UIVisualEffectView(effect: blur)
            blurView!.frame = view.bounds
            view.addSubview(blurView!)
            view.addSubview(scrollView!)
            view.bringSubview(toFront: blurView!)
            view.bringSubview(toFront: gameOverLabel)
            view.bringSubview(toFront: finalTimeLabel)
            view.bringSubview(toFront: finalScoreLabel)
            view.bringSubview(toFront: finalTimeField)
            view.bringSubview(toFront: finalScoreField)
            view.bringSubview(toFront: nameField)
            view.bringSubview(toFront: nameLabel)
            view.bringSubview(toFront: submitButton)
            
            gameOverLabel.isHidden = false
            finalTimeLabel.isHidden = false
            finalScoreLabel.isHidden = false
            finalTimeField.isHidden = false
            finalScoreField.isHidden = false
            nameField.isHidden = false
            nameLabel.isHidden = false
            submitButton.isHidden = false
            
            alertPowerUp.isHidden = true
            playButton.isHidden = true
            highScoreButton.isHidden = true
            
            finalScoreField.text = String(scoreValue)
            
            if minutes < 10 {
                if seconds < 10 {
                    finalTimeField.text = String(0) + String(minutes) + ":" + String(0) + String(seconds)
                }
                else {
                    finalTimeField.text = String(0) + String(minutes) + ":" + String(seconds)
                }
            }
            else {
                if seconds < 10 {
                    finalTimeField.text = String(minutes) + ":" + String(0) + String(seconds)
                }
                else {
                    finalTimeField.text = String(minutes) + ":" + String(seconds)
                }
            }
        }
    }
    
    func updatePosition() {
        if speedClicked == false {
            for n in self.sceneView.scene.rootNode.childNodes {
                if n.name == "ball" {
                    
                    n.position.x = n.position.x - n.position.x/5
                    n.position.y = n.position.y - n.position.y/5
                    n.position.z = n.position.z - n.position.z/5
                    self.changeSpeed(xDirection: -n.position.x/5, yDirection: -n.position.y/5, zDirection: -n.position.z/5, node: n)
                    
                } else {
                    n.position.y = n.position.y - n.position.y/5
                    self.changeSpeed(xDirection: 0, yDirection: -n.position.y/5, zDirection: 0, node: n)
                }
                
            }
        }
        
    }
    
    func checkHit() {
        for n in self.sceneView.scene.rootNode.childNodes {
            if n.name == "ball" {
                if distanceToUser(xPos: n.position.x, yPos: n.position.y, zPos: n.position.z) <= 0.5 {
                    n.removeFromParentNode()
                    if isInvulnerable == false {
                        lifeValue -= 1
                        livesField.text = String(lifeValue)
                    }
                }
            } else {
                if n.position.y <= 0.5 {
                    n.removeFromParentNode()
                }
            }
        }
    }
    
    func distanceToUser (xPos: Float, yPos: Float, zPos: Float) -> Float{
        return sqrtf(xPos*xPos + yPos*yPos + zPos*zPos)
    }
    
    @IBAction func submitAction(_ sender: Any) {
        /*view.addSubview(blurView!)
        view.bringSubview(toFront: blurView!)
        view.bringSubview(toFront: titleLabel)
        view.bringSubview(toFront: playButton)
        view.bringSubview(toFront: highScoreButton)
        
        
        highScoreButton.isHidden = false
        blurView!.isHidden = false
        titleLabel.isHidden = false
        playButton.isHidden = false
        gameOverLabel.isHidden = true
        finalTimeLabel.isHidden = true
        finalScoreLabel.isHidden = true
        finalTimeField.isHidden = true
        finalScoreField.isHidden = true
        nameField.isHidden = true
        nameLabel.isHidden = true
        submitButton.isHidden = true
        highScoreButton.isHidden = false*/
        
        self.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        
        // Run the view's session
        sceneView.session.run(configuration)
        
        
        //        Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(addHeart), userInfo: nil, repeats: true)
    }
    
    @objc func addObject(){
        /*let ship = SpaceShip()
         ship.loadModal()*/
        
        if speedClicked == false {
            
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
            
            if seconds > 0 && seconds < 10 {
                changeSpeed(xDirection: -xPos/5, yDirection: -yPos/5, zDirection: -zPos/5, node: node)
            }
            if seconds >= 10 && seconds <= 15 {
                changeSpeed(xDirection: -xPos/4, yDirection: -yPos/4, zDirection: -zPos/4, node: node)
            }
            if seconds > 15 && seconds <= 20 {
                changeSpeed(xDirection: -xPos/3, yDirection: -yPos/3, zDirection: -zPos/3, node: node)
            }
            if seconds > 20 && seconds <= 40 {
                changeSpeed(xDirection: -xPos/2, yDirection: -yPos/2, zDirection: -zPos/2, node: node)
            }
            if seconds > 40 {
                changeSpeed(xDirection: -xPos/1, yDirection: -yPos/1, zDirection: -zPos/1, node: node)
            }
            
        }
        
    }
    
    func changeSpeed (xDirection: Float, yDirection: Float, zDirection: Float, node: SCNNode) {
        
        let randSpeed = SCNVector3(xDirection, yDirection, zDirection)
        node.physicsBody = SCNPhysicsBody(type: .dynamic, shape: nil)
        node.physicsBody?.isAffectedByGravity = false
        node.physicsBody?.applyForce(randSpeed, asImpulse: true)
        
    }
    
    @objc func addLife() {
        
        if speedClicked == false {
            
            var xPos:Float, yPos:Float, zPos:Float
            //repeat {
            xPos = randomPosition(lowerBound: -10.0 , upperBound: 10.0)
            yPos = randomPosition(lowerBound: 1.5, upperBound: 1.5)
            zPos = randomPosition(lowerBound: -6.0, upperBound: 6.0)
            //} while node(xPos, yPos, zPos) < 6
            
            let position = SCNVector3Make(xPos, yPos, zPos)
            
            let sphere = SCNSphere(radius: 0.1)
            sphere.firstMaterial?.diffuse.contents = UIImage(named: "life2.jpg")
            let node = SCNNode(geometry: sphere)
            node.name = "life"
            
            node.position = position
            
            sceneView.scene.rootNode.addChildNode(node)
            
            changeSpeed(xDirection: 0, yDirection: -yPos/5, zDirection: 0, node: node)
            
        }
    }
    
    @objc func addInvincible() {
        
        if speedClicked == false {
            
            var xPos:Float, yPos:Float, zPos:Float
            //repeat {
            xPos = randomPosition(lowerBound: -10.0 , upperBound: 10.0)
            yPos = randomPosition(lowerBound: 1.5, upperBound: 1.5)
            zPos = randomPosition(lowerBound: -6.0, upperBound: 6.0)
            //} while node(xPos, yPos, zPos) < 6
            
            let position = SCNVector3Make(xPos, yPos, zPos)
            
            let sphere = SCNSphere(radius: 0.1)
            sphere.firstMaterial?.diffuse.contents = UIImage(named: "invincible.jpg")
            let node = SCNNode(geometry: sphere)
            node.name = "invincible"
            
            node.position = position
            
            sceneView.scene.rootNode.addChildNode(node)
            
            changeSpeed(xDirection: 0, yDirection: -yPos/5, zDirection: 0, node: node)
            
        }
    }
    
    @objc func addFreeze() {
        
        if speedClicked == false {
            
            var xPos:Float, yPos:Float, zPos:Float
            //repeat {
            xPos = randomPosition(lowerBound: -10.0 , upperBound: 10.0)
            yPos = randomPosition(lowerBound: 1.5, upperBound: 1.5)
            zPos = randomPosition(lowerBound: -6.0, upperBound: 6.0)
            //} while node(xPos, yPos, zPos) < 6
            
            let position = SCNVector3Make(xPos, yPos, zPos)
            
            let sphere = SCNSphere(radius: 0.1)
            sphere.firstMaterial?.diffuse.contents = UIImage(named: "freeze2.jpg")
            let node = SCNNode(geometry: sphere)
            node.name = "freeze"
            
            node.position = position
            
            sceneView.scene.rootNode.addChildNode(node)
            
            changeSpeed(xDirection: 0, yDirection: -yPos/5, zDirection: 0, node: node)
            
        }
        
    }
    
    @objc func addDoublePoints() {
        
        if speedClicked == false {
            
            var xPos:Float, yPos:Float, zPos:Float
            //repeat {
            xPos = randomPosition(lowerBound: -10.0 , upperBound: 10.0)
            yPos = randomPosition(lowerBound: 1.5, upperBound: 1.5)
            zPos = randomPosition(lowerBound: -6.0, upperBound: 6.0)
            //} while node(xPos, yPos, zPos) < 6
            
            let position = SCNVector3Make(xPos, yPos, zPos)
            
            let sphere = SCNSphere(radius: 0.1)
            sphere.firstMaterial?.diffuse.contents = UIImage(named: "2xpoints.jpg")
            let node = SCNNode(geometry: sphere)
            node.name = "double"
            
            node.position = position
            
            sceneView.scene.rootNode.addChildNode(node)
            
            changeSpeed(xDirection: 0, yDirection: -yPos/5, zDirection: 0, node: node)
            
        }
        
    }
    
    @objc func addCoin() {
        
        if speedClicked == false {
            
            var coinGeometry = SCNGeometry()
            coinGeometry = SCNCylinder(radius:  0.10, height:  0.02)
            let edge = SCNMaterial()
            edge.shininess = 50.0
            edge.reflective.contents = UIImage(named: "coin_reflect.png")!
            edge.diffuse.contents = UIColor(red:1.00, green:0.84, blue:0.00, alpha:1.0)
            edge.specular.contents = UIColor.white
            
            let surface = SCNMaterial()
            surface.shininess = 50.0
            surface.reflective.contents = UIImage(named: "coin_reflect.png")!
            surface.diffuse.contents = UIColor(red:1.00, green:0.84, blue:0.00, alpha:1.0)
            surface.specular.contents = UIColor.white
            coinGeometry.materials = [edge, surface, surface]
            
            let node = SCNNode(geometry: coinGeometry)
            node.eulerAngles = SCNVector3(0, 0, CGFloat(0.5 * .pi))
            node.name = "coin"
            
            var xPos:Float, yPos:Float, zPos:Float
            xPos = randomPosition(lowerBound: -10.0 , upperBound: 10.0)
            yPos = randomPosition(lowerBound: 1.5, upperBound: 1.5)
            zPos = randomPosition(lowerBound: -6.0, upperBound: 6.0)
            
            let position = SCNVector3Make(xPos, yPos, zPos)
            node.position = position
            sceneView.scene.rootNode.addChildNode(node)
            
            changeSpeed(xDirection: 0, yDirection: -yPos/5, zDirection: 0, node: node)
            
            /*if yPos == -1.5 {
             node.removeFromParentNode()
             }*/
        }
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
                
                if node.name == "coin" {
                    self.playSoundEffect(ofType: .coin)
                    scoreValue += 30
                    if doublePoints {
                        scoreValue += 30
                    }
                    scoreField.text = String(scoreValue)
                    node.removeFromParentNode()
                    
                }
                
                // user is invulnerable for 10 seconds
                if node.name == "invincible" {
                    self.playSoundEffect(ofType: .torpedo)
                    isInvulnerable = true
                    node.removeFromParentNode()
                    alertPowerUp.text = "Invincible!"
                    alertPowerUp.isHidden = false
                    DispatchQueue.main.asyncAfter(deadline: .now() + 10.0) {
                        self.isInvulnerable = false
                        self.alertPowerUp.isHidden = true
                    }
                    
                }
                
                // adds 1 life
                if node.name == "life" {
                    self.playSoundEffect(ofType: .torpedo)
                    lifeValue += 1
                    livesField.text = String(lifeValue)
                    node.removeFromParentNode()
                    
                }
                
                //freezes game for 10 seconds - design as a clock
                if node.name == "freeze" {
                    self.playSoundEffect(ofType: .clock)
                    node.removeFromParentNode()
                    speedClicked = true
                    alertPowerUp.text = "Freezed!"
                    alertPowerUp.isHidden = false
                    for n in sceneView.scene.rootNode.childNodes {
                        
                        changeSpeed(xDirection: 0, yDirection: 0, zDirection: 0, node: n)
                        
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 10.0) {
                        self.speedClicked = false
                        for n in self.sceneView.scene.rootNode.childNodes {
                            if n.name == "ball" {
                                
                                self.changeSpeed(xDirection: -n.position.x/5, yDirection: -n.position.y/5, zDirection: -n.position.z/5, node: n)
                                
                            }
                            
                        }
                        self.alertPowerUp.isHidden = true
                        print("freeze over")
                    }
                }
                
                //double points for 10 seconds- design as an X
                if node.name == "double" {
                    self.playSoundEffect(ofType: .double_points)
                    doublePoints = true
                    alertPowerUp.text = "Points x2!"
                    alertPowerUp.isHidden = false
                    node.removeFromParentNode()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 10.0) {
                        self.doublePoints = false
                        self.alertPowerUp.isHidden = true
                    }
                    /*scoreValue += scoreValue*2
                     scoreField.text = String(scoreValue)*/
                    
                }
                
                if node.name == "ball" {
                    self.playSoundEffect(ofType: .collision)
                    scoreValue += 15
                    if doublePoints {
                        scoreValue += 15
                    }
                    scoreField.text = String(scoreValue)
                    node.removeFromParentNode()
                    //moving = false
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
        case coin = "coin"
        case torpedo = "torpedo"
        case clock = "clock"
        case double_points = "double_points"
    }
    
}

