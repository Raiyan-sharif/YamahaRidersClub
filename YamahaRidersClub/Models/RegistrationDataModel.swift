//
//  RegistrationDataModel.swift
//  YamahaRidersClub
//
//  Created by raiyan sharif on 3/5/21.
//

import Foundation

//struct RegistrationDataModel: Codable
struct RegistrationDataModel: Codable {
    let data: DataClass
}

// MARK: - DataClass
struct DataClass: Codable {
    let email, chassisNo, permanentUpazillaCode, crossRidingExperience: String
    let sex, permanentDistrictCode, drivingLicense, sing: String
    let brandCode, prevBikeDetails, name, bnccAffiliation: String
    let engineNo, districtCode, streetNo, password: String
    let dateOfBirth, bloodGroup, upazillaCode, mobileNo: String
    let facebookIDLink: String
    let productCode, nid, ridingType, yearRidingExperience: String
    let occupation, maritalStatus, area, permanentStreetNo: String
    let fabDestCountry, fabDestAbroad, instrument, crossRidingExperienceDetails: String

    enum CodingKeys: String, CodingKey {
        case email = "Email"
        case chassisNo = "ChassisNo"
        case permanentUpazillaCode = "PermanentUpazillaCode"
        case crossRidingExperience = "CrossRidingExperience"
        case sex = "Sex"
        case permanentDistrictCode = "PermanentDistrictCode"
        case drivingLicense = "DrivingLicense"
        case sing = "Sing"
        case brandCode = "BrandCode"
        case prevBikeDetails = "PrevBikeDetails"
        case name = "Name"
        case bnccAffiliation = "BnccAffiliation"
        case engineNo = "EngineNo"
        case districtCode = "DistrictCode"
        case streetNo = "StreetNo"
        case password = "Password"
        case dateOfBirth = "DateOfBirth"
        case bloodGroup = "BloodGroup"
        case upazillaCode = "UpazillaCode"
        case mobileNo = "MobileNo"
        case facebookIDLink = "FacebookIdLink"
        case productCode = "ProductCode"
        case nid = "Nid"
        case ridingType = "RidingType"
        case yearRidingExperience = "YearRidingExperience"
        case occupation = "Occupation"
        case maritalStatus = "MaritalStatus"
        case area = "Area"
        case permanentStreetNo = "PermanentStreetNo"
        case fabDestCountry = "FabDestCountry"
        case fabDestAbroad
        case instrument = "Instrument"
        case crossRidingExperienceDetails = "CrossRidingExperienceDetails"
    }
}
