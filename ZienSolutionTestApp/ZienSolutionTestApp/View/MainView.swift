import SwiftUI
import Introspect

// MARK: - Main Constant
let FULL_W: CGFloat = UIScreen.main.bounds.width
let FULL_H: CGFloat = UIScreen.main.bounds.height

struct MainView: View {

    // MARK: - Properties
    @State var stopAnimation = true
    @State var homeHeight: CGFloat = 0
    @State var listHeight: CGFloat = 0
    @State var showStack = false
    @State var hero = false
    var dataHScroll = ["", ""]

    init() {
        UITableViewCell.appearance().backgroundColor = .clear
        UITableView.appearance().backgroundColor = .clear
        UITableView.appearance().separatorStyle = .none
        UITableView.appearance().showsHorizontalScrollIndicator = false
        UITableView.appearance().showsVerticalScrollIndicator = false
    }

    var body: some View {
        ZStack (alignment: .top) {
            Rectangle().foregroundColor(.clear)

            ListCardView(
                stopAnimation: $stopAnimation,
                showStack: $showStack,
                hero: $hero
            ).padding(.top, homeHeight)
                .padding(.bottom, 86)

            VStack (spacing: 0) {
                HomeDateHeaderView()
                    .padding(.bottom, 10)

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack (spacing: 0) {
                        Rectangle().frame(width: 25, height: 1).foregroundColor(.clear)
                        HStack (spacing: 10) {
                            ForEach(0 ..< dataHScroll.count) { _ in
                                HScrollItem()
                            }
                        }
                        Rectangle().frame(width: 25, height: 1).foregroundColor(.clear)
                    }
                }.padding(.bottom, 8)
            }.background(
                GeometryReader { geometry in
                    Color.init(#colorLiteral(red: 0.1120981351, green: 0.1217719093, blue: 0.1345578432, alpha: 1))
                        .onAppear { self.homeHeight = geometry.size.height }
                }
            ).opacity(showStack || hero ? 0 : 1)
                .animation(.easeInOut(duration: 0.5))

            TabBarBottom()

        }.background(Color.init(#colorLiteral(red: 0.1120981351, green: 0.1217719093, blue: 0.1345578432, alpha: 1)))
            .edgesIgnoringSafeArea(.all)
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    self.stopAnimation = false
                }
        }
    }
}

struct ListCardView: View {
    @Binding var stopAnimation: Bool
    @Binding var showStack: Bool
    @Binding var hero: Bool
    @State var heroStack = false
    @State var selectedIndexStack = 0
    @State var selectedIndexHero = 0
    @State var selectedIndexHeroStack = -2
    @State var stackIndex: CGFloat = 0
    @State var cardCurrentIndex: CGFloat = 0
    @State var cardFinalIndex: CGFloat = 0
    @State var viewStateCard = CGSize.zero
    @State var viewStateStack = CGSize.zero
    @State var viewStateSwipeDown = CGSize.zero
    @State var saveHeight: CGFloat = 0
    @State var saveWidth: CGFloat = 0
    @State var spaceCard: CGFloat = 505
    @State var spaceStack: CGFloat = FULL_W - 45
    @State var isSwipeDown = false
    @State var data = [
        CardData(title: "Investor Meeting at office", isNearTime: true, isExpand: false, isShowStack: false, stackCard: [
            StackCardData(isExpandStack: false, title: "Discuss many things"),
            StackCardData(isExpandStack: false, title: "Timeless Meeting V2"),
            StackCardData(isExpandStack: false, title: "Investor Meeting at Greylock")
            ]),
        CardData(title: "Discuss one thing", isNearTime: false, isExpand: false, isShowStack: false, stackCard: []),
        CardData(title: "Timeless Meeting V3", isNearTime: false, isExpand: false, isShowStack: false, stackCard: []),
        CardData(title: "Timeless Meeting V4", isNearTime: false, isExpand: false, isShowStack: false, stackCard: []),
    ]

    var body: some View {
        ZStack {
            ForEach(0 ..< data.count) { index in
                CardView(
                    selectedIndexHero: self.$selectedIndexHero,
                    selectedIndexHeroStack: self.$selectedIndexHeroStack,
                    stopAnimation: self.$stopAnimation,
                    heroStack: self.$heroStack,
                    viewStateStack: self.$viewStateStack,
                    showStack: self.$showStack,
                    hero: self.$hero,
                    stackIndex: self.$stackIndex,
                    cardCurrentIndex: self.$cardCurrentIndex,
                    data: self.$data,
                    index: index,
                    spaceCard: self.spaceCard,
                    spaceStack: self.spaceStack,
                    indexSpace: CGFloat(index) * self.spaceCard,
                    isLast: index == self.data.count - 1 ? true : false,
                    isNearTime: self.data[index].isNearTime
                )
            }
        }.offset(y: viewStateCard.height)
            .background(Color.init(#colorLiteral(red: 0.1120981351, green: 0.1217719093, blue: 0.1345578432, alpha: 1)))
            .gesture(
                DragGesture()
                    .onChanged({ value in
                        if self.showStack {
                            if !self.heroStack {
                                self.viewStateStack.width = value.translation.width + self.saveWidth
                            } else {
                                self.viewStateSwipeDown.height = value.translation.height
                            }
                        } else {
                            if !self.hero {
                                self.viewStateCard.height = value.translation.height + self.saveHeight

                                // MARK: SWIPE UP
                                if self.viewStateCard.height < (-self.spaceCard * self.cardFinalIndex) {
                                    self.cardCurrentIndex = self.cardFinalIndex + 1
                                }

                                // MARK: SWIPE DOWN
                                if self.viewStateCard.height > (0 + (-self.spaceCard * self.cardFinalIndex)) {
                                    self.cardCurrentIndex = self.cardFinalIndex
                                }
                            } else {
                                self.viewStateSwipeDown.height = value.translation.height
                            }
                        }
                    })
                    .onEnded({ value in
                        if self.showStack {
                            if !self.heroStack {

                                // MARK: SWIPE <-
                                if self.viewStateStack.width < (-self.spaceStack * self.stackIndex) {
                                    if self.stackIndex < CGFloat(integerLiteral: self.data[self.selectedIndexStack].stackCard.count) {
                                        self.viewStateStack.width = (-self.spaceStack * self.stackIndex) - self.spaceStack
                                        self.stackIndex += 1
                                    } else {
                                        self.viewStateStack.width = (-self.spaceStack * self.stackIndex)
                                    }
                                }

                                // MARK: SWIPE ->
                                if self.viewStateStack.width > (0 + (-self.spaceStack * self.stackIndex)) {
                                    if self.stackIndex > 0 {
                                        self.viewStateStack.width = (-self.spaceStack * self.stackIndex) + self.spaceStack
                                        self.stackIndex -= 1
                                    } else {
                                        self.viewStateStack.width = (-self.spaceStack * self.stackIndex)
                                    }
                                }
                                self.saveWidth = self.viewStateStack.width
                            } else {
                                // MARK: SWIPE DOWN CLOSE
                                if self.viewStateSwipeDown.height > 0 {
                                    self.heroStack = false

                                    if selectedIndexHeroStack != -1 {
                                        self.data[selectedIndexHero].stackCard[selectedIndexHeroStack].isExpandStack = false
                                    }

                                    self.selectedIndexHeroStack = -2
                                }
                            }
                        } else {
                            if !self.hero {
                                // MARK: SWIPE UP
                                if self.viewStateCard.height < (-self.spaceCard * self.cardFinalIndex) {
                                    if self.cardFinalIndex < CGFloat(integerLiteral: self.data.count - 1) {
                                        self.viewStateCard.height = (-self.spaceCard * self.cardFinalIndex) - self.spaceCard
                                        self.cardFinalIndex += 1
                                    } else {
                                        self.viewStateCard.height = (-self.spaceCard * self.cardFinalIndex)
                                    }
                                }

                                // MARK: SWIPE DOWN
                                if self.viewStateCard.height > (0 + (-self.spaceCard * self.cardFinalIndex)) {
                                    if self.cardFinalIndex > 0 {
                                        self.viewStateCard.height = (-self.spaceCard * self.cardFinalIndex) + self.spaceCard
                                        self.cardFinalIndex -= 1
                                    } else {
                                        self.viewStateCard.height = (-self.spaceCard * self.cardFinalIndex)
                                    }
                                }
                                self.saveHeight = self.viewStateCard.height
                                self.cardCurrentIndex = self.cardFinalIndex
                            } else {
                                // MARK: SWIPE DOWN CLOSE
                                if self.viewStateSwipeDown.height > 0 {
                                    self.hero = false
                                    self.data[selectedIndexHero].isExpand = false
                                }
                            }
                        }
                    })
            )
    }
}

struct CardView: View {
    @Binding var selectedIndexHero: Int
    @Binding var selectedIndexHeroStack: Int
    @Binding var stopAnimation: Bool
    @Binding var heroStack: Bool
    @Binding var viewStateStack: CGSize
    @Binding var showStack: Bool
    @Binding var hero: Bool
    @Binding var stackIndex: CGFloat
    @Binding var cardCurrentIndex: CGFloat
    @Binding var data: [CardData]
    @State var index = 0
    @State var spaceCard: CGFloat = 505
    @State var spaceStack: CGFloat = FULL_W - 45
    @State var indexSpace: CGFloat = 0
    @State var isLast = false
    @State var closeBtnOffset: CGFloat = 0
    @State var showSheet = false
    @State var positionStackIndex = false
    @State var isNearTime = false

    var body: some View {
        GeometryReader { proxy in
            let screen = proxy.frame(in: .global)
            let offset = screen.minY
            let opacity = (offset + indexSpace) / screen.height

            ZStack (alignment: .topTrailing) {
                VStack (spacing: 0) {
                    if !heroStack && showStack {
                        HStack (spacing: 0) {
                            TextCustom(text: "Overlap Event", font: "SFProDisplay-Bold", size: 30, lineLimit: 1, color: #colorLiteral(red: 0.8187289834, green: 0.8237373829, blue: 0.8235065341, alpha: 1))
                            Spacer()
                            Button(action: {
                                self.positionStackIndex = false
                                self.stackIndex = 0
                                self.viewStateStack = .zero
                                self.showStack = false
                                self.data[index].isShowStack = false
                            }) {
                                Image(systemName: "xmark")
                                    .foregroundColor(.white)
                            }
                        }.padding(.bottom, 40)
                            .padding(.horizontal, 35)
                    }

                    GeometryReader { proxyStack in
                        let offsetStack = proxyStack.frame(in: .global).minY

                        ZStack (alignment: .top) {
                            if !showStack && !hero && data[index].stackCard.count > 0 {
                                ZStack (alignment: .top) {
                                    ZStack (alignment: .bottom) {
                                        RoundedRectangle(cornerRadius: 15)
                                            .foregroundColor(.init(#colorLiteral(red: 0.3529245853, green: 0.3529244065, blue: 0.3572027683, alpha: 1)))
                                            .frame(width: FULL_W - 80, height: 480)
                                        TextCustom(text: "\(data[index].stackCard.count) more", font: "SFProDisplay-Medium", size: 14, lineLimit: 1, color: #colorLiteral(red: 0.7411106229, green: 0.7412187457, blue: 0.7410870194, alpha: 1))
                                            .frame(width: FULL_W - 110, alignment: .center)
                                            .padding(.bottom, 8)
                                    }

                                    ZStack (alignment: .bottom) {
                                        RoundedRectangle(cornerRadius: 15)
                                            .foregroundColor(.init(#colorLiteral(red: 0.270578444, green: 0.2705670595, blue: 0.2748582661, alpha: 1)))
                                            .frame(width: FULL_W - 65, height: 450)
                                        HStack (spacing: 0) {
                                            TextCustom(text: "Reading 3 books", font: "SFProDisplay-Mediun", size: 14, lineLimit: 1, color: .white)
                                            Spacer(minLength: 0)
                                            TextCustom(text: "9:30am - 10:30am", font: "SFProDisplay-Mediun", size: 14, lineLimit: 1, color: .white)
                                        }.frame(width: FULL_W - 110, alignment: .center)
                                            .padding(.bottom, 8)
                                    }
                                }.frame(width: FULL_W - 50, height: 480)

                            }
                            if showStack {
                                ZStack {
                                    ForEach(0 ..< data[index].stackCard.count) { indexChild in
                                        CardChildrenView(
                                            heroStack: $heroStack,
                                            positionStackIndex: $positionStackIndex,
                                            stopAnimation: $stopAnimation,
                                            selectedIndexHeroStack: $selectedIndexHeroStack,
                                            data: $data,
                                            showStack: $showStack,
                                            indexRoot: index,
                                            indexChild: indexChild,
                                            spaceStack: spaceStack,
                                            title: data[index].stackCard[indexChild].title
                                        ).opacity(heroStack ? (data[index].stackCard[indexChild].isExpandStack ? 1 : 0) : 1)
                                            .onTapGesture {
                                                if self.showStack {
                                                    if !self.heroStack {
                                                        self.heroStack = true
                                                        self.data[index].stackCard[indexChild].isExpandStack = true
                                                        self.selectedIndexHeroStack = indexChild
                                                    }
                                                }
                                            }.onLongPressGesture(minimumDuration: 0.1) {
                                                self.showSheet = true
                                        }
                                    }
                                }
                            }

                            CardMainView(
                                selectedIndexHero: $selectedIndexHero,
                                selectedIndexHeroStack: $selectedIndexHeroStack,
                                showStack: $showStack,
                                heroStack: $heroStack,
                                hero: $hero,
                                showSheet: $showSheet,
                                data: $data,
                                isNearTime: isNearTime,
                                index: index
                            )

                            if heroStack {
                                Text("").onAppear { self.closeBtnOffset = -offsetStack }
                                Spacer(minLength: 0)
                            }
                        }.offset(x: cardCurrentIndex == CGFloat(index) ? viewStateStack.width : 0, y: selectedIndexHeroStack > -2 ? -offsetStack : 0)
                    }.frame(width: heroStack || !showStack ? FULL_W: FULL_W - 50, height: selectedIndexHeroStack > -2 ? FULL_H: heroStack || hero ? 300 : 480)
                    if !heroStack {
                        if showStack {
                            HStack (spacing: 10) {
                                Spacer()
                                ForEach(0 ..< data[index].stackCard.count + 1) { indexChild in
                                    CustomPageControlView(currentIndex: self.$stackIndex, index: indexChild)
                                }
                                Spacer()
                            }.padding(.top, 20)
                                .offset(x: -screen.minX)
                                .animation(.easeInOut(duration: stopAnimation ? 0 : 0.5))
                        }
                    }
                }

                if data[index].isExpand || selectedIndexHeroStack > -2 {
                    ZStack (alignment: .top) {
                        Rectangle()
                            .foregroundColor(.clear)
                            .frame(width: FULL_W, height: FULL_H)
                        TextCustom(text: "Detail Screen !! \n\nI hope you like my test result\n\nHave a nice day ^.^", font: "SFProDisplay-Mediun", size: 30, color: .white)
                            .multilineTextAlignment(.center)
                            .padding(.top, 300 + 40)
                            .padding(.horizontal, 25)
                    }.offset(y: selectedIndexHeroStack > -2 ? closeBtnOffset : 0)

                    Button(action: {
                        if selectedIndexHeroStack > -2 {
                            self.heroStack = false

                            if selectedIndexHeroStack != -1 {
                                self.data[index].stackCard[selectedIndexHeroStack].isExpandStack = false
                            }

                            self.selectedIndexHeroStack = -2
                        } else {
                            self.hero = false
                            self.data[index].isExpand = false
                        }
                    }) {
                        Image(systemName: "xmark")
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.black.opacity(0.8))
                            .clipShape(Circle())
                    }.padding(.top, UIApplication.shared.windows.first?.safeAreaInsets.top)
                        .padding(.trailing, 25)
                        .offset(y: selectedIndexHeroStack > -2 ? closeBtnOffset : 0)
                }
            }.offset(y: data[index].isExpand ? -offset : isLast ? spaceCard * CGFloat(index) : CGFloat(index) < cardCurrentIndex ? -offset + 248 : spaceCard * CGFloat(index))
                .opacity(showStack ? (data[index].isShowStack ? 1 : 0) : hero ? (data[index].isExpand ? 1 : 0) : isLast ? 1 : CGFloat(index) < cardCurrentIndex ? Double(opacity) + 0.5 : 1)
        }.frame(width: data[index].isExpand || data[index].isShowStack ? FULL_W: FULL_W - 50, height: data[index].isExpand || data[index].isShowStack ? FULL_H: 480)
            .animation(.easeInOut(duration: stopAnimation ? 0 : 0.5))
            .sheet(isPresented: self.$showSheet) {
                SheetView(showSheet: $showSheet)
            }
    }
}

struct CardMainView: View {
    @Binding var selectedIndexHero: Int
    @Binding var selectedIndexHeroStack: Int
    @Binding var showStack: Bool
    @Binding var heroStack: Bool
    @Binding var hero: Bool
    @Binding var showSheet: Bool
    @Binding var data: [CardData]
    @State var isNearTime = false
    @State var index = 0

    var body: some View {
        ZStack (alignment: .top) {
            ZStack (alignment: .topLeading) {
                Image("fish")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: selectedIndexHeroStack > -2 ? (selectedIndexHeroStack == -1 ? FULL_W: FULL_W - 50) : showStack ? FULL_W - 50: data[index].isExpand ? FULL_W: FULL_W - 50)
                    .frame(height: selectedIndexHeroStack > -2 ? (selectedIndexHeroStack == -1 ? 300 : 480) : showStack ? 480 : data[index].isExpand ? 300 : data[index].stackCard.count > 0 ? 420 : 480)
                    .cornerRadius(15)
                TextCustom(text: data[index].title, font: "SFProDisplay-Bold", size: 30, lineLimit: 2, color: .white)
                    .padding(.top, 21)
                    .padding(.leading, 21)
                    .padding(.trailing, 90)
                    .offset(y: heroStack ? (selectedIndexHeroStack == -1 ? 25 : 0) : hero ? (data[index].isExpand ? 25 : 0) : 0)
                if isNearTime {
                    HStack (spacing: 0) {
                        Spacer(minLength: 0)
                        TextCustom(text: "in 14min", font: "SFProDisplay-Regular", size: 14, lineLimit: 1, color: .white)
                            .padding(.vertical, 5)
                            .padding(.horizontal, 10)
                            .overlay(
                                RoundedRectangle(cornerRadius: .infinity).stroke(Color.white, lineWidth: 1)
                            ).padding(.top, 26)
                            .padding(.trailing, 16)
                    }.opacity(heroStack ? (selectedIndexHeroStack == -1 ? 0 : 1) : hero ? (data[index].isExpand ? 0 : 1) : 1)
                }

                VStack (alignment: .leading, spacing: 0) {
                    Spacer(minLength: 0)
                    if !isNearTime {
                        HStack (alignment: .top, spacing: 0) {
                            VStack (alignment: .leading, spacing: 0) {
                                TextCustom(text: "9:00 pm", font: "SFProDisplay-Regular", size: 24, lineLimit: 1, color: .white)
                                TextCustom(text: "Wed, Sep 24", font: "SFProDisplay-Regular", size: 16, lineLimit: 1, color: #colorLiteral(red: 0.7681533694, green: 0.9018041492, blue: 0.9341397882, alpha: 1))
                            }
                            ZStack (alignment: .top) {
                                Rectangle()
                                    .frame(height: 10)
                                    .foregroundColor(.clear)

                                HStack (spacing: 0) {
                                    Rectangle()
                                        .frame(height: 1.5)
                                        .foregroundColor(.white)
                                        .padding(.trailing, 10)
                                    Image("moonIcon")
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 9, height: 10)
                                        .padding(.trailing, 5)
                                    Image("moonIcon")
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 9, height: 10)
                                    Rectangle()
                                        .frame(height: 1.5)
                                        .foregroundColor(.white)
                                        .padding(.leading, 10)
                                }
                            }.offset(y: 10)
                                .padding(.horizontal, 10)

                            VStack (alignment: .trailing, spacing: 0) {
                                TextCustom(text: "2:00 am", font: "SFProDisplay-Regular", size: 24, lineLimit: 1, color: .white)
                                TextCustom(text: "Wed, Sep 26", font: "SFProDisplay-Regular", size: 16, lineLimit: 1, color: #colorLiteral(red: 0.7681533694, green: 0.9018041492, blue: 0.9341397882, alpha: 1))
                            }
                        }
                    } else {
                        TextCustom(text: "Blue Bottle Coffe", font: "SFProDisplay-Regular", size: 24, lineLimit: 1, color: .white)
                        TextCustom(text: "456 University Ave, Palo Alto, CA 94301", font: "SFProDisplay-Regular", size: 16, lineLimit: 1, color: #colorLiteral(red: 0.7681533694, green: 0.9018041492, blue: 0.9341397882, alpha: 1))
                            .padding(.bottom, 10)
                        ZStack (alignment: .leading) {
                            RoundedRectangle(cornerRadius: .infinity)
                                .foregroundColor(.init(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.5045483733)))
                                .frame(height: 10)
                            RoundedRectangle(cornerRadius: .infinity)
                                .foregroundColor(.white)
                                .frame(height: 10)
                                .padding(.trailing, 50)
                        }
                        HStack (spacing: 0) {
                            TextCustom(text: "25 min remaining", font: "SFProDisplay-Regular", size: 16, lineLimit: 1, color: #colorLiteral(red: 0.7681533694, green: 0.9018041492, blue: 0.9341397882, alpha: 1))
                            Spacer(minLength: 0)
                            TextCustom(text: "2:00 am", font: "SFProDisplay-Regular", size: 16, lineLimit: 1, color: #colorLiteral(red: 0.7681533694, green: 0.9018041492, blue: 0.9341397882, alpha: 1))
                        }.padding(.top, 7)
                    }

                }.padding(.horizontal, 21)
                    .padding(.bottom, 21)
            }.frame(width: selectedIndexHeroStack > -2 ? (selectedIndexHeroStack == -1 ? FULL_W: FULL_W - 50) : showStack ? FULL_W - 50: data[index].isExpand ? FULL_W: FULL_W - 50)
                .frame(height: selectedIndexHeroStack > -2 ? (selectedIndexHeroStack == -1 ? 300 : 480) : showStack ? 480 : data[index].isExpand ? 300 : data[index].stackCard.count > 0 ? 420 : 480)
            Image("")
                .resizable()
                .frame(width: data[index].isExpand ? FULL_W: FULL_W - 50, height: 480)
                .onTapGesture {
                    if self.showStack {
                        if !self.heroStack {
                            self.heroStack = true
                            self.selectedIndexHeroStack = -1
                        }
                    } else {
                        if data[index].stackCard.count == 0 {
                            if !self.hero {
                                self.hero = true
                                self.data[index].isExpand = true
                                self.selectedIndexHero = index
                            }
                        } else {
                            self.showStack = true
                            self.data[index].isShowStack = true
                        }
                    }
                }.onLongPressGesture(minimumDuration: 0.1) {
                    self.showSheet = true
            }
        }.opacity(heroStack ? (selectedIndexHeroStack == -1) ? 1 : 0: 1)
    }
}

struct CardChildrenView: View {
    @Binding var heroStack: Bool
    @Binding var positionStackIndex: Bool
    @Binding var stopAnimation: Bool
    @Binding var selectedIndexHeroStack: Int
    @Binding var data: [CardData]
    @Binding var showStack: Bool
    @State var indexRoot = 0
    @State var indexChild = 0
    @State var spaceStack: CGFloat = 0
    @State var delay: CGFloat = 0
    @State var title = ""

    var body: some View {
        ZStack (alignment: .topLeading) {
            Image("fish")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: selectedIndexHeroStack > -1 ? (data[indexRoot].stackCard[selectedIndexHeroStack].isExpandStack ? FULL_W: FULL_W - 50) : FULL_W - 50)
                .frame(height: selectedIndexHeroStack > -1 ? (data[indexRoot].stackCard[selectedIndexHeroStack].isExpandStack ? 300 : 480) : 480)
                .cornerRadius(15)
            TextCustom(text: title, font: "SFProDisplay-Bold", size: 30, lineLimit: 2, color: .white)
                .padding(.top, 21)
                .padding(.leading, 21)
                .padding(.trailing, 90)
                .offset(y: heroStack && selectedIndexHeroStack > -1 ? (data[indexRoot].stackCard[selectedIndexHeroStack].isExpandStack ? 25 : 0) : 0)
            VStack (spacing: 0) {
                Spacer(minLength: 0)
                HStack (alignment: .top, spacing: 0) {
                    VStack (alignment: .leading, spacing: 0) {
                        TextCustom(text: "9:00 pm", font: "SFProDisplay-Regular", size: 24, lineLimit: 1, color: .white)
                        TextCustom(text: "Wed, Sep 24", font: "SFProDisplay-Regular", size: 16, lineLimit: 1, color: #colorLiteral(red: 0.7681533694, green: 0.9018041492, blue: 0.9341397882, alpha: 1))
                    }
                    ZStack (alignment: .top) {
                        Rectangle()
                            .frame(height: 10)
                            .foregroundColor(.clear)

                        HStack (spacing: 0) {
                            Rectangle()
                                .frame(height: 1.5)
                                .foregroundColor(.white)
                                .padding(.trailing, 10)
                            Image("moonIcon")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 9, height: 10)
                                .padding(.trailing, 5)
                            Image("moonIcon")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 9, height: 10)
                            Rectangle()
                                .frame(height: 1.5)
                                .foregroundColor(.white)
                                .padding(.leading, 10)
                        }
                    }.offset(y: 10)
                        .padding(.horizontal, 10)

                    VStack (alignment: .trailing, spacing: 0) {
                        TextCustom(text: "2:00 am", font: "SFProDisplay-Regular", size: 24, lineLimit: 1, color: .white)
                        TextCustom(text: "Wed, Sep 26", font: "SFProDisplay-Regular", size: 16, lineLimit: 1, color: #colorLiteral(red: 0.7681533694, green: 0.9018041492, blue: 0.9341397882, alpha: 1))
                    }
                }
            }.padding(.bottom, 21)
                .padding(.horizontal, 21)
        }.frame(width: selectedIndexHeroStack > -1 ? (data[indexRoot].stackCard[selectedIndexHeroStack].isExpandStack ? FULL_W: FULL_W - 50) : FULL_W - 50)
            .frame(height: selectedIndexHeroStack > -1 ? (data[indexRoot].stackCard[selectedIndexHeroStack].isExpandStack ? 300 : 480) : 480)
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                    self.positionStackIndex = true
                }
            }.offset(x: positionStackIndex ? spaceStack * CGFloat(indexChild + 1) : 0)
            .animation(.easeInOut(duration: stopAnimation ? 0 : 0.5))

    }
}

struct CardData {
    var title: String
    var isNearTime: Bool
    var isExpand: Bool
    var isShowStack: Bool
    var stackCard: [StackCardData]
}

struct StackCardData {
    var isExpandStack: Bool
    var title: String
}
