//
//  SongDataSource.swift
//  SingSong
//
//  Created by Jake Grant on 2/17/19.
//  Copyright © 2019 Jake Grant. All rights reserved.
//

import UIKit

class SongDataSource: NSObject, UITableViewDataSource {
    var songs = [Song]()
    var filteredSongs = [Song]()
    var dataChanged: (() -> Void)?
    var jsonFilePath = "songs.json"

    var filterText: String? {
        didSet {
            filteredSongs = songs.matching(filterText)
            self.dataChanged?()
        }
    }

    // MARK: - Data Management
    func fetch(_ urlString: String) {
        // grab data from songs.json
        songs = Bundle.main.decode([Song].self, from: urlString)
        filteredSongs = songs
    }

    func importSongs(from url: URL) -> Bool {
        guard let data = try? Data(contentsOf: url) else {
            return false
        }

        let decoder = JSONDecoder()

        guard let importedSongs = try? decoder.decode([Song].self, from: data) else {
            return false
        }

        for song in importedSongs {
            self.songs.append(song)
        }

        filteredSongs = songs
        saveData()

        dataChanged?()

        return true
    }

    func loadData() {
		// load from User Defaults
		// if that fails, load from the pre-loaded songs

        let defaults = UserDefaults.standard
        guard let savedData = defaults.data(forKey: "Songs") else {
            fetch(jsonFilePath)
            return
        }

        let decoder = JSONDecoder()
        guard let savedSongs = try? decoder.decode([Song].self, from: savedData) else {
            fetch(jsonFilePath)
            return
        }

        songs = savedSongs
        filteredSongs = songs
    }

    func saveData() {
        let defaults = UserDefaults.standard
        let encoder = JSONEncoder()
        guard let savedData = try? encoder.encode(songs) else {
            fatalError("Unable to encode songs data.")
        }

        defaults.set(savedData, forKey: "Songs")
    }

    func removeSong(at position: Int) {
        songs.remove(at: position)
        filteredSongs = songs
        saveData()
    }

    func addSong() {
        let song = Song()
        songs.append(song)
        filteredSongs = songs

        dataChanged?()
        saveData()
    }

    func update(_ song: Song) {
        if let index = songs.index(where: { $0.id == song.id }) {
            songs[index] = song
            filteredSongs = songs

            dataChanged?()
            saveData()
        }
    }

    func replace(index: Int, with song: Song) {
        if song.title.isEmpty && song.lyrics.isEmpty {
            removeSong(at: index)
        } else {
            songs[index] = song
        }
    }

    // MARK: - Table View
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredSongs.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SongCell", for: indexPath)
        let song = filteredSongs[indexPath.row]

        cell.textLabel?.text = song.title
        cell.detailTextLabel?.text = song.nickName

        // styling
        cell.backgroundColor = UIColor.preferedBackgroundColor()
        cell.textLabel?.textColor = UIColor.preferedTextColor()
        cell.detailTextLabel?.textColor = UIColor.preferedSubtitleColor()
        cell.accessoryView?.tintColor = UIColor.preferedTintColor()

        return cell
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    /*
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            removeSong(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class,
            // insert it into the array,
            // and add a new row to the table view.
        }
    }
 */
}
