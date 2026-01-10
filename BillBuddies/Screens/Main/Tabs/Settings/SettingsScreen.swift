import SwiftUI

struct SettingsScreen: View {

    @Environment(\.colorScheme) private var systemColorScheme
    @EnvironmentObject private var themeManager: ThemeManager
    @EnvironmentObject private var authManager: AuthManager
    @EnvironmentObject private var router: NavigationRouter
    @StateObject private var viewModel = SettingsScreenViewModel()

    var body: some View {
        VStack {
            HStack {
                Text("Settings")
                    .font(UIStyleConstants.Typography.subHeading.font)
                    .bold()
                    .foregroundStyle(UIStyleConstants.Colors.foreground.value)
            }.frame(maxWidth: .infinity, alignment: .center)

            List {
                VStack {
                    Avatar(size: 120)

                    Text("Ritesh Khore")
                        .font(UIStyleConstants.Typography.heading2.font)
                }
                .frame(maxWidth: .infinity, alignment: .center)
                .listRowBackground(Color.clear)
                .listRowSeparator(.hidden)

                ForEach(viewModel.sections) { section in
                    Section {
                        ForEach(section.items) { item in
                            SettingRow(item: item)
                                .onTapGesture {
                                    item.action?()
                                }
                        }
                    } header: {
                        Text(section.name)
                            .font(UIStyleConstants.Typography.caption.font)
                    }
                    .listRowSeparator(.hidden)
                    .listRowBackground(UIStyleConstants.Colors.background.value)
                }
            }
            .scrollContentBackground(.hidden)
        }
        .padding(.horizontal, UIStyleConstants.Spacing.md.rawValue)
        .background(UIStyleConstants.Colors.background.value)
        .onAppear {
            viewModel.themeManager = themeManager
            viewModel.configure(authManager: authManager, router: router)
        }
    }
}

fileprivate struct SettingRow: View {

    let item: Setting

    var body: some View {
        HStack(alignment: .center) {
            Image(systemName: item.imageIcon)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 22, height: 22)
                .foregroundStyle(UIStyleConstants.Colors.foreground.value)

            Text(item.name)
                .foregroundStyle(UIStyleConstants.Colors.foreground.value)
                .font(UIStyleConstants.Typography.body.font)

            Spacer()

            if item.actionIcon != nil {
                Image(systemName: "chevron.right")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 16, height: 16)
                    .foregroundStyle(UIStyleConstants.Colors.foreground.value)
            } else if let actionView = item.actionView {
                actionView()
            } else {
                EmptyView()
            }
        }
    }
}

#Preview {
    SettingsScreen()
}
