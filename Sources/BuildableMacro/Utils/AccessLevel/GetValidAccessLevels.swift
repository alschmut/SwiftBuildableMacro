//
//  GetValidAccessLevels.swift
//  Buildable
//
//  Created by Alexander Schmutz on 16.10.25.
//

import Foundation

func getValidAccessLevels(
    givenAccessLevel: AccessLevel,
    desiredAccessLevel: AccessLevel?
) throws -> AccessLevel {
    if let desiredAccessLevel {
        if desiredAccessLevel > givenAccessLevel {
            throw "The desired accessLevel '\(desiredAccessLevel.rawValue)' must not be higher than the given access level '\(givenAccessLevel.rawValue)'"
        }
        return desiredAccessLevel
    } else {
        return givenAccessLevel
    }
}
