//
//  SignUpForthViewController.swift
//  YamahaRidersClub
//
//  Created by raiyan sharif on 3/5/21.
//

import UIKit
import Alamofire
import SwiftyJSON

class SignUpForthViewController: UIViewController,UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    @IBOutlet weak var crossCountryPicker: UIPickerView!
    @IBOutlet weak var affiliationPicker: UIPickerView!
    @IBOutlet weak var singPicker: UIPickerView!
    @IBOutlet weak var musicPicker: UIPickerView!
    @IBOutlet weak var yearExpTF: UITextField!
    @IBOutlet weak var RidingTypeTF: UITextField!
    @IBOutlet weak var detailsNoteTF: UITextField!
    @IBOutlet weak var inCountryDestination: UITextField!
    @IBOutlet weak var InAbroadDestinationTF: UITextField!
    @IBOutlet weak var previousBikeDetails: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var confirmPasswordTF: UITextField!
    
    var crossCountryLocalList:[String] = ["Yes","No"]
    var affiliationLocalList:[String] = ["No","BNCC","Scouts"]
    var singLocalList:[String] = ["Yes","No"]
    var musicLocalList:[String] = ["Yes","No"]
    var userDefaults = UserDefaults.standard
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if(pickerView.tag == 1){
            return crossCountryLocalList.count
        }
        else if(pickerView.tag == 2){
            return affiliationLocalList.count
        }
        else if(pickerView.tag == 3){
            return singLocalList.count
        }
        else if(pickerView.tag == 4){
            return musicLocalList.count
        }
        return 0
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if(pickerView.tag == 1){
            VerificationResponseModel.crossRidingExperience = crossCountryLocalList[row]
        }
        else if(pickerView.tag == 2){
            VerificationResponseModel.bnccAffiliation = affiliationLocalList[row]
        }
        else if(pickerView.tag == 3){
            VerificationResponseModel.sing = singLocalList[row]
        }
        else if(pickerView.tag == 4){
            VerificationResponseModel.instrument = musicLocalList[row]
        }
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if(pickerView.tag == 1){
            return crossCountryLocalList[row]
        }
        else if(pickerView.tag == 2){
            return affiliationLocalList[row]
        }
        else if(pickerView.tag == 3){
            return singLocalList[row]
        }
        else if(pickerView.tag == 4){
            return musicLocalList[row]
        }
        return ""
    }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        crossCountryPicker.delegate = self
        affiliationPicker.delegate = self
        singPicker.delegate = self
        musicPicker.delegate = self
        
        crossCountryPicker.dataSource = self
        affiliationPicker.dataSource = self
        singPicker.dataSource = self
        musicPicker.dataSource = self
        
        yearExpTF.delegate = self
        RidingTypeTF.delegate = self
        detailsNoteTF.delegate = self
        inCountryDestination.delegate = self
        InAbroadDestinationTF.delegate = self
        previousBikeDetails.delegate = self
        passwordTF.delegate = self
        confirmPasswordTF.delegate = self

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func submitBtnPressed(_ sender: UIButton) {
        // http://apps.acibd.com/apps/yrc/riderinfo/riderregistration
        VerificationResponseModel.yearRidingExperience = yearExpTF.text ?? ""
        VerificationResponseModel.ridingType = RidingTypeTF.text ?? ""
        VerificationResponseModel.crossRidingExperienceDetails = detailsNoteTF.text ?? ""
        VerificationResponseModel.fabDestCountry = inCountryDestination.text ?? ""
        VerificationResponseModel.fabDestAbroad = InAbroadDestinationTF.text ?? ""
        VerificationResponseModel.prevBikeDetails = previousBikeDetails.text ?? ""
        VerificationResponseModel.password = passwordTF.text ?? ""
        
    
        
        let json: [String:Any] = [
            
            "Email": VerificationResponseModel.email
            ,"ChassisNo": VerificationResponseModel.chasisNo,"PermanentUpazillaCode": VerificationResponseModel.permanentUpazillaCode,"CrossRidingExperience": VerificationResponseModel.crossRidingExperience,"Sex": VerificationResponseModel.sEx,"PermanentDistrictCode":VerificationResponseModel.permanentDistrictCode,"DrivingLicense":VerificationResponseModel.drivingLicense,"Sing":VerificationResponseModel.sing,"BrandCode":VerificationResponseModel.brandCode,"PrevBikeDetails": VerificationResponseModel.prevBikeDetails,"Name":VerificationResponseModel.name,"BnccAffiliation":VerificationResponseModel.bnccAffiliation,"EngineNo":VerificationResponseModel.engineNo,"DistrictCode":VerificationResponseModel.districtCode,"StreetNo": VerificationResponseModel.streetNo,"Password":VerificationResponseModel.password,"DateOfBirth": VerificationResponseModel.dateOfBirth,"BloodGroup":VerificationResponseModel.bloodGroup,"UpazillaCode":VerificationResponseModel.upazillaCode,"MobileNo":userDefaults.string(forKey: "mobileno") ?? "","FacebookIdLink": VerificationResponseModel.facebookIdLink,"ProductCode":VerificationResponseModel.productCode,"Nid":VerificationResponseModel.nid,"RidingType":VerificationResponseModel.ridingType,"YearRidingExperience":VerificationResponseModel.yearRidingExperience,"Occupation":VerificationResponseModel.occupation,"MaritalStatus":VerificationResponseModel.maritalStatus,"Area":VerificationResponseModel.area,"PermanentStreetNo":VerificationResponseModel.permanentStreetNo,"FabDestCountry":VerificationResponseModel.fabDestCountry,"fabDestAbroad": VerificationResponseModel.fabDestAbroad,"Instrument":VerificationResponseModel.instrument,"CrossRidingExperienceDetails":VerificationResponseModel.crossRidingExperienceDetails
        ]
        
        

        
        let dataclassModel = DataClass(email: VerificationResponseModel.email, chassisNo: VerificationResponseModel.chasisNo, permanentUpazillaCode: VerificationResponseModel.permanentUpazillaCode, crossRidingExperience: VerificationResponseModel.crossRidingExperience, sex: VerificationResponseModel.sEx, permanentDistrictCode: VerificationResponseModel.permanentDistrictCode, drivingLicense: VerificationResponseModel.drivingLicense, sing: VerificationResponseModel.sing, brandCode: VerificationResponseModel.brandCode, prevBikeDetails: VerificationResponseModel.prevBikeDetails, name: VerificationResponseModel.name, bnccAffiliation: VerificationResponseModel.bnccAffiliation, engineNo: VerificationResponseModel.engineNo, districtCode: VerificationResponseModel.districtCode, streetNo: VerificationResponseModel.streetNo, password: VerificationResponseModel.password, dateOfBirth: VerificationResponseModel.dateOfBirth, bloodGroup: VerificationResponseModel.bloodGroup, upazillaCode: VerificationResponseModel.upazillaCode, mobileNo: userDefaults.string(forKey: "mobileno") ?? "", facebookIDLink: VerificationResponseModel.facebookIdLink, productCode: VerificationResponseModel.productCode, nid: VerificationResponseModel.nid, ridingType: VerificationResponseModel.ridingType, yearRidingExperience: VerificationResponseModel.yearRidingExperience, occupation: VerificationResponseModel.occupation, maritalStatus: VerificationResponseModel.maritalStatus, area: VerificationResponseModel.area, permanentStreetNo: VerificationResponseModel.permanentStreetNo, fabDestCountry: VerificationResponseModel.fabDestCountry, fabDestAbroad: VerificationResponseModel.fabDestAbroad, instrument: VerificationResponseModel.instrument, crossRidingExperienceDetails: VerificationResponseModel.crossRidingExperienceDetails)
        
        let parameter = RegistrationDataModel(data: dataclassModel)

//        let jsonenCode = JSONEncoder()
//        do {
//            var data = try jsonenCode.encode(parameter)
//            print(data)
//        } catch (let e) {
//            print(e)
//        }
        func jsonFunc(from object:Any) -> String? {
            guard let data = try? JSONSerialization.data(withJSONObject: object, options: []) else {
                return nil
            }
            return String(data: data, encoding: String.Encoding.utf8)
        }
        let alert = UIAlertController(title: nil, message: "Registering ....", preferredStyle: .alert)

        alert.view.tintColor = UIColor.black
        let loadingIndicator: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50)) as UIActivityIndicatorView
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.gray
        loadingIndicator.startAnimating();
        
        alert.view.addSubview(loadingIndicator)
        present(alert, animated: true, completion: nil)
        
        AF.request("https://apps.acibd.com/apps/yrc/riderinfo/riderregistration",method: .post, parameters: ["data":json]).response { response in
            let result = response.result
                        switch result{
                            case .success(let value):
                                if let res = response.value{
                                    if let finalData = res{
                                        let swiftyJsonVar = JSON(finalData)
                                        print(swiftyJsonVar)
                                        print("Here \(value)")

                                        self.dismiss(animated: false, completion:{ self.navigationController?.popToRootViewController(animated: true)
                                        })

                                        
                                    }
                                    
                                }
                        case .failure(let errno):
                            print(errno)
                        }
//            debugPrint(response.debugDescription)
            
        }
        
        
    }
    
    
    
    

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
     //Check if there is any other text-field in the view whose tag is +1 greater than the current text-field on which the return key was pressed. If yes → then move the cursor to that next text-field. If No → Dismiss the keyboard
     if let nextField = self.view.viewWithTag(textField.tag + 1) as? UITextField {
     nextField.becomeFirstResponder()
     } else {
     textField.resignFirstResponder()
     }
     return false
     }

}
