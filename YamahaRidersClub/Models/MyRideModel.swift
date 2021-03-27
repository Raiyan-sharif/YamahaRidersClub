//
//  MyRideModel.swift
//  YamahaRidersClub
//
//  Created by raiyan sharif on 27/3/21.
//

import Foundation

struct MyRideModel: Codable {
    let success: Int
    let message: String
    let data: [MyRideModelDatum]
}

// MARK: - Datum
struct MyRideModelDatum: Codable {
    let riderID, mobileNo, startAddress, endAddress: String
    let startLatitude, startLongtitude, endLatitude, endLongtitude: String
    let startTime, endTime, travelDistance, avgSpeed: String
    let maxSpeed, rideDate: String

    enum CodingKeys: String, CodingKey {
        case riderID = "RiderId"
        case mobileNo = "MobileNo"
        case startAddress = "StartAddress"
        case endAddress = "EndAddress"
        case startLatitude = "StartLatitude"
        case startLongtitude = "StartLongtitude"
        case endLatitude = "EndLatitude"
        case endLongtitude = "EndLongtitude"
        case startTime = "StartTime"
        case endTime = "EndTime"
        case travelDistance = "TravelDistance"
        case avgSpeed = "AvgSpeed"
        case maxSpeed = "MaxSpeed"
        case rideDate = "RideDate"
    }
}
