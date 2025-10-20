import SwiftUI

struct CreateGroupScreen: View {

    // TODO: Extract to view model
    @State var groupName: String = ""

    var body: some View {
        VStack {
            FullScreenSheetTopBar(
                title: "Create group",
                imageIcon: "xmark")

            ScrollView {
                LazyVStack(spacing: UIStyleConstants.Spacing.xl.rawValue) {
                    // Group name
                    InputField(
                        "Group name",
                        placeHolder: "Identify your group by",
                        value: $groupName)

                    HStack(alignment: .center, spacing: UIStyleConstants.Spacing.md.rawValue) {
                        VStack(alignment: .leading) {
                            Text("Add members")
                                .font(UIStyleConstants.Typography.body.font)
                                .foregroundStyle(UIStyleConstants.Colors.foreground.value)
                                .bold()

                            Text("You can add friends with whom you want split expenses")
                                .font(UIStyleConstants.Typography.caption.font)
                                .foregroundStyle(UIStyleConstants.Colors.foreground.value)
                                .fontWeight(.light)
                        }

                        Spacer()

                        ImageButton(imageIcon: "plus") {

                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)

                    LazyVStack {
                        ForEach(1..<6) { _ in
                            HStack {
                                Avatar()

                                Text("Ritesh Khore")
                                    .font(UIStyleConstants.Typography.body.font)
                                    .foregroundStyle(UIStyleConstants.Colors.foreground.value)
                                    .bold()

                                Spacer()

                                ImageButton(
                                    imageIcon: "minus",
                                    size: .init(width: 16, height: 16),
                                    foregroundStyle: UIStyleConstants.Colors.destructive.value) {
                                }
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                }
                .padding(.top, UIStyleConstants.Spacing.lg.rawValue)
            }
        }
        .padding(.horizontal, UIStyleConstants.Spacing.md.rawValue)
        .background(UIStyleConstants.Colors.background.value)
        .safeAreaInset(edge: .bottom) {
            Group {
                AppButton(style: .primary) {
                    Text("Create")
                        .font(UIStyleConstants.Typography.body.font.bold())
                } action: {

                }
                .padding(.vertical, UIStyleConstants.Spacing.s.rawValue)
                .padding(.horizontal, UIStyleConstants.Spacing.md.rawValue)
            }
            .background(UIStyleConstants.Colors.background.value)
        }
    }
}

#Preview {
    CreateGroupScreen()
}
