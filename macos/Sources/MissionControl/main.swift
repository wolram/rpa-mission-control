import Foundation
import SwiftUI
import AppKit

// MARK: - Models

struct Agent: Identifiable {
    let id = UUID()
    let name: String
    let role: String
    let status: String
    let color: Color
}

struct ProjectFile: Identifiable {
    let id = UUID()
    let name: String
    let type: String
}

// MARK: - View Model

class MissionControlViewModel: ObservableObject {
    @Published var agents: [Agent] = [
        Agent(name: "Architect", role: "System Design", status: "Idle", color: .blue),
        Agent(name: "Coder Alpha", role: "Implementation", status: "Active", color: .green),
        Agent(name: "QA Agent", role: "Unit Tests", status: "Idle", color: .orange)
    ]
    
    @Published var files: [ProjectFile] = [
        ProjectFile(name: "App.swift", type: "swift"),
        ProjectFile(name: "ContentView.swift", type: "swift"),
        ProjectFile(name: "ProductModel.swift", type: "swift")
    ]
}

// MARK: - Views

struct SidebarView: View {
    @ObservedObject var viewModel: MissionControlViewModel
    
    var body: some View {
        List {
            Section("Active Agents") {
                ForEach(viewModel.agents) { agent in
                    HStack {
                        Circle().fill(agent.color).frame(width: 8, height: 8)
                        VStack(alignment: .leading) {
                            Text(agent.name).font(.headline)
                            Text(agent.role).font(.subheadline).foregroundColor(.secondary)
                        }
                    }
                }
            }
            
            Section("Project Files") {
                ForEach(viewModel.files) { file in
                    Label(file.name, systemImage: "doc.text.fill")
                }
            }
        }
        .listStyle(SidebarListStyle())
    }
}

struct WorkflowCanvasView: View {
    var body: some View {
        ZStack {
            VisualEffectView(material: .underWindowBackground, blendingMode: .behindWindow)
            VStack {
                HStack {
                    Button(action: {}) {
                        Label("Import Workflow", systemImage: "square.and.arrow.down")
                    }
                    Spacer()
                    Text("CTX: 12%").font(.caption).monospaced()
                }
                .padding()
                
                Spacer()
                
                VStack(spacing: 20) {
                    Image(systemName: "rectangle.3.group.fill")
                        .font(.system(size: 50))
                        .foregroundColor(.secondary)
                    Text("Visual Workflow Canvas")
                        .font(.title2)
                        .bold()
                }
                
                Spacer()
                
                VStack(alignment: .leading) {
                    Text("SYSTEM OUTPUT").font(.caption).bold()
                    ScrollView {
                        Text("10:42:01  System       Terminal AI Pro Session Initialized\n10:42:02  Orchestrator Loading agent configurations...\n10:42:02  Orchestrator 4 Agents loaded successfully")
                            .font(.system(.caption, design: .monospaced))
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .frame(height: 100)
                    .padding(8)
                    .background(Color.black.opacity(0.2))
                    .cornerRadius(8)
                }
                .padding()
            }
        }
    }
}

struct InspectorView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack {
                Circle().fill(Color.green).frame(width: 10, height: 10)
                Text("UI Architect").font(.headline)
            }
            
            Text("Analyzing user requirements to generate comprehensive SwiftUI view hierarchy.")
                .font(.subheadline)
            
            VStack(alignment: .leading) {
                Text("CURRENT TASK").font(.caption).bold()
                HStack {
                    Text("Action")
                    Spacer()
                    Text("Analyze UX").bold()
                }
                ProgressView(value: 0.45)
            }
            
            Divider()
            
            VStack(alignment: .leading, spacing: 10) {
                Text("RESOURCES").font(.caption).bold()
                Label("Compute: Standard", systemImage: "cpu")
                Label("Memory: 256MB", systemImage: "memorychip")
                Label("Est. Cost: /bin/bash.04/h", systemImage: "dollarsign.circle")
            }
            
            Spacer()
        }
        .padding()
        .frame(width: 250)
    }
}

struct VisualEffectView: NSViewRepresentable {
    let material: NSVisualEffectView.Material
    let blendingMode: NSVisualEffectView.BlendingMode
    
    func makeNSView(context: Context) -> NSVisualEffectView {
        let view = NSVisualEffectView()
        view.material = material
        view.blendingMode = blendingMode
        view.state = .active
        return view
    }
    
    func updateNSView(_ nsView: NSVisualEffectView, context: Context) {
        nsView.material = material
        nsView.blendingMode = blendingMode
    }
}

struct ContentView: View {
    @StateObject var viewModel = MissionControlViewModel()
    
    var body: some View {
        NavigationSplitView {
            SidebarView(viewModel: viewModel)
        } detail: {
            HStack(spacing: 0) {
                WorkflowCanvasView()
                Divider()
                InspectorView()
            }
        }
        .navigationTitle("RPA Mission Control")
    }
}

// MARK: - App Entry

struct MissionControlApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .windowStyle(.hiddenTitleBar)
    }
}

// CLI Shim / Launcher
@main
struct AppLauncher {
    static func main() {
        print("🚀 Mission Control launching in UI mode...")
        let app = NSApplication.shared
        let delegate = AppDelegate()
        app.delegate = delegate
        app.run()
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    var window: NSWindow!

    func applicationDidFinishLaunching(_ notification: Notification) {
        let contentView = ContentView()
        window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 1000, height: 700),
            styleMask: [.titled, .closable, .miniaturizable, .resizable, .fullSizeContentView],
            backing: .buffered, defer: false)
        window.center()
        window.setFrameAutosaveName("Mission Control Window")
        window.contentView = NSHostingView(rootView: contentView)
        window.makeKeyAndOrderFront(nil)
        window.title = "RPA Mission Control"
        window.titleVisibility = .hidden
        window.titlebarAppearsTransparent = true
    }
}
