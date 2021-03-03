import SwiftUI

// MARK: - TEXT
struct TextCustom: View {
    var text = ""
    var font = ""
    var size: CGFloat = 12
    var lineLimit: Int? = nil
    var color = #colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
    
    var body: some View {
        Text(text)
            .foregroundColor(.init(color))
            .font(.custom(font, size: size))
            .lineLimit(lineLimit != nil ? lineLimit : nil)
    }
}

// MARK: - IMAGE
struct ImageCustom: View {
    var name = ""
    var w: CGFloat = 50
    var h: CGFloat = 50

    var body: some View {
        Image(name)
            .resizable()
            .frame(width: w, height: h)
    }
}

