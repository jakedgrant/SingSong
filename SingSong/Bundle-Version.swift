//
//  Bundle-Version.swift
//  SingSong
//
//  Created by Jake Grant on 2/28/19.
//  Copyright © 2019 Jake Grant. All rights reserved.
//

import Foundation

extension Bundle {
    func version() -> String? {
        let appVersion = self.infoDictionary!["CFBundleShortVersionString"] as? String
        let buildNumber = self.infoDictionary!["CFBundleVersion"] as? String
        return "\(appVersion ?? "?") (\(buildNumber ?? "?"))"
    }
}
