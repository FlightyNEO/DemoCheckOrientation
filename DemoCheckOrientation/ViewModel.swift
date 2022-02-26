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
    @Published var deviceOrientationUsingCoreMotion = ""

    private let deviceMotionServiceRotation = DeviceMotionServiceRotation()
    
    func checkDeviceOrientation() {
        deviceOrientation = UIDevice.current.orientation.description
    }
    
    func checkInterfaceOrientation() {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
        interfaceOrientation = windowScene.interfaceOrientation.description
    }

    func checkDeviceOrientationUsingCoreMotion() {
        deviceMotionServiceRotation.startDeviceMotionService { [weak self] orientation in
            self?.deviceOrientationUsingCoreMotion = orientation.description
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

class DeviceMotionServiceRotation {
    private var motionManager: CMMotionManager?
    private var timer: Timer?

    deinit {
        stopMotionUpdates()
    }

    func startDeviceMotionService(with handler: @escaping (_ orientation: UIInterfaceOrientation) -> Void) {
        var currentOrientation: UIInterfaceOrientation = .landscapeRight {
            didSet {
                if currentOrientation != oldValue {
                    handler(currentOrientation)
                }
            }
        }

        motionManager = CMMotionManager()
        guard motionManager?.isDeviceMotionAvailable == true else { return assertionFailure() }
        motionManager?.deviceMotionUpdateInterval = Constants.deviceMotionServiceTimeInterval
        motionManager?.showsDeviceMovementDisplay = true
        motionManager?.startDeviceMotionUpdates(using: .xMagneticNorthZVertical)

        timer = Timer(fire: Date(), interval: Constants.deviceMotionServiceTimeInterval, repeats: true) { [weak self] _ in
            switch self?.motionManager?.deviceMotion?.gravity.x {
            case .some(let xAxis) where xAxis > Constants.minDeviceMaxXAxis: currentOrientation = .landscapeRight
            case .some(let xAxis) where xAxis < Constants.minDeviceMinXAxis: currentOrientation = .landscapeLeft
            case .some: currentOrientation = .portrait
            case .none: return
            }
        }

        RunLoop.current.add(timer!, forMode: RunLoop.Mode.default)
    }

    func stopMotionUpdates() {
        timer?.invalidate()
        motionManager?.stopDeviceMotionUpdates()
    }
}

private extension DeviceMotionServiceRotation {
    enum Constants {
        static let minDeviceMaxXAxis: Double = 0.65
        static let minDeviceMinXAxis: Double = -0.65
        static let deviceMotionServiceTimeInterval: TimeInterval = 1.0 / 60.0
    }
}
