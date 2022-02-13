//
//  ViewModel.swift
//  DemoCheckOrientation
//
//  Created by Arkadiy Grigoryanc on 13.02.2022.
//

import UIKit

final class ViewModel: ObservableObject {
    @Published var deviceOrientation = ""
    @Published var interfaceOrientation = ""

    
    func checkDeviceOrientation() {
        deviceOrientation = UIDevice.current.orientation.description
    }
    
    func checkInterfaceOrientation() {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
        interfaceOrientation = windowScene.interfaceOrientation.description

    }
}

extension UIDeviceOrientation: CustomStringConvertible {
    public var description: String {
        switch self {
        case .portrait: return "portrait"
        case .portraitUpsideDown: return "portraitUpsideDown"
        case .landscapeLeft: return "landscapeLeft"
        case .landscapeRight: return "landscapeRight"
        case .faceUp: return "faceUp"
        case .faceDown: return "faceDown"
        case .unknown: return "not determined"
        @unknown default: fatalError()
        }
    }
}

extension UIInterfaceOrientation: CustomStringConvertible {
    public var description: String {
        switch self {
        case .portrait: return "portrait"
        case .portraitUpsideDown: return "portraitUpsideDown"
        case .landscapeLeft: return "landscapeLeft"
        case .landscapeRight: return "landscapeRight"
        case .unknown: return "not determined"
        @unknown default: fatalError()
        }
    }
}
