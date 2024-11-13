// PostRowView.swift
import SwiftUI

struct PostRowView: View {
    var post: Post
    var onDelete: () -> Void
    var onSuperDelete: () -> Void
    @Environment(\.openURL) var openURL
    @State private var showCopiedNotification = false
    let avatarSize: CGFloat = 34

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            // User Avatar - grab the site's favicon
            if let faviconURL = getFaviconURL(from: post.username) {
                AsyncImage(url: faviconURL) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                            .frame(width: avatarSize, height: avatarSize)
                    case .success(let image):
                        image
                            .resizable()
                            .frame(width: avatarSize, height: avatarSize)
                            .clipShape(Circle())
                    case .failure:
                        Image(systemName: "person.crop.circle")
                            .resizable()
                            .frame(width: avatarSize, height: avatarSize)
                            .foregroundColor(.blue)
                    @unknown default:
                        EmptyView()
                    }
                }
            } else {
                Image(systemName: "person.crop.circle")
                    .resizable()
                    .frame(width: avatarSize, height: avatarSize)
                    .foregroundColor(.blue)
            }
            
            // Post Content
            VStack(alignment: .leading, spacing: 4) {
                HStack(alignment: .firstTextBaseline, spacing: 2) {
                    // Title or Username
                    Text(post.title?.isEmpty == false ? post.title! : post.username)
                        .font(.footnote)
                        .foregroundColor(.gray)
                        .lineLimit(1) 
                    
                    // Domain 
                    if let title = post.title, !title.isEmpty, let domain = extractDomainFromURL(post.username) {
                        Text("   \(domain)")
                            .font(.caption2) // smaller
                            .foregroundColor(.gray.opacity(0.7))
                            .lineLimit(1)
                    }
                }
                .onTapGesture {
                    let urlString = post.title?.isEmpty == false ? post.username : post.username
                    if let url = URL(string: urlString), UIApplication.shared.canOpenURL(url) {
                        openURL(url)
                    } else if let url = URL(string: "https://" + urlString), UIApplication.shared.canOpenURL(url) {
                        openURL(url)
                    }
                }
                // Post text with excess whitespace removed
                Text(post.text.replacingOccurrences(of: "\\s+", with: " ", options: .regularExpression))
                    .font(.body)
                    .lineLimit(nil)
                
                // Image
                if let imageUrl = URL(string: post.imageUrl), !post.imageUrl.isEmpty {
                    AsyncImage(url: imageUrl) { phase in
                        switch phase {
                        case .empty:
                            ProgressView()
                        case .success(let image):
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(maxHeight: 200)
                        case .failure:
                            EmptyView()
                        @unknown default:
                            EmptyView()
                        }
                    }
                }
            }
        }
        .padding(.vertical, 8)
        .swipeActions(edge: .trailing) {
            // Delete on the right
            Button(role: .destructive) {
                onDelete()
            } label: {
                Label("Delete", systemImage: "trash")
            }
            // Super Delete
            Button {
                onSuperDelete()
            } label: {
                Label("Del All", systemImage: "trash.slash")
            }
            .tint(Color(red: 0.5, green: 0, blue: 0.5))
        }
        .swipeActions(edge: .leading) {
            // Copy on the left
            Button {
                UIPasteboard.general.string = post.text

                withAnimation {
                    showCopiedNotification = true
                }

                // Haptic feedback!
                let generator = UINotificationFeedbackGenerator()
                generator.notificationOccurred(.success)

                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    withAnimation {
                        showCopiedNotification = false
                    }
                }
            } label: {
                Label("Copy", systemImage: "doc.on.doc")
            }
            .tint(.blue)
        }
        .overlay(
            Group {
                if showCopiedNotification {
                    VStack {
                        Spacer()
                        Text("copied")
                            .font(.caption)
                            .padding(6)
                            .background(Color.black.opacity(0.65))
                            .foregroundColor(.white)
                            .cornerRadius(6)
                            .padding(.bottom, 6)
                            .transition(.opacity)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
                    .padding([.bottom, .trailing], 12)
                }
            }
        )
    }

    func getFaviconURL(from urlString: String) -> URL? {
        var urlString = urlString
        if !urlString.contains("://") {
            urlString = "https://" + urlString
        }
        if let url = URL(string: urlString), let host = url.host {
            let faviconURLString = "https://www.google.com/s2/favicons?sz=64&domain_url=\(host)"
            return URL(string: faviconURLString)
        }
        return nil
    }

    func extractDomainFromURL(_ urlString: String) -> String? {
        guard let url = URL(string: urlString) else { return nil }
        return url.host?.replacingOccurrences(of: "www.", with: "")
    }
}
