//
//  Migrations.swift
//  KeyStats
//
//  Created by Michael Baker on 8/8/15.
//  Copyright (c) 2015 Michael Baker. All rights reserved.
//

import Foundation
import SQLite


func addKeyStrokesTable(db: KeyStatsDb) {
    db.db.create(table: db.key_strokes, ifNotExists: true) { t in
        t.column(db.key_stroke_cols.key_stroke_id, primaryKey: .Autoincrement)
        t.column(db.key_stroke_cols.key_char)
        t.column(db.key_stroke_cols.command_pressed)
        t.column(db.key_stroke_cols.shift_pressed)
        t.column(db.key_stroke_cols.alt_pressed)
        t.column(db.key_stroke_cols.control_pressed)
    }
}