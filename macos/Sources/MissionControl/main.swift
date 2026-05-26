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

struct Node: Identifiable, Equatable {
    let id = UUID()
    var name: String
    var position: CGPoint
    var type: NodeType
    
    enum NodeType {
        case agent, condition, action
    }
}

struct Connection: Identifiable, Equatable {
    let id = UUID()
    let fromId: UUID
    let toId: UUID
}

struct LogEntry: Identifiable {
    let id = UUID()
    let time: String
    let tag: String
    let msg: String
    let color: Color
}

// MARK: - View Model

class MissionControlViewModel: ObservableObject {
    @Published var agents: [Agent] = [
        Agent(name: "Architect", role: "System Design", status: "Idle", color: .blue),
        Agent(name: "Coder Alpha", role: "Implementation", status: "Active", color: .green),
        Agent(name: "Vision Agent", role: "UI/UX Analysis", status: "Idle", color: .cyan)
    ]
    
    @Published var nodes: [Node] = [
        Node(name: "Start", position: CGPoint(x: 100, y: 300), type: .action),
        Node(name: "LLM Analyze", position: CGPoint(x: 350, y: 200), type: .agent),
        Node(name: "SwiftUI Gen", position: CGPoint(x: 350, y: 400), type: .agent),
        Node(name: "Build & Run", position: CGPoint(x: 600, y: 300), type: .action)
    ]
    
    @Published var connections: [Connection] = []
    @Published var logs: [LogEntry] = []
    @Published var isRunning = false
    @Published var flowProgress: CGFloat = 0.0
    
    init() {
        connections = [
            Connection(fromId: nodes[0].id, toId: nodes[1].id),
            Connection(fromId: nodes[0].id, toId: nodes[2].id),
            Connection(fromId: nodes[1].id, toId: nodes[3].id),
            Connection(fromId: nodes[2].id, toId: nodes[3].id)
        ]
        addLog(tag: "System", msg: "Premium Engine v5.1 Restored", color: .blue)
    }
    
    func addLog(tag: String, msg: String, color: Color) {
        let formatter = DateFormatter(); formatter.dateFormat = "HH:mm:ss"
        let t = formatter.string(from: Date())
        DispatchQueue.main.async { self.logs.append(LogEntry(time: t, tag: tag, msg: msg, color: color)) }
    }
    
    func moveNode(id: UUID, translation: CGSize) {
        if let index = nodes.firstIndex(where: { $0.id == id }) {
            nodes[index].position.x += translation.width
            nodes[index].position.y += translation.height
        }
    }
    
    func runAutomation() {
        guard !isRunning else { return }
        isRunning = true
        flowProgress = 0
        addLog(tag: "Engine", msg: "Firing data through Navigation Graph...", color: .orange)
        
        withAnimation(.easeInOut(duration: 3.0)) {
            flowProgress = 1.0
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.addLog(tag: "System", msg: "Process finished on all active nodes.", color: .green)
            self.isRunning = false
        }
    }
}

// MARK: - Components

struct VisualEffectView: NSViewRepresentable {
    let material: NSVisualEffectView.Material; let blendingMode: NSVisualEffectView.BlendingMode
    func makeNSView(context: Context) -> NSVisualEffectView {
        let v = NSVisualEffectView(); v.material = material; v.blendingMode = blendingMode; v.state = .active; return v
    }
    func updateNSView(_ v: NSVisualEffectView, context: Context) {}
}

struct FollowPathModifier: AnimatableModifier {
    let from: CGPoint; let to: CGPoint; var progress: CGFloat
    var animatableData: CGFloat { get { progress } set { progress = newValue } }
    func body(content: Content) -> some View {
        let c1 = CGPoint(x: from.x + (to.x - from.x)/2, y: from.y)
        let c2 = CGPoint(x: from.x + (to.x - from.x)/2, y: to.y)
        let t = progress
        let x = pow(1-t, 3) * from.x + 3 * pow(1-t, 2) * t * c1.x + 3 * (1-t) * pow(t, 2) * c2.x + pow(t, 3) * to.x
        let y = pow(1-t, 3) * from.y + 3 * pow(1-t, 2) * t * c1.y + 3 * (1-t) * pow(t, 2) * c2.y + pow(t, 3) * to.y
        return content.position(x: x, y: y)
    }
}

struct ConnectionLine: View {
    let from: CGPoint; let to: CGPoint; let progress: CGFloat; let isRunning: Bool
    var body: some View {
        ZStack {
            Path { path in
                path.move(to: from)
                let c1 = CGPoint(x: from.x + (to.x - from.x)/2, y: from.y)
                let c2 = CGPoint(x: from.x + (to.x - from.x)/2, y: to.y)
                path.addCurve(to: to, control1: c1, control2: c2)
            }
            .stroke(Color.white.opacity(0.1), lineWidth: 2)
            
            if isRunning {
                Circle().fill(Color.cyan).frame(width: 5, height: 5).shadow(color: .cyan, radius: 3)
                    .modifier(FollowPathModifier(from: from, to: to, progress: progress))
            }
        }
    }
}

struct NodeView: View {
    let node: Node; var onDrag: (CGSize) -> Void
    var body: some View {
        HStack(spacing: 6) {
            Circle().fill(Color.cyan).frame(width: 5, height: 5)
            Text(node.name).font(.system(size: 9, weight: .bold)).monospaced()
        }
        .padding(8).background(Color.black.opacity(0.7)).cornerRadius(6)
        .overlay(RoundedRectangle(cornerRadius: 6).stroke(Color.white.opacity(0.1), lineWidth: 1))
        .position(node.position)
        .gesture(DragGesture().onChanged { onDrag($0.translation) })
    }
}

// MARK: - Main Sections

struct SidebarView: View {
    @ObservedObject var viewModel: MissionControlViewModel
    var body: some View {
        List {
            Section("AGENTS") {
                ForEach(viewModel.agents) { agent in
                    Label(agent.name, systemImage: "brain.head.profile").font(.subheadline)
                }
            }
            Section("LIBRARY") {
                Label("Workflows", systemImage: "rectangle.3.group")
                Label("Executions", systemImage: "clock.fill")
            }
        }.listStyle(.sidebar)
    }
}

struct WorkflowCanvasView: View {
    @ObservedObject var viewModel: MissionControlViewModel
    var body: some View {
        ZStack {
            VisualEffectView(material: .underWindowBackground, blendingMode: .behindWindow)
            
            // Nodes & Connections
            ZStack {
                ForEach(viewModel.connections) { conn in
                    if let f = viewModel.nodes.first(where: { $0.id == conn.fromId }),
                       let t = viewModel.nodes.first(where: { $0.id == conn.toId }) {
                        ConnectionLine(from: f.position, to: t.position, progress: viewModel.flowProgress, isRunning: viewModel.isRunning)
                    }
                }
                ForEach(viewModel.nodes) { node in
                    NodeView(node: node) { trans in viewModel.moveNode(id: node.id, translation: trans) }
                }
            }
            
            VStack {
                HStack {
                    Text("NODE ORCHESTRATOR").font(.caption2).monospaced().foregroundColor(.cyan)
                    Spacer()
                    Button(action: { viewModel.runAutomation() }) {
                        Image(systemName: viewModel.isRunning ? "stop.circle.fill" : "play.circle.fill")
                            .font(.title2).foregroundColor(viewModel.isRunning ? .red : .green)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                .padding()
                Spacer()
                SystemOutputView(viewModel: viewModel)
            }
        }
    }
}

struct SystemOutputView: View {
    @ObservedObject var viewModel: MissionControlViewModel
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 4) {
                ForEach(viewModel.logs) { log in
                    HStack(spacing: 8) {
                        Text(log.time).foregroundColor(.secondary)
                        Text(log.tag).foregroundColor(log.color).bold()
                        Text(log.msg)
                    }.font(.system(size: 8, design: .monospaced))
                }
            }
        }
        .frame(height: 140).padding(8).background(Color.black.opacity(0.3)).cornerRadius(8).padding()
    }
}

struct InspectorView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("INSPECTOR").font(.caption).bold().foregroundColor(.secondary)
            VStack(alignment: .leading, spacing: 8) {
                Label("Engine Sync", systemImage: "checkmark.circle.fill").foregroundColor(.green)
                Text("Standard Latency: 12ms").font(.caption2).foregroundColor(.secondary)
            }
            Divider().opacity(0.2)
            VStack(alignment: .leading, spacing: 10) {
                Text("RESOURCES").font(.caption2).secondary()
                HStack { Image(systemName: "cpu"); Text("4.2%").bold() }
                HStack { Image(systemName: "memorychip"); Text("128MB").bold() }
            }.font(.caption2)
            Spacer()
        }.padding().frame(width: 220)
    }
}

extension View { func secondary() -> some View { self.foregroundColor(.secondary) } }

struct ContentView: View {
    @StateObject var viewModel = MissionControlViewModel()
    var body: some View {
        NavigationSplitView {
            SidebarView(viewModel: viewModel)
        } detail: {
            HStack(spacing: 0) {
                WorkflowCanvasView(viewModel: viewModel)
                Divider().opacity(0.2)
                InspectorView()
            }
        }
        .navigationTitle("RPA Mission Control")
        .navigationSubtitle("Connected to Agnostix Hub")
    }
}

// MARK: - Entry Point

@main
struct AppLauncher {
    static func main() {
        let app = NSApplication.shared
        let delegate = AppDelegate()
        app.delegate = delegate
        app.run()
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    var window: NSWindow!
    func applicationDidFinishLaunching(_ n: Notification) {
        window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 1250, height: 800),
            styleMask: [.titled, .closable, .miniaturizable, .resizable, .fullSizeContentView],
            backing: .buffered, defer: false)
        window.center()
        window.contentView = NSHostingView(rootView: ContentView())
        window.makeKeyAndOrderFront(nil)
        window.titleVisibility = .hidden
        window.titlebarAppearsTransparent = true
        window.isMovableByWindowBackground = true
    }
}
