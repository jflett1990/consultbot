import SwiftUI

struct ConsultationView: View {
    @State private var userInput: String = ""
    @State private var generatedImage: UIImage?

    var body: some View {
        VStack {
            Text("Stylist Consultation")
                .font(.largeTitle)

            TextField("Describe your desired style", text: $userInput)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            Button("Generate Style") {
                DALLEManager.shared.generateImage(from: userInput) { image in
                    self.generatedImage = image
                }
            }

            if let image = generatedImage {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding()
            }

            // Add more UI components as needed

            Spacer()
        }
        .navigationTitle("Consultation")
    }
}
