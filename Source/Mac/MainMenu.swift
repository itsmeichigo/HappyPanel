//
//  MainMenu.swift
//  HappyMenuBar
//
//  Created by ichigo on 04/07/2021.
//

import LaunchAtLogin
import Shared
import SwiftUI

struct MainMenu: View {
    @ObservedObject private var settings = HappySettings.shared
    @State private var shouldLaunchAtLogin = LaunchAtLogin.isEnabled
    
    var body: some View {
        Menu("") {
            Section {
                Button(action: {
                    settings.showingKaomojis.toggle()
                }, label: {
                    HStack {
                        if settings.showingKaomojis {
                            Image(systemName: "checkmark")
                        }
                        Text("Kaomoji Mode")
                    }
                })
                Button(action: {
                    LaunchAtLogin.isEnabled.toggle()
                    shouldLaunchAtLogin.toggle()
                }, label: {
                    HStack {
                        if shouldLaunchAtLogin {
                            Image(systemName: "checkmark")
                        }
                        Text("Launch at Login")
                    }
                })
            }
            Section {
                Button("Quit") {
                    NSApplication.shared.terminate(nil)
                }
            }
        }
        .menuStyle(ButtonOnlyMenuStyle())
    }
}

struct MainMenu_Previews: PreviewProvider {
    static var previews: some View {
        MainMenu()
    }
}

struct ButtonOnlyMenuStyle : MenuStyle {
    func makeBody(configuration: MenuStyleConfiguration) -> some View {
        Menu(configuration)
            .frame(width: 44, height: 44)
            .overlay(
                HStack {
                    Spacer()
                    Image(systemName: "gearshape.fill")
                }
                .padding()
                .font(.title2)
                .background(Color.background)
                .allowsHitTesting(false)
            )
    }
}
