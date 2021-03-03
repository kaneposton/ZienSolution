import SwiftUI

struct HomeDateHeaderView: View {
    var body: some View {
        HStack (spacing: 0) {
            VStack (alignment: .leading, spacing: 0) {
                HStack (spacing: 0) {
                    TextCustom(text: "TUESDAY", font: "SFProDisplay-Bold", size: 24, lineLimit: 1, color: #colorLiteral(red: 0.6422894597, green: 0.6472190619, blue: 0.6513636112, alpha: 1))
                    ImageCustom(name: "partly_sunny_icon", w: 35, h: 35).padding(.trailing, 5)
                    HStack (alignment: .top, spacing: 0) {
                        TextCustom(text: "44", font: "SFProDisplay-Bold", size: 24, lineLimit: 1, color: #colorLiteral(red: 0.6422894597, green: 0.6472190619, blue: 0.6513636112, alpha: 1))
                        TextCustom(text: "o", font: "SFProDisplay-Bold", size: 10, lineLimit: 1, color: #colorLiteral(red: 0.6422894597, green: 0.6472190619, blue: 0.6513636112, alpha: 1))
                    }
                    Spacer(minLength: 0)
                }
                TextCustom(text: "October 14", font: "SFProDisplay-Bold", size: 34, lineLimit: 1, color: .white)
            }
            Spacer(minLength: 0)
            ZStack (alignment: .topTrailing) {
                RoundedRectangle(cornerRadius: .infinity)
                    .foregroundColor(.white)
                    .frame(width: 60, height: 60)
                ZStack {
                    RoundedRectangle(cornerRadius: .infinity)
                        .frame(width: 20, height: 20)
                        .foregroundColor(.red)
                    TextCustom(text: "2", font: "", size: 12, lineLimit: 1, color: .white)
                }
            }

        }.padding(.horizontal, 25)
            .padding(.top, 60)
    }
}

struct HScrollItem: View {
    var body: some View {
        Button(action: {

        }) {
            ZStack {
                RoundedRectangle(cornerRadius: 15)
                    .foregroundColor(.init(#colorLiteral(red: 0.1238656119, green: 0.1335381866, blue: 0.1463255286, alpha: 1)))
                    .frame(width: FULL_W - 50, height: 65)
                    .shadow(color: .init(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.2977311644)), radius: 5, x: 3, y: 3)
                    .padding(.top, 5)
                VStack (alignment: .leading, spacing: 0) {
                    TextCustom(text: "Labor Day meeting with Silver today", font: "", size: 17, lineLimit: 1, color: #colorLiteral(red: 0.615665257, green: 0.615645051, blue: 0.6242246032, alpha: 1))
                        .frame(width: FULL_W - 90, alignment: .leading)
                    TextCustom(text: "All-day", font: "", size: 12, lineLimit: 1, color: #colorLiteral(red: 0.4736922979, green: 0.4785436392, blue: 0.4870572686, alpha: 1))
                }
            }.frame(height: 84, alignment: .top)
        }
    }
}
