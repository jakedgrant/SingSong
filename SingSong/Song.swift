//
//  Song.swift
//  SingSong
//
//  Created by Jake Grant on 2/17/19.
//  Copyright © 2019 Jake Grant. All rights reserved.
//

import Foundation

struct Song: Codable {
    var id = UUID() // swiftlint:disable:this identifier_name
    var title = ""
    var lyrics = ""
    var nickName = ""
}

extension Array where Element == Song {
    func matching(_ text: String?) -> [Song] {
        if let text = text, text.count > 0 {
            return self.filter {
                $0.title.contains(text)
                    || $0.lyrics.contains(text)
                    || $0.nickName.contains(text)
            }
        } else {
            return self
        }
    }
}
