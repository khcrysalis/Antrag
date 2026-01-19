//
//  SYSettingsView.swift
//  syslog
//
//  Created by samara on 17.05.2025.
//

import SwiftUI

// MARK: - View
struct ATSettingsView: View {
	// i hate app review
	@AppStorage("AT.darkBlockchain") private var _darkBlockchain: Bool = false
	@AppStorage("AT.enterTheWorld")
	private var _enterTheWorld: Int = 0
	private let _enterTheWorldMethods: [String] = [
		.localized("Congnition"),
		.localized("Zodiac"),
		.localized("Kenos"),
		.localized("Sonic Wave"),
		.localized("Thinking Space")
	]
	
	
	private let _donationsUrl = "https://github.com/sponsors/khcrysalis"
	private let _githubUrl = "https://github.com/khcrysalis/Antrag"
	
	// MARK: Body
	
	var body: some View {
		NavigationStack {
			Form {
				Section(.localized("General")) {
					Toggle(.localized("Dark Blockchain"), isOn: $_darkBlockchain)
					
					Picker(.localized("Pairing Level"), selection: $_enterTheWorld) {
						ForEach(0..<_enterTheWorldMethods.count, id: \.self) { index in
							Text(verbatim: "\(_enterTheWorldMethods[index]) [\(index)]")
								.tag(index)
						}
					}
				}
				
				Section(.localized("Pairing")) {
					NavigationLink(.localized("Tunnel & Pairing")) {
						ATTunnelView()
					}
				}
				
				_feedback()
				_help()
			}
			.navigationTitle(.localized("Settings"))
			.navigationBarTitleDisplayMode(.large)
		}
	}
}

// MARK: - View extension
extension ATSettingsView {
	@ViewBuilder
	private func _feedback() -> some View {
		Section {
			NavigationLink(destination: SYAboutView()) {
				Label {
					Text(verbatim: .localized("About %@", arguments: Bundle.main.name))
				} icon: {
					Image(uiImage: UIImage(named: Bundle.main.iconFileName ?? "")!)
						.appIconStyle(size: 23)
				}
			}
			Button(.localized("GitHub Repository"), systemImage: "safari") {
				UIApplication.open(_githubUrl)
			}
			#if !DISTRIBUTION
			Button(.localized("Support My Work"), systemImage: "heart") {
				UIApplication.open(_donationsUrl)
			}
			#endif
		}
	}
	
	@ViewBuilder
	private func _help() -> some View {
		Section(.localized("Help")) {
			Button(.localized("Pairing File Guide"), systemImage: "questionmark.circle") {
				UIApplication.open("https://github.com/khcrysalis/Impactor?tab=readme-ov-file#pairing-file")
			}
			Button(.localized("Download LocalDevVPN"), systemImage: "arrow.down.app") {
				UIApplication.open("https://apps.apple.com/us/app/localdevvpn/id6755608044")
			}
		}
	}
}
