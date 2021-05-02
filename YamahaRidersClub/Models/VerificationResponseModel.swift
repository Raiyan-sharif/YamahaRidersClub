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
    static var selectedModel: [String] = ["model","product"]
    
    static func clearAllData(){
        districtList = []
        upazillaList = []
        customerlistArray = []
        brandlistArray = []
        productlistArray = []
        yrcareaList = []
        ridingstyleList = []
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


