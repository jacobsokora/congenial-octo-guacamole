//
//  ClueViewController.swift
//  ScavengeQR
//
//  Created by Jacob Sokora on 4/30/18.
//  Copyright © 2018 ScavengeQR. All rights reserved.
//

import UIKit
import AVFoundation

class ClueViewController: UIViewController {
    
    @IBOutlet weak var clueLabel: UILabel!
    @IBOutlet weak var captureView: UIView!
    
    var hunt: Hunt?
    var currentClue = 0
    
    var captureSession = AVCaptureSession()
    
    var videoPreviewLayer:AVCaptureVideoPreviewLayer?
    var qrCodeFrameView:UIView?

    private let supportedCodeTypes = [AVMetadataObject.ObjectType.upce,
                                      AVMetadataObject.ObjectType.code39,
                                      AVMetadataObject.ObjectType.code39Mod43,
                                      AVMetadataObject.ObjectType.code93,
                                      AVMetadataObject.ObjectType.code128,
                                      AVMetadataObject.ObjectType.ean8,
                                      AVMetadataObject.ObjectType.ean13,
                                      AVMetadataObject.ObjectType.aztec,
                                      AVMetadataObject.ObjectType.pdf417,
                                      AVMetadataObject.ObjectType.itf14,
                                      AVMetadataObject.ObjectType.dataMatrix,
                                      AVMetadataObject.ObjectType.interleaved2of5,
                                      AVMetadataObject.ObjectType.qr]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        guard let hunt = hunt else {
            dismiss(animated: true)
            return
        }
        
        clueLabel.text = hunt.clues[currentClue].clueText
        
        let deviceDiscoverySystem = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInDualCamera], mediaType: AVMediaType.video, position: .back)
        
        guard let captureDevice = deviceDiscoverySystem.devices.first else {
            print("Failed to get device camera")
            return
        }
        
        do {
            let input = try AVCaptureDeviceInput(device: captureDevice)
            
            captureSession.addInput(input)
            
            let captureMetadataOutput = AVCaptureMetadataOutput()
            captureSession.addOutput(captureMetadataOutput)
            
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            captureMetadataOutput.metadataObjectTypes = supportedCodeTypes
        } catch {
            print(error.localizedDescription)
            return
        }
        
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        videoPreviewLayer?.frame = captureView.layer.bounds
        captureView.layer.addSublayer(videoPreviewLayer!)
        
        captureSession.startRunning()
        
        qrCodeFrameView = UIView()
        
        if let qrCodeFrameView = qrCodeFrameView {
            qrCodeFrameView.layer.borderColor = UIColor.green.cgColor
            qrCodeFrameView.layer.borderWidth = 2
            captureView.addSubview(qrCodeFrameView)
            view.bringSubview(toFront: qrCodeFrameView)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func check(_ answer: String) {
        if answer == hunt?.clues[currentClue].clueCode {
            if currentClue == (hunt?.clues.count)! - 1 {
                let alert = UIAlertController(title: "Good job!", message: "You finished the hunt!", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Exit", style: .default){action in
                    self.dismiss(animated: true)
                })
                present(alert, animated: true, completion: nil)
            } else {
                let alert = UIAlertController(title: "Good job!", message: "You answered correctly!", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Next clue", style: .default){action in
                    self.currentClue += 1
                    self.clueLabel.text = self.hunt?.clues[self.currentClue].clueText
                    self.captureSession.startRunning()
                })
                present(alert, animated: true, completion: nil)
            }
        } else {
            captureSession.startRunning()
        }
    }
    
    @IBAction func endHunt(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension ClueViewController: AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if metadataObjects.count == 0 {
            qrCodeFrameView?.frame = CGRect.zero
            return
        }
        
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        if supportedCodeTypes.contains(metadataObj.type) {
            let barCodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObj)
            qrCodeFrameView?.frame = barCodeObject!.bounds
            
            if let answer = metadataObj.stringValue {
                captureSession.stopRunning()
                check(answer)
            }
        }
    }
}
