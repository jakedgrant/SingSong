//
//  SongSearchController.swift
//  SingSong
//
//  Created by Jake Grant on 2/19/19.
//  Copyright © 2019 Jake Grant. All rights reserved.
//

import UIKit

class SongSearchController: UISearchController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.obscuresBackgroundDuringPresentation = false
        self.searchBar.placeholder = "Find a song"

        self.searchBar.tintColor = UIColor.preferedTintColor()
        self.searchBar.textField?.textColor = UIColor.preferedSubtitleColor()
    }
}

extension UISearchBar {
    var textField: UITextField? {
        return subviews.first?.subviews.compactMap { $0 as? UITextField }.first
    }
}
