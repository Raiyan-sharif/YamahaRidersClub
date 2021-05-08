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
    @IBOutlet weak var viewOfProfileImageView: UIView!
    
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
    @IBOutlet weak var dataHolderStack: UIStackView!
    
    @IBOutlet weak var outerBorderOfImage: UIView!
    var userDefaults = UserDefaults.standard
    var imagePickerController = UIImagePickerController()
    var imagePickerControllerCoverPhoto = UIImagePickerController()
    //MARK:- VIEWDidLOad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Profile"
        checkPermissions()
        imagePickerController.delegate = self
        imagePickerControllerCoverPhoto.delegate = self
        dataHolderStack.layer.borderWidth = 2
        dataHolderStack.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        dataHolderStack.layer.cornerRadius = 14
        profilePhotoImageView.layer.cornerRadius = 30
        viewOfProfileImageView.layer.cornerRadius = 30
        outerBorderOfImage.layer.cornerRadius = 40
        outerBorderOfImage.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        outerBorderOfImage.layer.borderWidth = 2
        fillProfileData()
        
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(ProfileViewController.onFBlinkTap))
        fbProfileLink.isUserInteractionEnabled = true
        fbProfileLink.addGestureRecognizer(tap2)
        
        
        
     
    }
    @objc func onFBlinkTap(){
        let alertVC = UIAlertController(title: "Add New Fb Link", message: "", preferredStyle: .alert)

        
        alertVC.view.tintColor = UIColor.black
        alertVC.addTextField { (fbNewLinkTextField) in
            fbNewLinkTextField.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            fbNewLinkTextField.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            fbNewLinkTextField.text = self.fbProfileLink.text
            print(fbNewLinkTextField.text)
        }
        let submitAction = UIAlertAction(title: "Submit", style: .default, handler: {
            (alert) -> Void in
            
            let fblinkTF = alertVC.textFields![0] as UITextField
            self.setFBLinkToServerViaNSSession(newLink: fblinkTF.text ?? "")
            
            print("FB Link -- \(fblinkTF.text!)")
        })
        alertVC.addAction(submitAction)
        present(alertVC, animated: true, completion: nil)
    }
    
    func setFBLinkToServerViaNSSession(newLink:String){
        let mobileNo = self.userDefaults.string(forKey: "mobileno") ?? ""
        
        let parameters = ["FacebookIdLink": newLink,
                          "mobileno":mobileNo] as [String : Any]
        var fbLinkObj = FBLinkUploadModel(mobileNo: mobileNo, fbLink: newLink)
        let encoder = JSONEncoder()
        let fbLinkObjJSON = try! encoder.encode(fbLinkObj)
        print("HEree")
        print(fbLinkObjJSON)

        AF.request("http://apps.acibd.com/apps/yrc/rider-fb-link-add",method: .post,parameters: fbLinkObj, encoder: URLEncodedFormParameterEncoder(destination: .httpBody), headers: [
            "Content-Type": "application/x-www-form-urlencoded"
        ] ).response { response in
//            debugPrint(response.debugDescription)
            if let res = response.value{
                if let finalData = res{
                    let swiftyJsonVar = JSON(finalData)
                    print(swiftyJsonVar)
                    if(swiftyJsonVar["msgtype"]=="success"){
                       
                        self.fbProfileLink.text = newLink
                        UserInfo.facebookIDLink = newLink
                    }
                   
                }
                
            }
            
        }
            
    }
    
    func setFBLinkToServer(newLink:String){
        //https://www.facebook.com/yrc/rider-fb-link-add
        
        let mobileNo = self.userDefaults.string(forKey: "mobileno") ?? ""
        print(mobileNo)
        print(newLink)
        let url = URL(string: newLink)!
        
        print("http://apps.acibd.com/apps/yrc/rider-fb-link-add?mobileno=\(mobileNo)&FacebookIdLink=\(url)")
        AF.request("http://apps.acibd.com/apps/yrc/rider-fb-link-add",method: .post, parameters: [
            "FacebookIdLink": "https%3A%2F%2Fwww.facebook.com%2Fpritom92",
            "mobileno":mobileNo
        ],encoding: URLEncoding(destination: .queryString), headers: [
            "Content-Type": "application/x-www-form-urlencoded"
        ] ).response { response in
//            debugPrint(response.debugDescription)
            if let res = response.value{
                if let finalData = res{
                    let swiftyJsonVar = JSON(finalData)
                    print(swiftyJsonVar)
                    if(swiftyJsonVar["msgtype"]=="success"){
                       
                        self.fbProfileLink.text = newLink
                        UserInfo.facebookIDLink = newLink
                    }
                   
                }
                
            }
            
        }
        
    }
    
    func fillProfileData(){
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
//        loadDownloadImageURL()
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
    
    func loadDownloadImageURL(){
        var httpCheckProfile = UserInfo.baseurl ?? ""
        httpCheckProfile = converHttpToHttps(httpCheckProfile)
        
        let imageUrlString = httpCheckProfile + (UserInfo.picture ?? "")
        
        guard let UrlOfImage = URL(string: imageUrlString) else { return }
        let task = URLSession.shared.downloadTask(with: UrlOfImage) { (urlLocation, response, error) in
            guard let location = urlLocation
            else{
                print("location is nil")
                return
            }
            print(location)
            let imageData = try! Data(contentsOf: location)
            
            let image = UIImage(data: imageData)
            DispatchQueue.main.async {
                self.profilePhotoImageView.image = image
            }
            
        }
        task.resume()
    }
    
    func converHttpToHttps(_ httpCheckProfile: String) -> String{
        var temp:String
        if(httpCheckProfile.contains("https")){
            temp = httpCheckProfile
        }
        else{
            if (!httpCheckProfile.isEmpty){
                let endOfSentence = httpCheckProfile.firstIndex(of: ":")!
                let firstSentence = httpCheckProfile[endOfSentence...]
                temp = "https"+firstSentence
            }
            else{
                temp = ""
            }
        }
        return temp
    }
    
    @IBAction func tappedOnCoverPhotoButton(_ sender: UIButton) {
        self.imagePickerControllerCoverPhoto.sourceType = .photoLibrary
//        self.imagePickerControllerCoverPhoto.allowsEditing = true
        
        self.present(self.imagePickerControllerCoverPhoto, animated: true, completion: nil)
    }
    
    
    
    
    @IBAction func tappedOnProfilePhotoButton(_ sender: UIButton) {
        print("Camera")
        //http://apps.acibd.com/apps/yrc/syncdata/riderprofile?MobileNo=01709222843
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
        
        
        
        //Test Image
        let httpCheckProfile = UserInfo.baseurl ?? ""
        let imageUrlString = httpCheckProfile + (UserInfo.picture ?? "")
        print(imageUrlString)
        guard let imageUrl:URL = URL(string: imageUrlString) else {
                    return
                }
        
        profilePhotoImageView.loadImge(withUrl: imageUrl)
        
        
        
    }
    
    func uploadCoverImageToServer(){
        let picture: UIImage = coverPhotoImageView.image ?? UIImage()
        let mobileNo = self.userDefaults.string(forKey: "mobileno") ?? ""
        
        let image = picture
        let imgData = image.jpegData(compressionQuality: 0.2)!

//        let parameters:String = "MobileNo=\(mobileNo)"
        
        let parameters2 = "Picture=\(imgData)"
        

        
        let baseURLString = "http://apps.acibd.com/apps/yrc/syncdata/riderCoverPhoto?MobileNo=\(mobileNo)&"
        

        
       AF.upload(multipartFormData: { multipartFormData in
               multipartFormData.append(imgData, withName: "CoverPhoto",fileName: "\(mobileNo)_\(UUID().uuidString).jpg", mimeType: "image/jpg")
                

           },
       to: baseURLString).responseJSON
       { (result) in

        print(result)
        self.fetchDataForProfile()
       }
        
    }
    
    func uploadProfileImageToServer() {
        
        let picture: UIImage = profilePhotoImageView.image ?? UIImage()
        let mobileNo = self.userDefaults.string(forKey: "mobileno") ?? ""
        
        let image = picture
        let imgData = image.jpegData(compressionQuality: 0.2)!

//        let parameters:String = "MobileNo=\(mobileNo)"
        
        let parameters2 = "Picture=\(imgData)"
        let datapar1: Data = parameters2.data(using: .utf8) ?? Data()
//        data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
//        data.append("Content-Disposition: form-data; name=\"fileToUpload\"; filename=\"\(filename)\"\r\n".data(using: .utf8)!)
//        data.append("Content-Type: image/png\r\n\r\n".data(using: .utf8)!)
//        data.append(UIImagePNGRepresentation(image)!)
//
        
        let baseURLString = "http://apps.acibd.com/apps/yrc/syncdata/riderpicture?MobileNo=\(mobileNo)&"
        guard let url = URL(string: baseURLString) else {
            print("Invalid URL")
            return
        }
//        var urlRequest: URLRequest = URLRequest(url: url)
//        urlRequest.httpMethod = "POST"
//        urlRequest.httpBody = datapar1
//
//        urlRequest.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
//        print(urlRequest)
//        URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
//            guard let data = data else{
//                print("invalid data")
//                return
//            }
//            let responseStr: String = String(data: data, encoding: .utf8) ?? ""
//            print(responseStr)
//        }.resume()
        
       AF.upload(multipartFormData: { multipartFormData in
               multipartFormData.append(imgData, withName: "Picture",fileName: "\(mobileNo)_\(UUID().uuidString).jpg", mimeType: "image/jpg")
                

           },
       to: baseURLString).responseJSON
       { (result) in

        print(result)
        self.fetchDataForProfile()
       }
        
//        fetchDataForProfile()
//        fillProfileData()
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if picker.sourceType == .photoLibrary{
            coverPhotoImageView?.image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
            uploadCoverImageToServer()
        }
        if picker.sourceType == .camera{
            profilePhotoImageView?.image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
            uploadProfileImageToServer()
        }
        
        print()
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
    func fetchDataForProfile(){
        DispatchQueue.main.async {
            print(ConstantSring.baseURLRiderProfile+"?MobileNo="+self.userDefaults.string(forKey: "mobileno")!)
            AF.request(ConstantSring.baseURLRiderProfile+"?MobileNo="+self.userDefaults.string(forKey: "mobileno")!).responseJSON { (response) in
                switch response.result{
                case .success(let value):
                    let json = JSON(value)
                    print(json)
                    if json["success"] == 1{
                        UserInfo.baseurl = json["baseurl"].string
                        UserInfo.message = json["message"].string
                        UserInfo.chassisNo = json["data"][0]["ChassisNo"].string
                        UserInfo.registrationNo = json["data"][0]["RegistrationNo"].string
                        UserInfo.avgSpeed = json["data"][0]["AvgSpeed"].string
                        UserInfo.maxSpeed = json["data"][0]["MaxSpeed"].string
                        UserInfo.bloodGroup = json["data"][0]["BloodGroup"].string
                        UserInfo.engineNo = json["data"][0]["EngineNo"].string
                        UserInfo.facebookIDLink = json["data"][0]["FacebookIdLink"].string
                        UserInfo.drivingLicense = json["data"][0]["DrivingLicense"].string
                        UserInfo.coverPhoto = json["data"][0]["CoverPhoto"].string
                        UserInfo.brandName = json["data"][0]["BrandName"].string
                        UserInfo.picture = json["data"][0]["Picture"].string
                        UserInfo.mobileno = json["data"][0]["Mobileno"].string
                        UserInfo.name = json["data"][0]["Name"].string
                        UserInfo.dateOfBirth = json["data"][0]["DateOfBirth"].string
                        UserInfo.nid = json["data"][0]["NID"].string
                        UserInfo.bikeModel = json["data"][0]["BikeModel"].string
                        UserInfo.memberDays = json["data"][0]["MemberDays"].string
                    }
                    self.fillProfileData()
                
                case .failure(let error):
                    print(error.localizedDescription)
                    
                }
            
            }
        }
    }
}

extension UIImageView {
    func loadImge(withUrl url: URL) {
           DispatchQueue.global().async { [weak self] in
               if let imageData = try? Data(contentsOf: url) {
                   if let image = UIImage(data: imageData) {
                    print("Image fatching")
                       DispatchQueue.main.async {
                           self?.image = image
                       }
                   }
               }
           }
       }
}
