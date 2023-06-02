import SwiftUI

@main
struct MyApp: App {
   @StateObject private var lightViewModel = LightViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView(lightViewModel: lightViewModel)
                .preferredColorScheme(.dark)
                .previewInterfaceOrientation(.landscapeLeft)
        }
    }
}
