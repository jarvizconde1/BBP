//
//  HomeViewController.swift
//  BBP
//
//  Created by Jarvis Vizconde on 6/1/23.
//

import UIKit
import CoreML
import Vision
import AVKit
import ConfettiView

class HomeViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate  {

   
    @IBOutlet weak var confettiView: ConfettiView!
    @IBOutlet weak var cameraView: UIView!
    
    var playerAttribute  = PlayerAttribute()
    let captureSession = AVCaptureSession()
    
    
    @IBOutlet weak var result: UILabel!
    @IBOutlet weak var lockinButton: UIButton!
    @IBOutlet weak var computerAttribute: UILabel!
    @IBOutlet weak var selectedAttribute: UILabel!
    
    @IBOutlet weak var yourPick: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.confettiView.stopAnimating()
        InitializeCaptureSession()
       
    }
    
  
    
  //MARK: - every time frame is change in camera - this delegate run
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        
        
        
        guard let pixelBuffer : CVPixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            fatalError("error on pixel")
        }
        
        
        
        guard let model = try? VNCoreMLModel(for: HandSigns(configuration: MLModelConfiguration()).model) else {
            
            print("error on model")
            return

        }
        
        
        

            let request = VNCoreMLRequest(model: model) {(request ,error) in
                
                
                guard let resultArray = request.results as? [VNClassificationObservation] else {
                    return
                }
                
                guard let firstObsevation = resultArray.first else {
                    return
                }
                
                print(firstObsevation.identifier, firstObsevation.confidence)
                
                  
                
               
               var emoji = ""
               
                if  firstObsevation.identifier == "FistHand" {
                    emoji = "✊🏻"
               }
               else if firstObsevation.identifier == "FiveHand" {
                   emoji = "✋🏻"
               }else if firstObsevation.identifier == "VictoryHand" {
                   emoji = "✌🏻"
               }else if  firstObsevation.identifier == "NoHand" {
                   emoji =  "❓"
               }
                
                
                
                DispatchQueue.main.async {
                  
                    self.selectedAttribute.text = ( "\(emoji) is detected" )
                    self.playerAttribute.selectedAttribute = String(firstObsevation.identifier)
                    
              }
            
           
                  }
            
           try? VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:]).perform([request])
            
        
    }
    
    
    
    
    
    
    
    
    
    //MARK: -  capture session
    
    func InitializeCaptureSession() {
        
        
        captureSession.sessionPreset = .photo
        
        
        // Add input for capture
        guard let captureDevice = AVCaptureDevice.default(for: .video) else { return}
        guard let input  = try? AVCaptureDeviceInput(device: captureDevice) else {return}
        captureSession.addInput(input)
       
        
        // Add preview layer
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        cameraView.layer.addSublayer(previewLayer)
        previewLayer.frame = cameraView.frame
        
        
        
        // Add output for capture
        let dataOutput = AVCaptureVideoDataOutput()
        dataOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label :"videoQueue"))
        captureSession.addOutput(dataOutput)
    }
    
    
    
    //MARK: -  play button
    @IBAction func playButton(_ sender: Any) {
        
        DispatchQueue.global(qos: .background).async {
            self.captureSession.startRunning()
            
            }
    }
    
    
    //MARK: -  LOCK IN
    
    @IBAction func lockIn(_ sender: UIButton) {
        
         playerAttribute.finalAttribute = playerAttribute.selectedAttribute
        
        
        
        if  playerAttribute.finalAttribute == "FistHand" {
            playerAttribute.finalAttribute = "rock"
            yourPick.text = "Your Pick: ✊🏻"
        }
        else if playerAttribute.finalAttribute == "FiveHand" {
            playerAttribute.finalAttribute = "paper"
            yourPick.text = "Your Pick: ✋🏻"
        }else if playerAttribute.finalAttribute == "VictoryHand" {
            playerAttribute.finalAttribute = "scissors"
            yourPick.text = "Your Pick: ✌🏻"
        }else if  playerAttribute.finalAttribute == "NoHand" {
            playerAttribute.finalAttribute = "none"
            yourPick.text = "Your Pick: ❓"
        }
        
        
        self.lockinButton.setTitle("Lock In Again", for: .normal)
        
        DispatchQueue.main.asyncAfter(deadline : .now() + 1) {
            
            self.navigationItem.title = self.playerAttribute.finalAttribute
            self.didWinOrLose ()
            
           
        }
        
        
    }
    
    func didWinOrLose () {
        
        if  let computer = self.playerAttribute.Computer.randomElement() {
            
            let playerAttribute = self.playerAttribute.finalAttribute
            
            let results =   SwitchCase(player: playerAttribute, comp: computer)
            self.result.backgroundColor = UIColor.black
            self.result.text = results
            
            
            
            if results == "you win" {
                self.result.backgroundColor = UIColor.green
               self.playerAttribute.score+=1
                navigationItem.title = ("Score:\(self.playerAttribute.score)")
                
                confettiView.startAnimating()
                
                DispatchQueue.main.asyncAfter(deadline : .now() + 3) { self.confettiView.stopAnimating()
                    
                }
                
            } else if results == "draw" {
                
                navigationItem.title = ("Score:\(self.playerAttribute.score)")
            }else if results == "defeat" {
                self.result.backgroundColor = UIColor.red
                navigationItem.title = ("Score:\(self.playerAttribute.score)")
            }
            
            
          
            
            
            
            if computer == "rock" {
                computerAttribute.text = "Computer:✊🏻"
            } else if computer == "paper" {
                computerAttribute.text = "Computer:✋🏻"
            }else if computer == "scissors"{
                computerAttribute.text = "Computer:✌🏻"
            }
            
            
           
            
            
        }
     
        
        
        
        
        
        
    }
}
