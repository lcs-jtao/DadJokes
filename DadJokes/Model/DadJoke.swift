//
//  DadJoke.swift
//  DadJokes
//
//  Created by Joyce Tao on 2022-02-22.
//

import Foundation

struct DadJoke: Decodable {
    let id: String
    let joke: String
    let status: Int
}
