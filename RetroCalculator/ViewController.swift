//
//  ViewController.swift
//  RetroCalculator
//
//  Created by Matthias Hofmann on 05.09.16.
//  Copyright © 2016 MatthiasHofmann. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    // MARK: Outlets
    
    @IBOutlet weak var outputLabel: UILabel!
    
    // MARK: Variables
    
    var btnSound: AVAudioPlayer!
    
    enum Operation: String {
        case Divide = "/"
        case Multiply = "*"
        case Subtract = "-"
        case Add = "+"
        case Empty = "Empty"
    }
    
    var currentOperation = Operation.Empty
    var runningNumber = ""
    var leftValStr = ""
    var rightValStr = ""
    var result = ""
    
    // MARK: VC Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // set path to the soundfile
        let path = Bundle.main.path(forResource: "btn", ofType: "wav")
        let soundURL = URL(fileURLWithPath: path!)
        // prepare soundfile to play
        do {
            try btnSound = AVAudioPlayer(contentsOf: soundURL)
            btnSound.prepareToPlay()
        } catch let err as NSError {
            print(err.debugDescription)
        }
        // set outputLabel to 0.0
        outputLabel.text = "0.0"
    }

    // MARK: IBActions
    
    @IBAction func numberPressed(sender: UIButton) {
        playSound()
        // add new number to the running numbers
        runningNumber += "\(sender.tag)"
        outputLabel.text = runningNumber
    }
    
    @IBAction func onDividePressed(sender: AnyObject) {
        processOperation(operation: .Divide)
    }
    
    @IBAction func onMultiplyPressed(sender: AnyObject) {
        processOperation(operation: .Multiply)

    }
    
    @IBAction func onSubstractPressed(sender: AnyObject) {
        processOperation(operation: .Subtract)

    }
    
    @IBAction func onAddPressed(sender: AnyObject) {
        processOperation(operation: .Add)

    }
    
    @IBAction func onEqualPressed(sender: AnyObject) {
        processOperation(operation: currentOperation)
    }
    
    
    @IBAction func clearBtnPressed(_ sender: AnyObject) {
        playSound()
        // reset all values
        rightValStr = ""
        leftValStr = ""
        result = ""
        currentOperation = Operation.Empty
        
        outputLabel.text = "0.0"
    }
    
    // MARK: Play Sound
    
    func playSound() {
        // if sound is already playing, stop it first
        if btnSound.isPlaying {
            btnSound.stop()
        }
        
        btnSound.play()
    }

    // MARK: Logic
    
    func processOperation(operation: Operation) {
        
        playSound()
        
        if currentOperation != Operation.Empty {
            // if one of of the operands are empty
            if rightValStr == "" || leftValStr == "" {
                outputLabel.text = "Err"
            }
            
            // user selected an operator, but then selected another operator without  first entering a number
            if runningNumber != "" {
                
                rightValStr = runningNumber
                runningNumber = ""
                
                if currentOperation == Operation.Multiply {
                    result = "\(Double(leftValStr)! * Double(rightValStr)!)"
                } else if currentOperation == Operation.Divide {
                    result = "\(Double(leftValStr)! / Double(rightValStr)!)"
                } else if currentOperation == Operation.Subtract {
                    result = "\(Double(leftValStr)! - Double(rightValStr)!)"
                } else if currentOperation == Operation.Add {
                    result = "\(Double(leftValStr)! + Double(rightValStr)!)"
                }
                
                leftValStr = result
                outputLabel.text = result
            }
            
            currentOperation = operation
        } else {
            // this is the first time an op
            leftValStr = runningNumber
            runningNumber = ""
            currentOperation = operation
        }
    }
}

