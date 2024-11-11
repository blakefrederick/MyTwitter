// PostRowView.swift
import SwiftUI

struct PostRowView: View {
    var post: Post
    var onDelete: () -> Void
    @Environment(\.openURL) var openURL
    @State private var showCopiedNotification = false

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            // User Avatar - grab the site's favicon
            if let faviconURL = getFaviconURL(from: post.username) {
                AsyncImage(url: faviconURL) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                            .frame(width: 48, height: 48)
                    case .success(let image):
                        image
                            .resizable()
                            .frame(width: 48, height: 48)
                            .clipShape(Circle())
                    case .failure:
                        // default fallback if no favicon found
                        Image(systemName: "person.crop.circle")
                            .resizable()
                            .frame(width: 48, height: 48)
                            .foregroundColor(.blue)
                    @unknown default:
                        EmptyView()
                    }
                }
            } else {
                Image(systemName: "person.crop.circle")
                    .resizable()
                    .frame(width: 48, height: 48)
                    .foregroundColor(.blue)
            }
            
            // Post Content
            VStack(alignment: .leading, spacing: 4) {
                Text(post.username)
                    .font(.subheadline)
                    .foregroundColor(.blue)
                    .onTapGesture {
                        if let url = URL(string: post.username), UIApplication.shared.canOpenURL(url) {
                            openURL(url)
                        } else if let url = URL(string: "https://" + post.username), UIApplication.shared.canOpenURL(url) {
                            openURL(url)
                        }
                    }
                
                // Text with excess whitespace removed
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
            Button(role: .destructive) {
                onDelete()
            } label: {
                Label("Delete", systemImage: "trash")
            }
        }
        .onLongPressGesture {
            // copy to clipboard
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
        }
        .overlay(
            Group {
                if showCopiedNotification {
                    VStack {
                        Text("copied")
                            .font(.caption)
                            .padding(6)
                            .background(Color.black.opacity(0.65))
                            .foregroundColor(.white)
                            .cornerRadius(6)
                            .transition(.opacity)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
                    .padding([.bottom, .trailing], 6)
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
}
