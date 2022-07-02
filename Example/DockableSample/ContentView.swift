//
//  ContentView.swift
//  DockableSample
//
//  Created by James Sherlock on 01/07/2022.
//

import SwiftUI
import Dockable

struct ContentView: View {
    @StateObject var controller = DockableController()
    
    var body: some View {
        VStack {
            Text("SwiftUI Dockable")
                .font(.title)
            
            Button("Launch Basic Example") {
                print("button pressed")
                controller.enabled.toggle()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .dockable(controller: controller, view: BasicExample(controller: controller))
    }
}

struct BasicExample: View {
    @State var mode: Int = 0
    @State var counter: Int = 0
    
    @ObservedObject var controller: DockableController
    
    var body: some View {
        Group {
            switch mode {
            case 0:
                Text("Width: \(controller.pipWidth)")
                Text("Height: \(controller.pipHeight)")
                    .foregroundColor(.green)
            case 1:
                Text("Counter: \(counter)")
                    .foregroundColor(.blue)
                    .frame(width: 300, height: 100)
            default:
                Color.red
                    .overlay { Text("Counter: \(counter)").foregroundColor(.white) }
                    .frame(width: 100, height: 300)
            }
        }
        .task {
            await updateMode()
        }
        .task {
            await updateCounter()
        }
    }
    
    private func updateCounter() async {
        counter += 1
        try? await Task.sleep(nanoseconds: 10_000_000) // 10 milliseconds
        await updateCounter()
    }
    
    private func updateMode() async {
        try? await Task.sleep(nanoseconds: 1_000_000_000 * 5) // 5 seconds
        mode += 1
        
        if mode == 3 {
            mode = 0
        }
        
        await updateMode()
    }
}