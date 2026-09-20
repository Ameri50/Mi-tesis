import SwiftUI

struct LegalSection: Identifiable {
    let id = UUID()
    let title: String
    let body: String
}

struct LegalDocumentView: View {
    @EnvironmentObject var themeManager: ThemeManager
    @EnvironmentObject var localizationManager: LocalizationManager
    @AppStorage("appFontSize") private var fontSize: Double = 16

    let title: String
    let subtitle: String
    let lastUpdated: String
    let sections: [LegalSection]

    var body: some View {
        ZStack {
            Color(UIColor { _ in
                themeManager.isDarkMode ? UIColor(white: 0.11, alpha: 1) : .systemGroupedBackground
            })
            .ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 16) {
                    header

                    ForEach(sections) { section in
                        VStack(alignment: .leading, spacing: 10) {
                            Text(section.title)
                                .font(.system(size: fontSize + 1, weight: .semibold))
                                .foregroundColor(themeManager.isDarkMode ? .white : .primary)

                            Text(section.body)
                                .font(.system(size: fontSize - 1))
                                .foregroundColor(.secondary)
                                .fixedSize(horizontal: false, vertical: true)
                                .lineSpacing(3)
                        }
                        .padding(16)
                        .background(Color(UIColor { _ in
                            themeManager.isDarkMode ? UIColor(white: 0.15, alpha: 1) : .systemBackground
                        }))
                        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                    }
                }
                .padding(16)
            }
        }
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 10) {
            Image(systemName: "doc.text.fill")
                .font(.system(size: 28))
                .foregroundColor(.orange)

            Text(subtitle)
                .font(.system(size: fontSize, weight: .regular))
                .foregroundColor(.secondary)
                .fixedSize(horizontal: false, vertical: true)

            Text(String(format: localizationManager.translate("legal.updated"), lastUpdated))
                .font(.system(size: fontSize - 3, weight: .medium))
                .foregroundColor(.secondary)
        }
        .padding(18)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            LinearGradient(
                colors: [
                    Color.orange.opacity(themeManager.isDarkMode ? 0.24 : 0.16),
                    Color.blue.opacity(themeManager.isDarkMode ? 0.16 : 0.08)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
    }
}

struct PrivacyPolicyView: View {
    @EnvironmentObject var localizationManager: LocalizationManager

    var body: some View {
        let t = localizationManager.translate
        return LegalDocumentView(
            title: t("legal.privacy.title"),
            subtitle: t("legal.privacy.subtitle"),
            lastUpdated: t("legal.privacy.date"),
            sections: [
                LegalSection(title: t("legal.privacy.s1.title"), body: t("legal.privacy.s1.body")),
                LegalSection(title: t("legal.privacy.s2.title"), body: t("legal.privacy.s2.body")),
                LegalSection(title: t("legal.privacy.s3.title"), body: t("legal.privacy.s3.body")),
                LegalSection(title: t("legal.privacy.s4.title"), body: t("legal.privacy.s4.body"))
            ]
        )
    }
}

struct TermsOfServiceView: View {
    @EnvironmentObject var localizationManager: LocalizationManager

    var body: some View {
        let t = localizationManager.translate
        return LegalDocumentView(
            title: t("legal.terms.title"),
            subtitle: t("legal.terms.subtitle"),
            lastUpdated: t("legal.terms.date"),
            sections: [
                LegalSection(title: t("legal.terms.s1.title"), body: t("legal.terms.s1.body")),
                LegalSection(title: t("legal.terms.s2.title"), body: t("legal.terms.s2.body")),
                LegalSection(title: t("legal.terms.s3.title"), body: t("legal.terms.s3.body")),
                LegalSection(title: t("legal.terms.s4.title"), body: t("legal.terms.s4.body"))
            ]
        )
    }
}

#Preview("Politica de Privacidad") {
    NavigationStack {
        PrivacyPolicyView()
            .environmentObject(ThemeManager())
            .environmentObject(LocalizationManager())
    }
}
