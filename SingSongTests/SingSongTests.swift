//
//  SingSongTests.swift
//  SingSongTests
//
//  Created by Jake Grant on 2/17/19.
//  Copyright © 2019 Jake Grant. All rights reserved.
//

import XCTest
@testable import SingSong

class SingSongTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testLoadingInitialSongs() {
        let model = SongDataSource()
        model.fetch("songs.json")

        let expected = 2

        XCTAssert(model.songs.count == expected, "Loaded songs: \(model.songs.count), expected: \(expected)")
    }

    func testAddingSong() {
        let model = SongDataSource()
        model.fetch("songs.json")
        let songCount = model.songs.count

        model.addSong()

        XCTAssert(model.songs.count == songCount + 1,
                  "Count after adding: \(model.songs.count), expected: \(songCount + 1)")
    }

    func testRemoveSong() {
        let model = SongDataSource()
        model.fetch("songs.json")
        let songCount = model.songs.count

        model.removeSong(at: 0)

        XCTAssert(model.songs.count == songCount - 1,
                  "Count after removing: \(model.songs.count), expected: \(songCount - 1)")
    }

    func testReplacingSong() {
        let model = SongDataSource()
        model.fetch("songs.json")

        let newSong = Song(id: UUID(),
                           title: "New Song",
                           lyrics: "there are words here",
                           nickName: "new new")
        model.replace(index: 0, with: newSong)

        let testSong = model.songs[0]
        XCTAssert(testSong.title == "New Song")
    }

    func testReplacingEmptySong() {
        let model = SongDataSource()
        model.fetch("songs.json")
        let previousCount = model.songs.count

        let newSong = Song()
        model.replace(index: 0, with: newSong)

        XCTAssert(model.songs.count == previousCount - 1)
    }
}
