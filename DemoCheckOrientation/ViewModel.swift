//
//  ViewModel.swift
//  DemoCheckOrientation
//
//  Created by Arkadiy Grigoryanc on 13.02.2022.
//

import UIKit
import CoreMotion

final class ViewModel: ObservableObject {
    @Published var deviceOrientation = ""
    @Published var interfaceOrientation = ""
    @Published var deviceAttitudeDegrees = ""

    private let motionManager = CMMotionManager()
    private let deviceMotionUpdatesOperationQueue: OperationQueue = {
        let operationQueue = OperationQueue()
        operationQueue.qualityOfService = .userInteractive
        return operationQueue
    }()
    
    func checkDeviceOrientation() {
        deviceOrientation = UIDevice.current.orientation.description
    }
    
    func checkInterfaceOrientation() {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
        interfaceOrientation = windowScene.interfaceOrientation.description
    }

    func checkDeviceAttitudeDegrees() {
        // The device-motion service is available if a device has both an accelerometer and a gyroscope.
        // Because all devices have accelerometers, this property is functionally equivalent to isGyroAvailable.
        guard motionManager.isDeviceMotionAvailable else {
            deviceAttitudeDegrees = "Device motion unavailable"
            return
        }
        motionManager.deviceMotionUpdateInterval = 0.1
        motionManager.startDeviceMotionUpdates(using: .xArbitraryZVertical, to: .main) { deviceMotion, error in
            guard let deviceMotion = deviceMotion else { return }
            self.deviceAttitudeDegrees = String(deviceMotion.attitude.roll * 180 / .pi)
        }
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
