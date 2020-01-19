//
//  ViewController.swift
//  SingSong
//
//  Created by Jake Grant on 2/17/19.
//  Copyright © 2019 Jake Grant. All rights reserved.
//

import UIKit

class ViewController: UITableViewController, UISearchResultsUpdating, Storyboarded {
    weak var coordinator: MainCoordinator?
    weak var dataSource: SongDataSource?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "Sing Song"
        coordinator?.navigationController.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                                            target: self,
                                                            action: #selector(addSong))
        let settingsCog = UIImage(named: "settingsCog")
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: settingsCog,
                                                           style: .plain,
                                                           target: self,
                                                           action: #selector(showSettings))

        dataSource?.dataChanged = { [weak self] in
            self?.tableView.reloadData()
        }

        tableView.dataSource = dataSource

        tableView.backgroundColor = UIColor.preferedBackgroundColor()
        tableView.separatorColor = UIColor.preferedCellSeparatorColor()

        createSearchController()
    }

	// remove back button title from navigation bar
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }

    // MARK: - Navigation
    @objc func addSong() {
        coordinator?.newSong()
    }

    @objc func showSettings() {
        let versionNumber: String
        if let version = Bundle.main.version() {
            versionNumber = version
        } else {
            versionNumber = "Error"
        }

        let alert = UIAlertController(title: "Sing Song", message: "Version: \(versionNumber)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))

        present(alert, animated: true)
    }

    // MARK: - Search Controller
    func createSearchController() {
        let search = SongSearchController(searchResultsController: nil)
        search.searchResultsUpdater = self
        navigationItem.searchController = search

        self.definesPresentationContext = true
    }

    func updateSearchResults(for searchController: UISearchController) {
        dataSource?.filterText = searchController.searchBar.text
    }

    // MARK: - Table View
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        coordinator?.showLyrics(at: indexPath.row)
    }

    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        // Edit
        let edit = UIContextualAction(style: .normal, title: "Edit") { _, _, completionHandler in
            self.coordinator?.editSong(at: indexPath.row)
            completionHandler(true)
        }
        edit.backgroundColor = UIColor.preferedTintColor()

        // Share
        let share = UIContextualAction(style: .normal, title: "Share") { _, _, completionHandler in
            self.coordinator?.shareSong(at: indexPath.row)
            completionHandler(true)
        }
        share.backgroundColor = UIColor.preferedSubtitleColor()

        let config = UISwipeActionsConfiguration(actions: [edit, share])
        config.performsFirstActionWithFullSwipe = true

        return config
    }

    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "Delete") { [weak self] _, _, completionHandler in

            let selectedSong = self?.dataSource?.filteredSongs[indexPath.row]

            // ask to confirm deletion
            let alertBeforeDeletion = UIAlertController(title: "Deleting \(selectedSong?.title ?? "this song")",
                message: "Are you sure you want to delete \(selectedSong?.title ?? "this song")?", preferredStyle: .alert)
            let delete = UIAlertAction(title: "Delete", style: .destructive) { [weak self, indexPath] _ in
                self?.dataSource?.removeSong(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            let cancel = UIAlertAction(title: "Cancel", style: .default)

            alertBeforeDeletion.addAction(delete)
            alertBeforeDeletion.addAction(cancel)
            self?.present(alertBeforeDeletion, animated: true)

            completionHandler(false)
        }

        let config = UISwipeActionsConfiguration(actions: [delete])
        config.performsFirstActionWithFullSwipe = true
        return config
    }
}
