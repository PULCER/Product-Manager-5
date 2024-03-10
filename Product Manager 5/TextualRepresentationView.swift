import SwiftUI
import AppKit

struct TextualRepresentationView: View {
    @Binding var text: String
    @Environment(\.presentationMode) var presentationMode
    @State private var showCopyConfirmation = false
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "xmark")
                        .font(.headline)
                        .foregroundColor(.secondary)
                        .background(Color.blue.opacity(0.4))
                }
            }
            
            ScrollView {
                Text(text)
                    .padding()
            }
            
            HStack {
                Button(action: {
                    copyTextToClipboard(text: text)
                    showCopyConfirmation = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        showCopyConfirmation = false
                    }
                }) {
                    Text("Copy All to Clipboard")
                        .frame(maxWidth: .infinity)
                        .padding(5)
                        .background(Color.blue.opacity(0.4))
                        .foregroundColor(.white)
                        .cornerRadius(5)
                }
                .buttonStyle(PlainButtonStyle())
                
                if showCopyConfirmation {
                    Text("Copied!")
                        .font(.headline)
                        .foregroundColor(.green)
                }
                
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }){
                    Text("Close")
                        .frame(maxWidth: .infinity)
                        .padding(5)
                        .background(Color.blue.opacity(0.4))
                        .foregroundColor(.white)
                        .cornerRadius(5)
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .frame(width: 600, height: 400)
    }
    
    private func copyTextToClipboard(text: String) {
        let pasteboard = NSPasteboard.general
        pasteboard.clearContents()
        pasteboard.setString(text, forType: .string)
    }
}
