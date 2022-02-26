//
//  ContentView.swift
//  DemoCheckOrientation
//
//  Created by Arkadiy Grigoryanc on 13.02.2022.
//

import SwiftUI

struct ContentView: View {
    @StateObject var vm = ViewModel()
    @State var deviceOrientationTitle = ""

    var body: some View {
        VStack(spacing: 20) {
            Text("Check orientation").font(.title)
            VStack(spacing: 20) {
                CheckLabel(action: vm.checkInterfaceOrientation,
                           title: "Interface orientation",
                           text: $vm.interfaceOrientation)
                Group {
                    Text("Device orientation using Notification")
                    Text(deviceOrientationTitle)
                        .foregroundColor(.red)
                }
                Group {
                    Text("Device orientation using Core Motion")
                    Text(vm.deviceOrientationUsingCoreMotion)
                        .foregroundColor(.red)
                }
            }
        }
        .onDeviceRotate { orientation in
            deviceOrientationTitle = orientation.description
        }
        .onAppear {
            vm.checkDeviceOrientationUsingCoreMotion()
            vm.checkInterfaceOrientation()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct CheckLabel: View {
    var action: () -> Void
    var title: String
    @Binding var text: String

    var body: some View {
        VStack {
            Button("Check", action: action)
            Text(title)
            Text(text).foregroundColor(.red)
        }
    }
}

struct DeviceRotationiewModifier: ViewModifier {
    let action: (UIDeviceOrientation) -> Void

    func body(content: Content) -> some View {
        content
            .onAppear()
            .onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)) { _ in
                action(UIDevice.current.orientation)
            }
    }
}

extension View {
    func onDeviceRotate(perform action: @escaping (UIDeviceOrientation) -> Void) -> some View {
        self.modifier(DeviceRotationiewModifier(action: action))
    }
}
