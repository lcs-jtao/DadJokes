//
//  SharedFunctionsAndConstants.swift
//  DadJokes
//
//  Created by Joyce Tao on 2022-02-25.
//

import Foundation

// Return the directory that we can save user data in
func getDocumentsDirectory() -> URL {
    // Path is a location to a file
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    return paths[0]
}

// Define a file label (or file name) that we will write to within that directory
let savedFavouritesLabel = "savedFavourites"


