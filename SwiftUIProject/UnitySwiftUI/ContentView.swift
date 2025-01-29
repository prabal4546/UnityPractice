//
//  ContentView.swift
//  UnitySwiftUI
//
//  Created by Benjamin Dewey on 12/24/23.
//

import SwiftUI

struct ContentView: View {
    @State private var loading = false
    @State private var showState = false
    @State private var showLayout = false
    @State private var display = Display.fullscreen
    @State private var alignment = Alignment.top
    @State private var bulletCount = 10
    @State private var sliderValue: Double = 0

    @ObservedObject private var unity = Unity.shared

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            if loading {
                ProgressView("Loading...").tint(.white).foregroundStyle(.white)
            } else if let UnityContainer = unity.view.flatMap({ UIViewContainer(containee: $0) }) {
                VStack {
                    UnityContainer.ignoresSafeArea()
                    
                    VStack(spacing: 10) {
                        HStack {
                            Button(action: {
                                unity.fireBullet()
                            }) {
                                Text("Fire")
                                    .foregroundColor(.white)
                                    .padding()
                                    .background(Color.red)
                                    .cornerRadius(8)
                            }
                            
                            Text("Bullets: \(unity.bulletCount)")
                                .foregroundColor(.white)
                                .padding()
                        }
                        .padding()
                        
                        VStack {
                            Text("Number: \(Int(sliderValue))")
                                .foregroundColor(.white)
                            Slider(value: $sliderValue, in: 0...100, step: 1)
                                .onChange(of: sliderValue) { newValue in
                                    unity.updateDisplayNumber(Int(newValue))
                                }
                        }
                        .padding()
                        .background(Color.black.opacity(0.5))
                        .cornerRadius(8)
                        
                        if showState || showLayout {
                            VStack {
                                if showState {
                                    HStack(content: {
                                        Text(String(format: "Scale %.2f", unity.scale))
                                        Slider(value: $unity.scale, in: 1...3)
                                    })
                                    Picker("Texture", selection: $unity.texture, content: {
                                        Text("Default").tag(Unity.Texture.none)
                                        Text("Marble").tag(Unity.Texture.marble)
                                        Text("Checkerboard").tag(Unity.Texture.checkerboard)
                                    })
                                    Picker("Spotlight", selection: $unity.spotlight, content: {
                                        Text("Neutral").tag(Unity.LightTemperature.neutral)
                                        Text("Warm").tag(Unity.LightTemperature.warm)
                                        Text("Cool").tag(Unity.LightTemperature.cool)
                                    })
                                    Picker("Visible", selection: $unity.visible, content: {
                                        Text("Show").tag(true)
                                        Text("Hide").tag(false)
                                    })
                                }
                                if showLayout {
                                    Picker("Display", selection: $display, content: {
                                        Text("Square").tag(Display.square)
                                        Text("Aspect").tag(Display.aspect)
                                        Text("Safe area").tag(Display.safearea)
                                        Text("Fullscreen").tag(Display.fullscreen)
                                    })
                                    if display == .aspect || display == .square {
                                        Picker("Alignment", selection: $alignment, content: {
                                            Text("Top").tag(Alignment.top)
                                            Text("Center").tag(Alignment.center)
                                            Text("Bottom").tag(Alignment.bottom)
                                        })
                                    }
                                }
                            }.padding().background(CustomButtonStyle.color).clipShape(CustomButtonStyle.shape)
                        }
                        
                        HStack {
                            let stateImage = "cube" + (showState ? ".fill" : "")
                            let layoutImage = "aspectratio" + (showLayout ? ".fill" : "")
                            Button("State", systemImage: stateImage) {
                                showState.toggle()
                                showLayout = false
                            }
                            Button("Layout", systemImage: layoutImage) {
                                showLayout.toggle()
                                showState = false
                            }
                            Button("Stop Unity", systemImage: "stop") {
                                showLayout = false
                                showState = false
                                loading = true
                                DispatchQueue.main.async {
                                    unity.stop()
                                    loading = false
                                }
                            }
                        }
                    }
                    .padding()
                }
            } else {
                Button("Start Unity", systemImage: "play") {
                    loading = true
                    DispatchQueue.main.async {
                        unity.start()
                        loading = false
                    }
                }
            }
        }
        .safeAreaPadding()
        .pickerStyle(.segmented)
        .buttonStyle(CustomButtonStyle())
    }
}

fileprivate enum Display {
    case square
    case aspect
    case safearea
    case fullscreen
}

fileprivate struct CustomButtonStyle: PrimitiveButtonStyle {
    static let color = Color(.darkGray)
    static let shape = RoundedRectangle(cornerRadius: 6)
    func makeBody(configuration: Configuration) -> some View {
        BorderedProminentButtonStyle().makeBody(configuration: configuration).tint(CustomButtonStyle.color).clipShape(CustomButtonStyle.shape)
    }
}

/* Make alignment hashable so it can be used as a
   picker selection. We only care about top, center,
   and bottom. Retroactive conformance is a bad practice
   but is much more laconic than writing out a wrapper type. */
extension Alignment: @retroactive Hashable {
    public func hash(into hasher: inout Hasher) {
        switch self {
        case .top: hasher.combine(0)
        case .center: hasher.combine(1)
        case .bottom: hasher.combine(2)
        default: hasher.combine(3)
        }
    }
}
