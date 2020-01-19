import UIKit

class MainCoordinator: Coordinator {
    var children = [Coordinator]()
    var navigationController: UINavigationController
    var dataSource = SongDataSource()
    var selectedSongIndex = 0

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        style()

        dataSource.loadData()

        let viewController = ViewController.instantiate()
        viewController.coordinator = self
        viewController.dataSource = dataSource
        navigationController.pushViewController(viewController, animated: false)
    }

    func showLyrics(at index: Int) {
        selectedSongIndex = index

        let viewController = LyricsViewController.instantiate()
        viewController.coordinator = self
        viewController.song = dataSource.filteredSongs[selectedSongIndex]

        navigationController.pushViewController(viewController, animated: true)
    }

    func newSong() {
        dataSource.addSong()
        selectedSongIndex = dataSource.songs.count - 1

        editSong(at: selectedSongIndex)
    }

    func editSong(at index: Int) {
        selectedSongIndex = index

        let viewController = EditSongViewController.instantiate()
        viewController.coordinator = self
        viewController.song = dataSource.filteredSongs[selectedSongIndex]

        navigationController.pushViewController(viewController, animated: true)
    }

    func saveSong(_ song: Song) {
        dataSource.update(song)
    }

    func importSongs(from url: URL) {
        let success = dataSource.importSongs(from: url)

        var importTitle: String
        var importMessage: String?
        if success {
            importTitle = "Import was successful"
            importMessage = nil
        } else {
            importTitle = "Import failed."
            importMessage = nil
        }

        let alert = UIAlertController(title: importTitle, message: importMessage, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        self.navigationController.present(alert, animated: true)
    }

    func shareSong(at index: Int) {
        let song = dataSource.songs[index]

        let encoder = JSONEncoder()
        if let savedData = try? encoder.encode([song]) {
            let path = getDocumentsDirectory().appendingPathComponent("sharedSong.json")

            do {
                try savedData.write(to: path)
            } catch {
                let errorAlert = UIAlertController(title: "Oops", message: "There was an error sharing this song...", preferredStyle: .alert)
                let okay = UIAlertAction(title: "OK...", style: .default)
                errorAlert.addAction(okay)

                if let visibleView = navigationController.visibleViewController {
                    visibleView.present(errorAlert, animated: true)
                }
                return
            }

            let shareView = UIActivityViewController(activityItems: [path], applicationActivities: nil)
            shareView.excludedActivityTypes = [
                UIActivity.ActivityType.addToReadingList,
                UIActivity.ActivityType.assignToContact,
                UIActivity.ActivityType.copyToPasteboard,
                UIActivity.ActivityType.markupAsPDF,
                UIActivity.ActivityType.openInIBooks,
                UIActivity.ActivityType.postToFacebook,
                UIActivity.ActivityType.postToFlickr,
                UIActivity.ActivityType.postToTencentWeibo,
                UIActivity.ActivityType.postToTwitter,
                UIActivity.ActivityType.postToVimeo,
                UIActivity.ActivityType.postToWeibo,
                UIActivity.ActivityType.saveToCameraRoll
            ]

            self.navigationController.present(shareView, animated: true)
        }
    }

    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }

    func style() {
		let navBar = self.navigationController.navigationBar

		navBar.tintColor = UIColor.preferedTintColor()

		// revert navigationBar appearance to pre iOS 13 style
		if #available(iOS 13.0, *) {
			let appearance = UINavigationBarAppearance()
			appearance.configureWithOpaqueBackground()
			appearance.backgroundColor = UIColor.preferedBackgroundColor()
			appearance.titleTextAttributes = [.foregroundColor: UIColor.preferedTextColor()]
			appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.preferedTextColor()]

			navBar.standardAppearance = appearance
			navBar.scrollEdgeAppearance = appearance
		} else {
			navBar.isTranslucent = false
			navBar.barTintColor = UIColor.preferedBackgroundColor()
			navBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.preferedTextColor()]
			navBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.preferedTextColor()]
		}
    }
}
