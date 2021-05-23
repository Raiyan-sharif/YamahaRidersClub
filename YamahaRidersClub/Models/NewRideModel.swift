//
//  NewRideModel.swift
//  YamahaRidersClub
//
//  Created by raiyan sharif on 23/5/21.
//
import Foundation

// MARK: - Welcome
struct NewRideModel: Codable {
    var rideDetails: [RideDetail]
    var rideCoordinates: [RideCoordinate]
}

// MARK: - RideCoordinate
struct RideCoordinate: Codable {
    let latitude, longitude, time: String
}

// MARK: - RideDetail
struct RideDetail: Codable {
    let mobile: String
    let startaddress, endaddress: String
    let distance, avgspeed, maxspeed: Double
    let startTime, endTime: String
    let endbyuser: Int
}

