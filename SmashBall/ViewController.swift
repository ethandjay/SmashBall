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
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var nameLabel: UILabel!
    var player: AVAudioPlayer!
    
    @IBOutlet var sceneView: ARSCNView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var highScoreButton: UIButton!
    
    @IBOutlet weak var timeField: UILabel!
    @IBOutlet weak var livesField: UILabel!
    @IBOutlet weak var scoreField: UILabel!
    @IBOutlet weak var gameOverLabel: UILabel!
    @IBOutlet weak var noNameLabel: UILabel!
    
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
    var speed: Float = 5.0
    
    var newTimer = Timer()
    var newestTimer = Timer()
    var lastTimer = Timer()
    var newSeconds: Int = 11
    
    var speedClicked = false
    var doublePoints = false
    var isInvulnerable = false
    
    var blurView: UIVisualEffectView?
    
    var titleView: UILabel = UILabel()
    var scoresView: UILabel = UILabel()
    var backButton: UIButton = UIButton()
    
    
    @IBAction func playPressed(_ sender: Any) {

        for child in view.subviews {
            child.isHidden = false
            if child.isKind(of: UIVisualEffectView.self) {
                child.isHidden = true
            }
        }
        for child in sceneView.scene.rootNode.childNodes {
            child.removeFromParentNode()
        }
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
        noNameLabel.isHidden = true
        timerLabel.isHidden = true
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(ViewController.counter), userInfo: nil, repeats: true)
        
        Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(addObject), userInfo: nil, repeats: true)
        
        Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(addCoin), userInfo: nil, repeats: true)
        
        Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(addPowerup), userInfo: nil, repeats: true)
        
    }
    
    @objc func addPowerup() {
        let rand = arc4random_uniform(4)
        if rand == 0 {
            addLife()
        } else if rand == 1{
            addInvincible()
        } else if rand == 2 {
            addFreeze()
        } else if rand == 3 {
            addDoublePoints()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        timer.invalidate()
        
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
        noNameLabel.isHidden = true
        
        let blur = UIBlurEffect(style: .light)
        blurView = UIVisualEffectView(effect: blur)
        blurView!.frame = view.bounds
        view.addSubview(blurView!)
        view.bringSubview(toFront: blurView!)
        view.bringSubview(toFront: titleLabel)
        view.bringSubview(toFront: playButton)
        view.bringSubview(toFront: highScoreButton)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
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
        
        if lifeValue <= 0 {
            timer.invalidate()
            timerLabel.isHidden = true
            
            blurView!.isHidden = false
            view.bringSubview(toFront: gameOverLabel)
            view.bringSubview(toFront: finalTimeLabel)
            view.bringSubview(toFront: finalScoreLabel)
            view.bringSubview(toFront: finalTimeField)
            view.bringSubview(toFront: finalScoreField)
            view.bringSubview(toFront: nameField)
            view.bringSubview(toFront: nameLabel)
            view.bringSubview(toFront: submitButton)
            
            let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
            view.addGestureRecognizer(tap)
            
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
    
    @objc func doublePointsCounter() {
        timerLabel.isHidden = false
        view.bringSubview(toFront: timerLabel)
        newSeconds -= 1
        
        if newSeconds < 10 {
            timerLabel.text = String(0) + String(0) + ":" + String(0) + String(newSeconds)
        }
        else {
            timerLabel.text = String(0) + String(0) + ":" + String(newSeconds)
        }
        
        if newSeconds == 0 {
            newTimer.invalidate()
            timerLabel.isHidden = true
            newSeconds = 11
        }
    }
    
    @objc func invincibleCounter() {
        timerLabel.isHidden = false
        view.bringSubview(toFront: timerLabel)
        newSeconds -= 1
        
        if newSeconds < 10 {
            timerLabel.text = String(0) + String(0) + ":" + String(0) + String(newSeconds)
        }
        else {
            timerLabel.text = String(0) + String(0) + ":" + String(newSeconds)
        }
        
        if newSeconds == 0 {
            newestTimer.invalidate()
            timerLabel.isHidden = true
            newSeconds = 11
        }
    }
    
    @objc func freezeCounter() {
        timerLabel.isHidden = false
        view.bringSubview(toFront: timerLabel)
        newSeconds -= 1
        
        if newSeconds < 10 {
            timerLabel.text = String(0) + String(0) + ":" + String(0) + String(newSeconds)
        }
        else {
            timerLabel.text = String(0) + String(0) + ":" + String(newSeconds)
        }
        
        if newSeconds == 0 {
            lastTimer.invalidate()
            timerLabel.isHidden = true
            newSeconds = 11
        }
    }
    
    func updatePosition() {
        
        /*if seconds > 0 && seconds < 5 {
         speed = 5
         
         }
         if seconds >= 5 && seconds <= 10 {
         speed = 4
         
         }
         if seconds > 10 && seconds <= 15 {
         speed = 3
         
         }
         if seconds > 15 && seconds <= 20 {
         speed = 2
         
         }
         if seconds > 40 {
         speed = 1
         
         }*/
        
        if speedClicked == false {
            for n in self.sceneView.scene.rootNode.childNodes {
                if n.name == "ball" {
                    
                    n.position.x = n.position.x - n.position.x/(speed)
                    n.position.y = n.position.y - n.position.y/(speed)
                    n.position.z = n.position.z - n.position.z/(speed)
                    self.changeSpeed(xDirection: -n.position.x/(speed), yDirection: -n.position.y/(speed), zDirection: -n.position.z/(speed), node: n)
                    
                } else {
                    n.position.y = n.position.y - n.position.y/speed
                    self.changeSpeed(xDirection: 0, yDirection: -n.position.y/(5), zDirection: 0, node: n)
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
                        self.playSoundEffect(ofType: .ball_hit)
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
        
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let path = URL(fileURLWithPath: paths[0]).appendingPathComponent("highScores.plist").path
        
        let dict = NSMutableDictionary(contentsOfFile: path)

        if nameField.text != "" {
            dict?.setObject(Int(scoreField.text!)!, forKey: nameField.text! as NSCopying)
            noNameLabel.isHidden = true
        } else {
            view.bringSubview(toFront: noNameLabel)
            noNameLabel.isHidden = false
            return
        }

        print(dict)
        print(path)
        print(dict!.write(toFile: path, atomically: false))
        
        
        self.viewDidLoad()
    }
    
    @IBAction func loadHighScores(_ sender: Any) {
        for child in view.subviews {
            child.isHidden = true
        }
        blurView!.isHidden = false
        sceneView.isHidden = false
        
        let titleFrame = CGRect(x: 0, y: 20, width: view.frame.size.width, height: 100)
        titleView = UILabel(frame: titleFrame)
        titleView.font = UIFont.boldSystemFont(ofSize: 36)
        titleView.text = "High Scores"
        titleView.textColor = UIColor.white
        titleView.center.x = view.center.x
        titleView.textAlignment = .center
        view.addSubview(titleView)
        
        let scoresFrame = CGRect(x: 0, y: 80, width: view.frame.size.width, height: view.frame.size.height - 200)
        scoresView = UILabel(frame: scoresFrame)
        scoresView.font = UIFont.boldSystemFont(ofSize: 20)
        scoresView.textColor = UIColor.white
        scoresView.center.x = view.center.x
        scoresView.textAlignment = .center
        scoresView.text = ""
        scoresView.numberOfLines = 100
        
        var dict: [String: Any] = [:]
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let path = URL(fileURLWithPath: paths[0]).appendingPathComponent("highScores.plist").path
        print(path)
        dict = NSDictionary(contentsOfFile: path) as! [String: Any]
        print(dict)
        
        var scores: [(String, Int)] = []
        dict.forEach {
            let name = $0.key
            let score = $0.value as? Int ?? 0
            scores.append( (name, score)  )
        }
        print(scores)

        scores.sort(by: { $0.1 > $1.1 })
        print(scores)
        let finalScores = scores[0..<5]
        print(finalScores)
        finalScores.forEach {
            scoresView.text!.append("\($0): \($1)\n")
        }
        
        view.addSubview(scoresView)
        
        let backFrame = CGRect(x: 0, y: 500, width: view.frame.size.width, height: 100)
        backButton = UIButton(frame: backFrame)
        backButton.titleLabel!.font = UIFont.boldSystemFont(ofSize: 30)
        backButton.setTitle("Back", for: .normal)
        backButton.setTitleColor(UIColor.white, for: .normal)
        backButton.center.x = view.center.x
        backButton.titleLabel!.textAlignment = .center
        
        backButton.addTarget(self, action: #selector(highScoresBack), for: .touchUpInside)
        
        view.addSubview(backButton)
        
        
        
    }
    
    @objc func highScoresBack(sender: UIButton!){
        for child in view.subviews {
            child.isHidden = true
        }
        
        backButton.removeFromSuperview()
        scoresView.removeFromSuperview()
        titleView.removeFromSuperview()
        
        sceneView.isHidden = false
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
        highScoreButton.isHidden = false
        
        self.viewDidLoad()
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        
        // Run the view's session
        sceneView.session.run(configuration)
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
            
            changeSpeed(xDirection: -xPos/speed, yDirection: -yPos/speed, zDirection: -zPos/speed, node: node)
            
            sceneView.scene.rootNode.addChildNode(node)
            
            
            
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
            sphere.firstMaterial?.diffuse.contents = UIImage(named: "life.jpg")
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
            sphere.firstMaterial?.diffuse.contents = UIImage(named: "freeze.jpg")
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
                    newestTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(ViewController.invincibleCounter), userInfo: nil, repeats: true)
                    self.playSoundEffect(ofType: .torpedo)
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
                
                //freezes game for 10 seconds
                if node.name == "freeze" {
                    lastTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(ViewController.freezeCounter), userInfo: nil, repeats: true)
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
                        self.timerLabel.isHidden = true
                        print("freeze over")
                    }
                }
                
                //double points for 10 seconds
                if node.name == "double" {
                    newTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(ViewController.doublePointsCounter), userInfo: nil, repeats: true)
                    self.playSoundEffect(ofType: .double_points)
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
        case ball_hit = "ball_hit"
    }
    
}

