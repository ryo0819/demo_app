import SwiftUI

struct RootView: View {
    @State private var isLoading = true

    var body: some View {
        ZStack {
            if isLoading {
                VStack {
                    Image(systemName: "clock.fill")
                        .font(.system(size: 80))
                        .foregroundColor(.blue)
                        .scaleEffect(isLoading ? 1.0 : 1.5)
                    Text("My Demo App")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.black)
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                        withAnimation {
                            isLoading = false
                        }
                    }
                }
            } else {
                ContentView()
            }
        }
    }
}

#Preview {
    RootView()
}
