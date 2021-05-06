//
//  SignupThirdViewController.swift
//  YamahaRidersClub
//
//  Created by raiyan sharif on 2/5/21.
//

import UIKit

class SignupThirdViewController: UIViewController,UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    var maritalStatus:[String] = ["Married", "Un-Married"]
    var presentUpazilla:[String] = []
    var permenentUpazilla:[String] = []
    var presentUpazillaCode:[String] = []
    var permenentUpazillaCode:[String] = []
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        if(pickerView.tag == 1){
            return 1
        }
        else if pickerView.tag == 2{
            return 1
        }
        else if(pickerView.tag == 3){
            return 2
        }
        else if(pickerView.tag == 4){
            return 2
        }
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 1{
            return VerificationResponseModel.occupationList.count
        }
        else if(pickerView.tag == 2){
            return maritalStatus.count
        }
        else if(pickerView.tag == 3 && component == 0){
            return VerificationResponseModel.districtList.count
        }
        else if(pickerView.tag == 4 && component == 0){
            return VerificationResponseModel.districtList.count
        }
        else if(pickerView.tag == 3 && component == 1){
            return presentUpazilla.count
        }
        else if(pickerView.tag == 4 && component == 1){
            return permenentUpazilla.count
        }
        
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print(row)
        print(component)
        if pickerView.tag == 1{
            VerificationResponseModel.occupation = VerificationResponseModel.occupationList[row].occupationId
        }
        else if(pickerView.tag == 2){
            VerificationResponseModel.maritalStatus = row == 1 ? "UM" : "M"
            print(VerificationResponseModel.maritalStatus)
        }
        else if(pickerView.tag == 3 && component == 0){
            VerificationResponseModel.districtCode = VerificationResponseModel.districtList[row].districtCode
            let selectedDistrictCode = VerificationResponseModel.districtList[row].districtCode
            presentUpazilla = []
            presentUpazillaCode = []
            
            
            for i in 0 ... VerificationResponseModel.upazillaList.count-1{
                if VerificationResponseModel.upazillaList[i].districtCode == selectedDistrictCode{
                    presentUpazilla.append(VerificationResponseModel.upazillaList[i].upazillaName)
                    presentUpazillaCode.append(VerificationResponseModel.upazillaList[i].upazillaCode)
                }
            }
            
            pickerView.reloadComponent(1)
        }
        else if(pickerView.tag == 4 && component == 0){
            VerificationResponseModel.permanentDistrictCode = VerificationResponseModel.districtList[row].districtCode
            print("DID Select Value \(VerificationResponseModel.permanentDistrictCode )")
            let selectedDistrictCode = VerificationResponseModel.districtList[row].districtCode
            
            permenentUpazilla = []
            permenentUpazillaCode = []
            
            for i in 0 ... VerificationResponseModel.upazillaList.count-1{
                if VerificationResponseModel.upazillaList[i].districtCode == selectedDistrictCode{
                    print(VerificationResponseModel.upazillaList[i].upazillaName)
                    permenentUpazilla.append(VerificationResponseModel.upazillaList[i].upazillaName)
                    permenentUpazillaCode.append(VerificationResponseModel.upazillaList[i].upazillaCode)
                }
            }
            
            pickerView.reloadComponent(1)
        }
        else if(pickerView.tag == 3 && component == 1){
            VerificationResponseModel.upazillaCode = presentUpazillaCode[row]
        }
        else if(pickerView.tag == 4 && component == 1){
            VerificationResponseModel.permanentUpazillaCode = permenentUpazillaCode[row]
            
        }
        
        
        
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var label = UILabel()
        if let v = view as? UILabel { label = v }
        label.font = UIFont (name: "Helvetica Neue", size: 10)
        label.textAlignment = .center
        
        if pickerView.tag == 1{
            label.text = VerificationResponseModel.occupationList[row].occupationName
            return label
        }
        else if(pickerView.tag == 2){
            label.text = maritalStatus[row]
            return label
        }
        else if(pickerView.tag == 3 && component == 0){
            
            
            label.text = VerificationResponseModel.districtList[row].districtName
            return label
            
        }
        else if(pickerView.tag == 4 && component == 0){
            print("row \(row)")
            
            
            label.text = VerificationResponseModel.districtList[row].districtName
            return label
        }
        else if(pickerView.tag == 3 && component == 1){
            label.text = presentUpazilla[row]
            return label
        }
        else if(pickerView.tag == 4 && component == 1){
            label.text = permenentUpazilla[row]
            return label
        }
        
        label.text = ""
            
        return label
    }
//    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//        if pickerView.tag == 1{
//            return VerificationResponseModel.occupationList[row].occupationName
//        }
//        else if(pickerView.tag == 2){
//            return maritalStatus[row]
//        }
//        else if(pickerView.tag == 3 && component == 0){
//
//
//            return VerificationResponseModel.districtList[row].districtName
//
//        }
//        else if(pickerView.tag == 4 && component == 0){
//            print("row \(row)")
//
//
//            return VerificationResponseModel.districtList[row].districtName
//        }
//        else if(pickerView.tag == 3 && component == 1){
//            return presentUpazilla[row]
//        }
//        else if(pickerView.tag == 4 && component == 1){
//            return permenentUpazilla[row]
//        }
//
//        return ""
//    }
//

    @IBOutlet weak var occupationPicker: UIPickerView!
    @IBOutlet weak var maritalStatusPicker: UIPickerView!
    @IBOutlet weak var presentAddressPicker: UIPickerView!
    @IBOutlet weak var permenetAddressPicker: UIPickerView!
    @IBOutlet weak var presentAddressTF: UITextField!
    @IBOutlet weak var permenantAddressTF: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        occupationPicker.dataSource = self
        occupationPicker.delegate = self
        maritalStatusPicker.dataSource = self
        maritalStatusPicker.delegate = self
        presentAddressPicker.delegate = self
        presentAddressPicker.dataSource = self
        permenetAddressPicker.delegate = self
        permenetAddressPicker.dataSource = self
        presentAddressTF.delegate = self
        permenantAddressTF.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)

        // Do any additional setup after loading the view.
    }
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
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

    @IBAction func nextBtnPressed(_ sender: Any) {
        
        print("Occupation: \(VerificationResponseModel.occupation)")
        print("Marital Status: \(VerificationResponseModel.maritalStatus)")
        print("Present District Code: \(VerificationResponseModel.districtCode)")
        print("Present Upzilla Code: \(VerificationResponseModel.upazillaCode)")
        print("Permenent District Code: \(VerificationResponseModel.permanentDistrictCode)")
        print("Permenent Upazilla Code: \(VerificationResponseModel.permanentUpazillaCode)")
        VerificationResponseModel.permanentStreetNo = permenantAddressTF.text ?? ""
        VerificationResponseModel.streetNo = presentAddressTF.text ?? ""
        print("Present Address: \(VerificationResponseModel.streetNo)")
        print("Permenent Address: \(VerificationResponseModel.permanentStreetNo)")
        gotoPage()
//        SignUpForthViewController
    }
    func gotoPage(){
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SignUpForthViewController" ) as! SignUpForthViewController
        self.navigationController?.pushViewController(vc,
        animated: true)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
