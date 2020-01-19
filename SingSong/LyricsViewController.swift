//
//  LyricsViewController.swift
//  SingSong
//
//  Created by Jake Grant on 2/17/19.
//  Copyright © 2019 Jake Grant. All rights reserved.
//

import UIKit

class LyricsViewController: UIViewController, Storyboarded {
    weak var coordinator: MainCoordinator?
    var song: Song?
    @IBOutlet weak var lyricsView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = song?.title
        self.navigationItem.largeTitleDisplayMode = .never

        lyricsView.text = song?.lyrics

        // styling
        lyricsView.textColor = UIColor.preferedTextColor()
        lyricsView.textContainerInset = UIEdgeInsets(top: 16, left: 32, bottom: 0, right: 32)
        view.backgroundColor = UIColor.preferedBackgroundColor()
    }

    override func viewWillLayoutSubviews() {
        lyricsView.setContentOffset(.zero, animated: false)
    }

    @objc func editSong() {
        if let index = coordinator?.selectedSongIndex {
            coordinator?.editSong(at: index)
        }
    }
}
