//
//  QRScannerViewController.swift
//  YamahaRidersClub
//
//  Created by raiyan sharif on 20/3/21.
//

import UIKit
import AVFoundation
import Alamofire
import SwiftyJSON

class QRScannerViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate{
    var captureSession: AVCaptureSession!
    @IBOutlet weak var stackData: UIStackView!
    var previewLayer: AVCaptureVideoPreviewLayer!
    var userDefaults = UserDefaults.standard

    @IBOutlet weak var qrIdLabel: UILabel!
    @IBOutlet weak var offerTypeLabel: UILabel!
    @IBOutlet weak var offerAmountLabel: UILabel!
    @IBOutlet weak var marchantNameLabel: UILabel!
    @IBOutlet weak var merchantWebsiteLabel: UILabel!
    
    override func viewDidLoad() {
           super.viewDidLoad()

           view.backgroundColor = UIColor.black
           captureSession = AVCaptureSession()

           guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
           let videoInput: AVCaptureDeviceInput

           do {
               videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
           } catch {
               return
           }

           if (captureSession.canAddInput(videoInput)) {
               captureSession.addInput(videoInput)
           } else {
               failed()
               return
           }

           let metadataOutput = AVCaptureMetadataOutput()

           if (captureSession.canAddOutput(metadataOutput)) {
               captureSession.addOutput(metadataOutput)

               metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
               metadataOutput.metadataObjectTypes = [.qr]
           } else {
               failed()
               return
           }

           previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
           previewLayer.frame = view.layer.bounds
           previewLayer.videoGravity = .resizeAspectFill
           view.layer.addSublayer(previewLayer)

           captureSession.startRunning()
       }

       func failed() {
           let ac = UIAlertController(title: "Scanning not supported", message: "Your device does not support scanning a code from an item. Please use a device with a camera.", preferredStyle: .alert)
           ac.addAction(UIAlertAction(title: "OK", style: .default))
           present(ac, animated: true)
           captureSession = nil
       }

       override func viewWillAppear(_ animated: Bool) {
           super.viewWillAppear(animated)

           if (captureSession?.isRunning == false) {
               captureSession.startRunning()
           }
       }

       override func viewWillDisappear(_ animated: Bool) {
           super.viewWillDisappear(animated)

           if (captureSession?.isRunning == true) {
               captureSession.stopRunning()
           }
       }

       func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
           captureSession.stopRunning()

           if let metadataObject = metadataObjects.first {
               guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
               guard let stringValue = readableObject.stringValue else { return }
               AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
               found(code: stringValue)
           }

           dismiss(animated: true)
       }

       func found(code: String) {
//        captureSession.stopRunning()
        fetchQRCodeDataFromServer(QRCode: code)
        view.bringSubviewToFront(stackData)
        print(code)
//        previewLayer.removeFromSuperlayer()
        
        
       }

       override var prefersStatusBarHidden: Bool {
           return true
       }

       override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
           return .portrait
       }
    
    
    func fetchQRCodeDataFromServer(QRCode: String){
        let mobileNo = userDefaults.string(forKey: "mobileno") ?? ""
        let mobileNoInt = Int(mobileNo) ?? 0
//        let QRCodeInt = Int(QRCode) ?? 0
        AF.request("https://apps.acibd.com/apps/yrc/qr-code-submit?MobileNo=\(mobileNoInt)&QRCode=\(QRCode)").response { response in
            debugPrint(response.debugDescription)
            if let res = response.value{
                if let finalData = res{
                    let swiftyJsonVar = JSON(finalData)
                    print(swiftyJsonVar)
                    self.qrIdLabel.text = "QRCode Id : \(swiftyJsonVar["data"]["QRCodeId"].string ?? "")"
                    self.offerTypeLabel.text = "Offer Type : \(swiftyJsonVar["data"]["OfferType"].string ?? "")"
                    self.offerAmountLabel.text = "Offer Amount : \(swiftyJsonVar["data"]["OfferAmount"].string ?? "")"
                    self.marchantNameLabel.text = "Merchant Name : \(swiftyJsonVar["data"]["MerchantName"].string ?? "")"
                    self.merchantWebsiteLabel.text = "Merchant Website : \(swiftyJsonVar["data"]["MerchantWebsite"].string ?? "")"
                    
                }
            }
        }
    }
}
