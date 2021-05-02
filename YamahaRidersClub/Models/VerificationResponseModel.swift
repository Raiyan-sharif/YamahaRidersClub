//
//  VerificationResponseModel.swift
//  YamahaRidersClub
//
//  Created by raiyan sharif on 2/5/21.
//

import Foundation

class VerificationResponseModel{
    static var districtList: [district] = []
    static var upazillaList: [upazilla] = []
    static var customerlistArray: [customerlist] = []
    static var brandlistArray: [brandlist] = []
    static var productlistArray: [productlist] = []
    static var yrcareaList: [yrcarea] = []
    static var ridingstyleList: [ridingstyle] = []
    static var occupationList: [occupationData] = []
    
    static var email:String = ""
    static var chasisNo:String = ""
    static var permanentUpazillaCode:String = ""
    static var crossRidingExperience = ""
    static var sEx = "M"
    static var permanentDistrictCode:String = ""
    static var drivingLicense:String = ""
    static var sing:String = ""
    static var brandCode:String = ""
    static var prevBikeDetails:String = ""
    static var name:String = ""
    static var bnccAffiliation:String = ""
    static var engineNo:String = ""
    static var districtCode:String = ""
    static var streetNo:String = ""
    static var password:String = ""
    static var dateOfBirth:String = ""
    static var bloodGroup:String = ""
    static var upazillaCode:String = ""
    static var facebookIdLink:String = ""
    static var productCode:String = ""
    static var nid:String = ""
    static var ridingType:String = ""
    static var yearRidingExperience:String = ""
    static var occupation:String = ""
    static var maritalStatus:String = ""
    static var area:String = ""
    static var permanentStreetNo:String = ""
    static var fabDestCountry:String = ""
    static var fabDestAbroad:String = ""
    static var instrument:String = ""
    static var crossRidingExperienceDetails:String = ""
    /*
     {"Email":"ax@nm.com","ChassisNo":"ME1RG0749G0045075","PermanentUpazillaCode":"065","CrossRidingExperience":"Yes","Sex":"M","PermanentDistrictCode":"10","DrivingLicense":"4566","Sing":"Yes","BrandCode":"C014","PrevBikeDetails":"test","Name":"Rasel","BnccAffiliation":"No","EngineNo":"G3C8E0365029","DistrictCode":"10","StreetNo":"147","Password":"123456","DateOfBirth":"2019-11-14","BloodGroup":"A+","UpazillaCode":"065","MobileNo":"01799993181","FacebookIdLink": "https://www.facebook.com/test123","ProductCode":"C079","Nid":"13566","RidingType":" Commuter Stunter","YearRidingExperience":"25","Occupation":"3","MaritalStatus":"M","Area":"2","PermanentStreetNo":"2457","FabDestCountry":"test","fabDestAbroad":"test","Instrument":"Yes","CrossRidingExperienceDetails":"test"}
     */
    
    static func clearAllData(){
        districtList = []
        upazillaList = []
        customerlistArray = []
        brandlistArray = []
        productlistArray = []
        yrcareaList = []
        ridingstyleList = []
        occupationList = []
    }
    
}
struct district{
    var districtCode:String
    var districtName:String
}
struct upazilla {
    var districtCode:String
    var upazillaCode:String
    var upazillaName:String
}

struct customerlist {
    var districtCode:String
    var districtName:String
    var customerCode:String
    var customerName:String
    var address:String
}

struct brandlist {
    var brandCode:String
    var brandName:String
}
struct productlist {
    var brandCode:String
    var brandName:String
    var productCode:String
    var productName:String
}
struct yrcarea {
    var areaID:String
    var areaName:String
    var status:String
}

struct ridingstyle{
    var ridingTypeID:String
    var ridingTypeName:String
}

struct occupationData {
    var occupationId:String
    var occupationName:String
    var active:String
    var sL:String
}

