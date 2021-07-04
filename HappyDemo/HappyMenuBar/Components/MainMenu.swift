//
//  MainMenu.swift
//  HappyMenuBar
//
//  Created by ichigo on 04/07/2021.
//

import SwiftUI

struct MainMenu: View {
    @State private var startsAtLaunch = false
    
    var body: some View {
        Menu("") {
            Section {
                Button(action: {
                    startsAtLaunch.toggle()
                }, label: {
                    HStack {
                        if startsAtLaunch {
                            Image(systemName: "checkmark")
                        }
                        Text("Start at Launch")
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
                Image(systemName: "gearshape.fill")
                    .padding()
                    .background(Color.background)
                    .allowsHitTesting(false)
            )
    }
}
