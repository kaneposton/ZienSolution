import SwiftUI

enum TabBarType {
    case Today
    case Calendar
    case Feed
    case Create
}

struct TabBarBottom: View {
    @State var selectedTabValue: TabBarType = .Today
    var textSize: CGFloat = 14

    var body: some View {
        VStack (spacing: 0){
            Spacer(minLength: 0)
            ZStack {
                HStack (spacing: 0) {
                    Button(action: {
                        self.selectedTabValue = .Today
                    }) {
                        VStack (spacing: 10) {
                            ImageCustom(name: "today", w: 24, h: 24)
                            TextCustom(text: "Today", font: "", size: textSize, lineLimit: 1, color: selectedTabValue == .Today ? #colorLiteral(red: 0.8469843268, green: 0.8471066356, blue: 0.8469573855, alpha: 1): #colorLiteral(red: 0.5882166028, green: 0.5881925225, blue: 0.5967764854, alpha: 1))
                        }
                    }

                    Spacer(minLength: 0)

                    Button(action: {
                        self.selectedTabValue = .Calendar
                    }) {
                        VStack (spacing: 10) {
                            ImageCustom(name: "calendar", w: 24, h: 24)
                            TextCustom(text: "Calendar", font: "", size: textSize, lineLimit: 1, color: selectedTabValue == .Calendar ? #colorLiteral(red: 0.8469843268, green: 0.8471066356, blue: 0.8469573855, alpha: 1): #colorLiteral(red: 0.5882166028, green: 0.5881925225, blue: 0.5967764854, alpha: 1))
                        }
                    }

                    Spacer(minLength: 0)

                    Button(action: {
                        self.selectedTabValue = .Feed
                    }) {
                        VStack (spacing: 10) {
                            ImageCustom(name: "feed", w: 24, h: 24)
                            TextCustom(text: "Feed", font: "", size: textSize, lineLimit: 1, color: selectedTabValue == .Feed ? #colorLiteral(red: 0.8469843268, green: 0.8471066356, blue: 0.8469573855, alpha: 1): #colorLiteral(red: 0.5882166028, green: 0.5881925225, blue: 0.5967764854, alpha: 1))
                        }
                    }

                    Spacer(minLength: 0)

                    Button(action: {
                        self.selectedTabValue = .Create
                    }) {
                        VStack (spacing: 10) {
                            ImageCustom(name: "create", w: 24, h: 24)
                            TextCustom(text: "Create", font: "", size: textSize, lineLimit: 1, color: selectedTabValue == .Create ? #colorLiteral(red: 0.8469843268, green: 0.8471066356, blue: 0.8469573855, alpha: 1): #colorLiteral(red: 0.5882166028, green: 0.5881925225, blue: 0.5967764854, alpha: 1))
                        }
                    }
                }.padding(.horizontal, 35)
                    .padding(.top, 13)
            }.frame(width: FULL_W, height: 86, alignment: .top)
                .background(Color.init(#colorLiteral(red: 0.1726600528, green: 0.1722711623, blue: 0.2024759054, alpha: 1)))
        }.animation(.easeInOut(duration: 0.5))
    }
}
