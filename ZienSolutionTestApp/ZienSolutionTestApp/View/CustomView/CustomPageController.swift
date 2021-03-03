import SwiftUI

struct CustomPageControlView: View {
    @Binding var currentIndex: CGFloat
    @State var index: Int

    var body: some View {
        Rectangle()
            .frame(width: currentIndex == CGFloat(index) ? 12 : 8, height: 8, alignment: .leading)
            .foregroundColor(.init(currentIndex == CGFloat(index) ? #colorLiteral(red: 0.7324784398, green: 0.7374201417, blue: 0.7415499091, alpha: 1): #colorLiteral(red: 0.3521324992, green: 0.3569681346, blue: 0.365499258, alpha: 1)))
            .cornerRadius(.infinity)
    }
}
