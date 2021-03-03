import SwiftUI

struct MessageSheetType {
    var text: String
    var isMedium: Bool
}

struct MessageImageSheet {
    var text: String
    var iconName: String
}

struct SheetView: View {
    @Binding var showSheet: Bool
    var dataMessage_1 = [
        MessageSheetType(text: "Send message to attendees", isMedium: true),
        MessageSheetType(text: "\"Be right there.\"", isMedium: false),
        MessageSheetType(text: "\"Running few min late.\"", isMedium: false),
        MessageSheetType(text: "\"I'm here - call me.\"", isMedium: false)
    ]
    var dataMessage_2 = [
        MessageImageSheet(text: "Edit Event", iconName: "editEvent"),
        MessageImageSheet(text: "Cancel & Notify", iconName: "notify"),
        MessageImageSheet(text: "Reschedule", iconName: "reschedule"),
        MessageImageSheet(text: "Follow-up Reminder", iconName: "reminder"),
        MessageImageSheet(text: "Call Organizer", iconName: "call")
    ]

    var body: some View {
        ZStack (alignment: .top) {
            Rectangle().foregroundColor(.init(#colorLiteral(red: 0.1120981351, green: 0.1217719093, blue: 0.1345578432, alpha: 1)))
            VStack (spacing: 0) {
                HStack (spacing: 0) {
                    VStack (alignment: .leading, spacing: 3) {
                        TextCustom(text: "Timeless Meetings", font: "SFProDisplay-Heavy", size: 15, lineLimit: 1, color: #colorLiteral(red: 0.7324784398, green: 0.7374201417, blue: 0.7415499091, alpha: 1))
                        HStack (spacing: 0) {
                            TextCustom(text: "09:00am - ", font: "SFProDisplay-Regular", size: 13, lineLimit: 1, color: #colorLiteral(red: 0.7324784398, green: 0.7374201417, blue: 0.7415499091, alpha: 1))
                            ImageCustom(name: "moonIcon", w: 9, h: 10)
                            TextCustom(text: " - 10:00am", font: "SFProDisplay-Regular", size: 13, lineLimit: 1, color: #colorLiteral(red: 0.7324784398, green: 0.7374201417, blue: 0.7415499091, alpha: 1))
                        }

                    }
                    Spacer(minLength: 0)
                    Button(action: {
                        self.showSheet = false
                    }) {
                        Image(systemName: "xmark")
                            .foregroundColor(.white)
                    }
                }.padding(21)
                Rectangle()
                    .frame(width: FULL_W, height: 1.5)
                    .foregroundColor(.init(#colorLiteral(red: 0.2070617378, green: 0.2118211687, blue: 0.2246984541, alpha: 1)))
                ScrollView (showsIndicators: false) {
                    VStack (alignment: .leading, spacing: 0) {
                        VStack (alignment: .leading, spacing: 0) {
                            ForEach(0 ..< dataMessage_1.count) { i in
                                MessageSheetView(
                                    text: dataMessage_1[i].text,
                                    isMedium: dataMessage_1[i].isMedium,
                                    isEnd: i == dataMessage_1.count - 1 ? true : false
                                )
                            }
                        }.frame(width: FULL_W - 32)
                            .background(Color.init(#colorLiteral(red: 0.09246385843, green: 0.1022024825, blue: 0.1106716916, alpha: 1)))
                            .cornerRadius(15)
                            .padding(.top, 21)
                        VStack (alignment: .leading, spacing: 0) {
                            ForEach(0 ..< dataMessage_2.count) { i in
                                MessageSheetView(
                                    iconName: dataMessage_2[i].iconName,
                                    text: dataMessage_2[i].text,
                                    isEnd: i == dataMessage_2.count - 1 ? true : false
                                )
                            }
                        }.frame(width: FULL_W - 32)
                            .background(Color.init(#colorLiteral(red: 0.09246385843, green: 0.1022024825, blue: 0.1106716916, alpha: 1)))
                            .cornerRadius(15)
                            .padding(.top, 7.5)
                        VStack (alignment: .leading, spacing: 0) {
                            MessageSheetView(
                                iconName: "cursor",
                                text: "Navigate to Destination",
                                text_2: "ETA 25min",
                                isEnd: true
                            )
                        }.frame(width: FULL_W - 32)
                            .background(Color.init(#colorLiteral(red: 0.09246385843, green: 0.1022024825, blue: 0.1106716916, alpha: 1)))
                            .cornerRadius(15)
                            .padding(.top, 7.5)
                            .padding(.bottom, 18)
                        Button(action: {

                        }) {
                            TextCustom(text: "Custom Settings...", font: "SFProDisplay-Regular", size: 16, lineLimit: 1, color: #colorLiteral(red: 1, green: 0.3038072288, blue: 0.3354249597, alpha: 1))
                        }.padding(.leading, 32)
                    }
                }
            }
        }.edgesIgnoringSafeArea(.bottom)
    }
}

struct MessageSheetView: View {
    var iconName = ""
    var text = ""
    var text_2 = ""
    var isMedium = false
    var isEnd = false

    var body: some View {
        Button(action: {

        }) {
            ZStack (alignment: .leading) {
                Image("").resizable()
                    .frame(width: FULL_W - 32, height: text_2.isEmpty ? 52 : 55)
                VStack (alignment: .leading, spacing: 0) {
                    TextCustom(text: text, font: isMedium ? "SFProDisplay-Medium" : "SFProDisplay-Regular", size: isMedium ? 13 : 16, lineLimit: 1, color: isMedium ? #colorLiteral(red: 0.999904573, green: 1, blue: 0.9998808503, alpha: 1): #colorLiteral(red: 0.814807713, green: 0.8198155761, blue: 0.8195853829, alpha: 1))
                    if !text_2.isEmpty {
                        TextCustom(text: text_2, font: "SFProDisplay-Regular", size: 14, lineLimit: 1, color: #colorLiteral(red: 0.4540682435, green: 0.4589733481, blue: 0.4631484747, alpha: 1))
                    }
                }.padding(.horizontal, 16)
                if !iconName.isEmpty {
                    HStack (spacing: 0) {
                        Spacer(minLength: 0)
                        ImageCustom(name: iconName, w: 22, h: 22)
                            .padding(.trailing, 21)
                    }
                }
            }
        }
        if !isEnd {
            Rectangle().frame(height: 1.5)
                .foregroundColor(.init(#colorLiteral(red: 0.1913578808, green: 0.1961738765, blue: 0.2047244906, alpha: 1)))
        }
    }
}
