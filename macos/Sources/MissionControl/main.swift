import Foundation

/// Orchestrator for rpamarlow automations.
/// Inspired by UiPath/BotCity, built for the AI era.
@main
struct MissionControl {
    static func main() {
        print("🚀 RPA Mission Control starting...")
        print("Mapeando automações locais...")
        
        let automationPath = "/Users/marlow/Documents/workspace/resources/automation/scripts"
        let fm = FileManager.default
        
        do {
            let files = try fm.contentsOfDirectory(atPath: automationPath)
            for file in files where file.hasSuffix(".py") {
                print("  found deterministic automation: \(file)")
            }
        } catch {
            print("Error mapping automations: \(error)")
        }
    }
}
