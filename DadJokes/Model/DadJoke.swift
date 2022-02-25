//
//  DadJoke.swift
//  DadJokes
//
//  Created by Joyce Tao on 2022-02-22.
//

import Foundation

// The Dadjoke structure conforms to the Decodable protocal
// This means that we want Swift to be able to take a JSON object and 'decode' into an instance of this structure
// "Hashable" protocol conformance - just means that Swift will be able to quickly determine when one instance of this data type differs from another
// Conforming to the 'Encodable' protocol just means that Swift will be able to turn this data structure into a JSON object
struct DadJoke: Decodable, Hashable, Encodable {
    let id: String
    let joke: String
    let status: Int
}
