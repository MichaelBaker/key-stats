//
//  KeyStatsDb.swift
//  KeyStats
//
//  Created by Michael Baker on 8/8/15.
//  Copyright (c) 2015 Michael Baker. All rights reserved.
//

import Foundation
import SQLite


let db_path    = "~/.key_stats.sqlite3".stringByStandardizingPath

struct KeyStatsDb {
    let db:              Database
    let migrations:      Query
    let key_strokes:     Query
    let migration_cols:  MigrationColumns
    let key_stroke_cols: KeyStrokeColumns
}

struct MigrationColumns {
    let migration_id: Expression<Int>
}

struct KeyStrokeColumns {
    let key_stroke_id:   Expression<Int64>
    let key_char:        Expression<String>
    let command_pressed: Expression<Bool>
    let shift_pressed:   Expression<Bool>
    let alt_pressed:     Expression<Bool>
    let control_pressed: Expression<Bool>
    let is_backspace:    Expression<Bool>
    let timestamp:       Expression<Double> // Seconds since January 1, 1970 with fractions of a second
}

func migrateDatabase(db: KeyStatsDb) {
    db.db.create(table: db.migrations, ifNotExists: true) { t in
        t.column(db.migration_cols.migration_id, primaryKey: true)
    }
    
    runMigration(addKeyStrokesTable, db, 1439055827)
}

func runMigration(migration: (KeyStatsDb) -> Void, db: KeyStatsDb, timestamp: Int) -> Void {
    migration(db)
    db.migrations.insert(db.migration_cols.migration_id <- timestamp)
}

func connectToDb() -> KeyStatsDb {
    let connection = Database(db_path)
    return KeyStatsDb(
        db: connection,
        migrations:      connection["migrations"],
        key_strokes:     connection["key_strokes"],
        migration_cols:  MigrationColumns(migration_id: Expression<Int>("migration_id")),
        key_stroke_cols: KeyStrokeColumns(
            key_stroke_id:   Expression<Int64>("key_stroke_id"),
            key_char:        Expression<String>("key_char"),
            command_pressed: Expression<Bool>("command_pressed"),
            shift_pressed:   Expression<Bool>("shift_pressed"),
            alt_pressed:     Expression<Bool>("alt_pressed"),
            control_pressed: Expression<Bool>("control_pressed"),
            is_backspace:    Expression<Bool>("is_backspace"),
            timestamp:       Expression<Double>("timestamp")
        )
    )
}

func logKeyStroke(db: KeyStatsDb, ks: KeyStroke) {
    db.key_strokes.insert(
        db.key_stroke_cols.key_char        <- ks.keyChar,
        db.key_stroke_cols.command_pressed <- ks.commandPressed,
        db.key_stroke_cols.shift_pressed   <- ks.shiftPressed,
        db.key_stroke_cols.alt_pressed     <- ks.altPressed,
        db.key_stroke_cols.control_pressed <- ks.controlPressed,
        db.key_stroke_cols.is_backspace    <- ks.isBackspace,
        db.key_stroke_cols.timestamp       <- NSDate().timeIntervalSince1970
    )
}