//
//  Types.swift
//  KeyStats
//
//  Created by Michael Baker on 8/8/15.
//  Copyright (c) 2015 Michael Baker. All rights reserved.
//

import Foundation

struct KeyStroke {
    var keyChar:        String
    var commandPressed: Bool
    var shiftPressed:   Bool
    var controlPressed: Bool
    var altPressed:     Bool
    var isBackspace:    Bool
}