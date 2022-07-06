//
//  UIDeviceExt.swift
//  Record Recall
//
//  Created by Justin Nipper on 7/6/22.
//

import UIKit

extension UIDevice {
    struct DeviceModel: Decodable {
        let identifier: String
        let model: String
    }
    var modelName: String {
    #if targetEnvironment(simulator)
        let identifier = ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"]!
    #else
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
    #endif
        return identifier
    }
}
