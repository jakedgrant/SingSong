//
//  EditSongViewController.swift
//  SingSong
//
//  Created by Jake Grant on 2/19/19.
//  Copyright © 2019 Jake Grant. All rights reserved.
//

import UIKit

enum SongInfo: String {
    case missingTitle = "missing a title"
    case missingLyrics = "missing lyrics"
    case missingTitleAndLyrics = "missing a title and lyrics"
    case allGood = "all good"
}

class EditSongViewController: UIViewController, Storyboarded {
    weak var coordinator: MainCoordinator?
    var song: Song?

    @IBOutlet weak var songNameText: UITextField!
    @IBOutlet weak var nickNameText: UITextField!
    @IBOutlet weak var lyricsText: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "Edit Song"
        self.navigationItem.largeTitleDisplayMode = .never
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(checkIfNeedToConfirmDoneEditing))

        songNameText.text = song?.title
        nickNameText.text = song?.nickName
        lyricsText.text = song?.lyrics

        // styling
        view.backgroundColor = UIColor.preferedBackgroundColor()

        songNameText.backgroundColor = UIColor.preferedBackgroundColor()
        songNameText.textColor = UIColor.preferedTextColor()
        songNameText.tintColor = UIColor.preferedTintColor()
		songNameText.attributedPlaceholder = placeholderAttributedString(for: "Song Name")

        nickNameText.backgroundColor = UIColor.preferedBackgroundColor()
        nickNameText.textColor = UIColor.preferedTextColor()
        nickNameText.tintColor = UIColor.preferedTintColor()
		nickNameText.attributedPlaceholder = placeholderAttributedString(for: "Song Nickname")

        lyricsText.textColor = UIColor.preferedTextColor()
        lyricsText.backgroundColor = UIColor.preferedBackgroundColor()
        lyricsText.textContainerInset = UIEdgeInsets(top: 8, left: 16, bottom: 0, right: 16)

        // keyboard notifications
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self,
                                       selector: #selector(adjustForKeyboard),
                                       name: UIResponder.keyboardWillHideNotification,
                                       object: nil)
        notificationCenter.addObserver(self,
                                       selector: #selector(adjustForKeyboard),
                                       name: UIResponder.keyboardWillChangeFrameNotification,
                                       object: nil)
    }

    override func viewWillLayoutSubviews() {
        lyricsText.setContentOffset(.zero, animated: false)
    }

    @objc func checkIfNeedToConfirmDoneEditing() {
        var songInfo = SongInfo.allGood

        if let title = songNameText.text {
            if title.isEmpty {
                songInfo = .missingTitle
            }
        }

        if lyricsText.text.isEmpty {
            if songInfo == .missingTitle {
                songInfo = .missingTitleAndLyrics
            } else {
                songInfo = .missingLyrics
            }
        }

        let alertMessage: String
        switch songInfo {
        case .allGood:
            self.coordinator?.navigationController.popViewController(animated: true)
            return
        default:
            alertMessage = "This song is \(songInfo.rawValue). Are you sure you want to save?"
        }

        let alertBeforeSaving = UIAlertController(title: "Missing Info", message: alertMessage, preferredStyle: .alert)
        let save = UIAlertAction(title: "Save", style: .default) { [weak self] _ in
          self?.coordinator?.navigationController.popViewController(animated: true)
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)

        alertBeforeSaving.addAction(save)
        alertBeforeSaving.addAction(cancel)

        present(alertBeforeSaving, animated: true)
    }

    override func viewWillDisappear(_ animated: Bool) {
        song?.title = songNameText.text ?? "New Song"
        song?.nickName = nickNameText.text ?? "-"
        song?.lyrics = lyricsText.text

        if let song = self.song {
            self.coordinator?.saveSong(song)
        }
    }

    @objc func adjustForKeyboard(notification: Notification) {
        let userInfo = notification.userInfo!

        if let keyboardScreenEndFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)

            if notification.name == UIResponder.keyboardWillHideNotification {
                lyricsText.contentInset = UIEdgeInsets.zero
            } else {
                lyricsText.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height, right: 0)
            }
        }
        lyricsText.scrollIndicatorInsets = lyricsText.contentInset

        let selectedRange = lyricsText.selectedRange
        lyricsText.scrollRangeToVisible(selectedRange)
    }

	func placeholderAttributedString(for text: String) -> NSAttributedString {
		return NSAttributedString(string: text, attributes: [NSAttributedString.Key.foregroundColor: UIColor.preferedSubtitleColor()])
		// myTextField.attributedPlaceholder = str
	}
}
