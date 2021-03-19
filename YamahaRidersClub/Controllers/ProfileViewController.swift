//
//  ProfileViewController.swift
//  YamahaRidersClub
//
//  Created by raiyan sharif on 18/3/21.
//

import UIKit
import Photos
import Alamofire
import SwiftyJSON

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    @IBOutlet weak var coverPhotoButton: UIButton!
    @IBOutlet weak var profilePhotoButton: UIButton!
    @IBOutlet weak var coverPhotoImageView: UIImageView!
    @IBOutlet weak var profilePhotoImageView: UIImageView!
    @IBOutlet weak var nameTF: UILabel!
    
    @IBOutlet weak var memberDaysCountTF: UILabel!
    @IBOutlet weak var registrationInfoLabel: UILabel!
    @IBOutlet weak var modelLabel: UILabel!
    @IBOutlet weak var phoneNumber: UILabel!
    @IBOutlet weak var nidLabel: UILabel!
    @IBOutlet weak var drivingLicenceLabel: UILabel!
    @IBOutlet weak var dateOfBirthLabel: UILabel!
    @IBOutlet weak var bloodGroup: UILabel!
    @IBOutlet weak var maxSpeedLabel: UILabel!
    @IBOutlet weak var averageSpeedLabel: UILabel!
    @IBOutlet weak var fbProfileLink: UILabel!
    
    
    var imagePickerController = UIImagePickerController()
    
    //MARK:- VIEWDidLOad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        checkPermissions()
        imagePickerController.delegate = self
        var httpCheckProfile = UserInfo.baseurl ?? ""
        httpCheckProfile = converHttpToHttps(httpCheckProfile)
        let imageUrlString = httpCheckProfile + (UserInfo.picture ?? "")
        guard let imageUrl:URL = URL(string: imageUrlString) else {
                    return
                }
        
        let coverImageURLString = httpCheckProfile + (UserInfo.coverPhoto ?? "")
        guard let coverImageURL:URL = URL(string: coverImageURLString) else {
            return
        }
        profilePhotoImageView.loadImge(withUrl: imageUrl)
        coverPhotoImageView.loadImge(withUrl: coverImageURL)
        nameTF.text = UserInfo.name ?? "Name"
        memberDaysCountTF.text = "Member for " + (UserInfo.memberDays ?? "0") + " days"
        registrationInfoLabel.text = "Registration info- " + (UserInfo.registrationNo ?? "")
        modelLabel.text = "Model - " + (UserInfo.bikeModel ?? "")
        phoneNumber.text = (UserInfo.mobileno ?? "")
        nidLabel.text = "NID - " + (UserInfo.nid ?? "")
        drivingLicenceLabel.text = "Driving Licence - " + (UserInfo.drivingLicense ?? "")
        dateOfBirthLabel.text = "DOB - " + (UserInfo.dateOfBirth ?? "")
        bloodGroup.text = "Blood Group - " + (UserInfo.bloodGroup ?? "")
        maxSpeedLabel.text = "Max Speed - " + (UserInfo.maxSpeed ?? "")
        averageSpeedLabel.text = "Avg Speed - " + (UserInfo.avgSpeed ?? "")
        
        fbProfileLink.text = (UserInfo.facebookIDLink ?? "")
        
        
        
        
     
    }
    
    func converHttpToHttps(_ httpCheckProfile: String) -> String{
        var temp:String
        if(httpCheckProfile.contains("https")){
            temp = httpCheckProfile
        }
        else{
            let endOfSentence = httpCheckProfile.firstIndex(of: ":")!
            let firstSentence = httpCheckProfile[endOfSentence...]
            temp = "https"+firstSentence
        }
        return temp
    }
    
    @IBAction func tappedOnCoverPhotoButton(_ sender: UIButton) {
        self.imagePickerController.sourceType = .photoLibrary
        self.present(self.imagePickerController, animated: true, completion: nil)
    }
    
    
    
    
    @IBAction func tappedOnProfilePhotoButton(_ sender: UIButton) {
        print("Camera")
        //http://apps.acibd.com/apps/yrc/syncdata/riderprofile?MobileNo=01709222843
//        let picker = UIImagePickerController()
//        picker.sourceType = .camera
//        picker.allowsEditing = true
//        picker.delegate = self
//        present(picker, animated: true)
        
        //Test Image
        let imageUrlString = "https://apps.acibd.com/apps/yrc/application/assets/upload/01709222843_20210111_140008_515_1715378136842885407.jpg"
        guard let imageUrl:URL = URL(string: imageUrlString) else {
                    return
                }
        profilePhotoImageView.loadImge(withUrl: imageUrl)
        
        
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if picker.sourceType == .photoLibrary{
            coverPhotoImageView?.image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        }
        profilePhotoImageView?.image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
        picker.dismiss(animated: true, completion: nil)
    }
    
    func checkPermissions() {
            if PHPhotoLibrary.authorizationStatus() != PHAuthorizationStatus.authorized {
                PHPhotoLibrary.requestAuthorization({ (status: PHAuthorizationStatus) -> Void in ()
                })
            }

            if PHPhotoLibrary.authorizationStatus() == PHAuthorizationStatus.authorized {
            } else {
                PHPhotoLibrary
                    .requestAuthorization(requestAuthorizationHandler)
            }
        }
    func requestAuthorizationHandler(status: PHAuthorizationStatus){
        if PHPhotoLibrary.authorizationStatus() == PHAuthorizationStatus.authorized{
            print("Access granted to Use Photo Library")
        }
        else{
            print("Need Access")
        }
    }
    
}

extension UIImageView {
    func loadImge(withUrl url: URL) {
           DispatchQueue.global().async { [weak self] in
               if let imageData = try? Data(contentsOf: url) {
                   if let image = UIImage(data: imageData) {
                       DispatchQueue.main.async {
                           self?.image = image
                       }
                   }
               }
           }
       }
}
