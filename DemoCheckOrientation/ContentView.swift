//
//  ContentView.swift
//  DemoCheckOrientation
//
//  Created by Arkadiy Grigoryanc on 13.02.2022.
//

import SwiftUI

struct ContentView: View {
    @StateObject var vm = ViewModel()

    var body: some View {
        VStack(spacing: 20) {
            Text("Check orientation").font(.title)
            HStack(spacing: 20) {
                CheckLabel(action: vm.checkDeviceOrientation,
                           title: "UIDeviceOrientation",
                           text: $vm.deviceOrientation)
                CheckLabel(action: vm.checkInterfaceOrientation,
                           title: "UIInterfaceOrientation",
                           text: $vm.interfaceOrientation)
            }
            VStack {
                Text("Device attitude degrees")
                Text(vm.deviceAttitudeDegrees)
                    .foregroundColor(.red)
            }
        }
        .onAppear {
            vm.checkDeviceOrientation()
            vm.checkInterfaceOrientation()
            vm.checkDeviceAttitudeDegrees()
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
                .padding(.bottom, 10)
            Text(title)
            Text(text)
                .foregroundColor(.red)
        }
    }
}
